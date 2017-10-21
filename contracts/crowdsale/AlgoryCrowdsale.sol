pragma solidity ^0.4.15;

import './InvestmentPolicyCrowdsale.sol';
import './PricingStrategy.sol';
import '../token/FractionalERC20.sol';
import './FinalizeAgent.sol';
import '../math/SafeMathLib.sol';

contract AlgoryCrowdsale is InvestmentPolicyCrowdsale {

    /* Max investment count when we are still allowed to change the multisig address */
    uint constant public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;

    using SafeMathLib for uint;

    /* The token we are selling */
    FractionalERC20 public token;

    /* How we are going to price our offering */
    PricingStrategy public pricingStrategy;

    /* Post-success callback */
    FinalizeAgent public finalizeAgent;

    /* tokens will be transfered from this address */
    address public multisigWallet;

    /* the UNIX timestamp start date of the crowdsale */
    uint public startsAt;

    /* the UNIX timestamp end date of the crowdsale */
    uint public endsAt;

    /* the UNIX timestamp start date of the presale */
    uint public presaleStartsAt;

    /* the number of tokens already sold through this contract*/
    uint public tokensSold = 0;

    /* How many wei of funding we have raised */
    uint public weiRaised = 0;

    /* Calculate incoming funds from presale contracts and addresses */
    uint public presaleWeiRaised = 0;

    /* How many distinct addresses have invested */
    uint public investorCount = 0;

    /* How much wei we have returned back to the contract after a failed crowdfund. */
    uint public loadedRefund = 0;

    /* How much wei we have given back to investors.*/
    uint public weiRefunded = 0;

    /* Has this crowdsale been finalized */
    bool public finalized = false;

    /* Allow investors refund theirs money */
    bool public allowRefund = false;

    /** How much ETH each address has invested to this crowdsale */
    mapping (address => uint256) public investedAmountOf;

    /** How much tokens this crowdsale has credited for each investor address */
    mapping (address => uint256) public tokenAmountOf;

    /** Addresses and amount in weis that are allowed to invest even before ICO official opens. */
    mapping (address => uint) public earlyParticipantWhitelist;

    /** How many wei we have in whitelist declarations*/
    uint public whitelistWeiRaised = 0;

    /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
    address public beneficiary;

    /** State machine
     *
     * - Preparing: All contract initialization calls and variables have not been set yet
     * - PreFunding: We have not passed start time yet
     * - Funding: Active crowdsale
     * - Success: Minimum funding goal reached
     * - Finalized: The finalized has been called and successfully executed
     * - Refunding: Refunds are loaded on the contract for reclaim.
     */
    enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}

    // A new investment was made
    event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);

    // Refund was processed for a contributor
    event Refund(address investor, uint weiAmount);

    // Address early participation whitelist status changed
    event Whitelisted(address addr, uint value);

    // Crowdsale time boundary has changed
    event TimeBoundaryChanged(string timeBoundary, uint timestamp);

    //
    // Modifiers
    //
    /** Modified allowing execution only if the crowdsale is currently running.  */
    modifier inState(State state) {
        require(getState() == state);
        _;
    }

    function AlgoryCrowdsale(address _token, address _beneficiary, PricingStrategy _pricingStrategy, address _multisigWallet, uint _presaleStart, uint _start, uint _end) public {
        owner = msg.sender;
        token = FractionalERC20(_token);
        beneficiary = _beneficiary;

        presaleStartsAt = _presaleStart;
        startsAt = _start;
        endsAt = _end;

        require(now < presaleStartsAt && presaleStartsAt <= startsAt && startsAt < endsAt);

        setPricingStrategy(_pricingStrategy);
        setMultisigWallet(_multisigWallet);

        require (beneficiary != 0x0 && address(token) != 0x0);
        //Crowdsale can be able to transfer all tokens from beneficiary
        assert(token.allowance(owner, beneficiary) == token.totalSupply());

        preallocateTokens();
    }

    /**
     * Allow to send money and get tokens.
     */
    function() payable {
        invest(msg.sender);
    }

    /**
     * Finalize a successful crowdsale.
     *
     * The owner can trigger a call the contract that provides post-crowdsale actions, like releasing the tokens.
     */
    function finalize() public inState(State.Success) onlyOwner stopInEmergency {
        // Already finalized
        if(finalized) revert();
        // Finalizing is optional. We only call it if we are given a finalizing agent.
        if(address(finalizeAgent) != 0) {
            finalizeAgent.finalizeCrowdsale();
        }
        finalized = true;
    }
    /**
     * Allow addresses to do early participation.
     */
    function setEarlyParticipantWhitelist(address participant, uint value) onlyOwner {
        require(value != 0 && participant != 0x0);
        require(value <= pricingStrategy.getPresaleMaxValue());
        assert(!pricingStrategy.isPresaleFull(presaleWeiRaised));
        earlyParticipantWhitelist[participant] = value;
        whitelistWeiRaised = whitelistWeiRaised.plus(value);
        Whitelisted(participant, value);
    }

    /**
     * Set array of address and values to whitelist
     */
    function loadEarlyParticipantsWhitelist(address[] participantsArray, uint[] valuesArray) onlyOwner() public {
        address participant = 0x0;
        uint value = 0;
        for (uint i = 0; i < participantsArray.length; i++) {
            participant = participantsArray[i];
            value = valuesArray[i];
            setEarlyParticipantWhitelist(participant, value);
        }
    }

    /**
     * Allow to (re)set finalize agent.
     *
     * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
     */
    function setFinalizeAgent(FinalizeAgent agent) onlyOwner public {
        finalizeAgent = agent;
        require(finalizeAgent.isFinalizeAgent());
        require(finalizeAgent.isSane());
    }

    /**
     * Allow to (re)set pricing strategy.
     *
     * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
     */
    function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
        State state = getState();
        if (state == State.PreFunding || state == State.Funding) {
            assert(halted);
        }
        pricingStrategy = _pricingStrategy;
        require(pricingStrategy.isPricingStrategy());
        require(pricingStrategy.isSane(address(this)));
    }

    function setMultisigWallet(address wallet) public onlyOwner {
        require(wallet != 0x0);
        assert(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
        multisigWallet = wallet;
    }

    function setPresaleStartsAt(uint presaleStart) inState(State.Preparing) onlyOwner {
        require(presaleStart <= startsAt && presaleStart < endsAt);
        presaleStartsAt = presaleStart;
        TimeBoundaryChanged('presaleStartsAt', presaleStartsAt);
    }

    function setStartsAt(uint start) onlyOwner {
        require(start > now && start > presaleStartsAt && start < endsAt);
        State state = getState();
        assert(state == State.Preparing || state == State.PreFunding);
        startsAt = start;
        TimeBoundaryChanged('startsAt', startsAt);
    }

    function setEndsAt(uint end) onlyOwner {
        require(end > startsAt && end > startsAt && end > presaleStartsAt);
        endsAt = end;
        TimeBoundaryChanged('endsAt', endsAt);
    }


    /** This is for manual allow refunding */
    function allowRefunding(bool val) inState(State.Failure) onlyOwner {
        allowRefund = val;
    }

    /** Interface marker. */
    function isCrowdsale() public constant returns (bool) {
        return true;
    }

    /**
     * Crowdfund state machine management.
     *
     * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
     */
    function getState() public constant returns (State) {
        if(finalized) return State.Finalized;
        else if (address(finalizeAgent) == 0) return State.Preparing;
        else if (!finalizeAgent.isSane()) return State.Preparing;
        else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
        else if (block.timestamp < presaleStartsAt) return State.Preparing;
        else if (block.timestamp >= presaleStartsAt && block.timestamp < startsAt) return State.PreFunding;
        else if (block.timestamp <= endsAt && block.timestamp >= startsAt && !isCrowdsaleFull()) return State.Funding;
        else if (!allowRefund && block.timestamp > endsAt && isCrowdsaleFull()) return State.Success;
        else if (allowRefund && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
        else return State.Failure;
    }

    /**
     * Called from invest() to confirm if the current investment does not break our cap rule.
     */
    function isBreakingCap(uint tokenAmount) private constant returns (bool limitBroken) {
        return tokenAmount > getTokensLeft();
    }

    /**
     * Get the amount of unsold tokens allocated to this contract;
     */
    function getTokensLeft() public constant returns (uint) {
        return token.allowance(owner, beneficiary);
    }

    /**
     * We are sold out when our approve pool becomes empty.
     */
    function isCrowdsaleFull() public constant returns (bool) {
        return getTokensLeft() == 0;
    }

    /**
     * Allow load refunds back on the contract for the refunding.
     *
     * The team can transfer the funds back on the smart contract in the case when is set refunding mode
     */
    function loadRefund() public payable inState(State.Failure) {
        require(msg.value != 0);
        loadedRefund = loadedRefund.plus(msg.value);
    }

    /**
     * Investors can claim refund.
     *
     * Note that any refunds from proxy buyers should be handled separately,
     * and not through this contract.
     */
    function refund() public inState(State.Refunding) {
        assert(allowRefund);
        uint256 weiValue = investedAmountOf[msg.sender];
        assert(weiValue != 0);
        investedAmountOf[msg.sender] = 0;
        weiRefunded = weiRefunded.plus(weiValue);
        Refund(msg.sender, weiValue);
        assert(msg.sender.send(weiValue));
    }

    /**
     * Make an investment.
     *
     * Crowdsale must be running for one to invest.
     * We must have not pressed the emergency brake.
     *
     * @param receiver The Ethereum address who receives the tokens
     * @param customerId (optional) UUID v4 to track the successful payments on the server side
     *
     */
    function investInternal(address receiver, uint128 customerId) stopInEmergency internal {

        if (getState() == State.PreFunding) {
            assert(earlyParticipantWhitelist[receiver] > 0);
            assert(!pricingStrategy.isPresaleFull(presaleWeiRaised));
        } else if(getState() != State.Funding) {
            revert();
        }

        uint weiAmount = msg.value;
        //TODO !!!!!!!!!!!!!!!!!!!!
//        uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, token.decimals());
        uint tokenAmount = 7777;
        if (tokenAmount == 0) revert();

        if (investedAmountOf[receiver] == 0) {
            investorCount++;
        }

        investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
        tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);

        weiRaised = weiRaised.plus(weiAmount);
        tokensSold = tokensSold.plus(tokenAmount);

        if (getState() == State.PreFunding) {
//            asert(presaleWeiRaised > earlyParticipantWhitelist[receiver]);
            presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
        }

        assert(!isBreakingCap(tokenAmount));

        //TODO !!!!!!!!!!!!!!!!!!!
//        assignTokens(receiver, tokenAmount);

        assert(multisigWallet.send(weiAmount));

        Invested(receiver, weiAmount, tokenAmount, customerId);
    }

    /**
     * Transfer tokens from approve() pool to the buyer.
     *
     * Use approve() given to this crowdsale to distribute the tokens.
     */
    function assignTokens(address receiver, uint tokenAmount) private {
        if(!token.transferFrom(beneficiary, receiver, tokenAmount)) revert();
    }

    /**
     * Preallocate tokens for company, bounty and devs
     */
    function preallocateTokens() private {
//        TODO:
//        assignTokens('address1', 7777);
//        assignTokens('address2', 7777);
//        assignTokens('address3', 7777);
//        assignTokens('address4', 7777);
//        assignTokens('address5', 7777);
//        assignTokens('address6', 7777);
    }

}