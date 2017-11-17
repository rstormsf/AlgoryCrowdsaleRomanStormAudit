# AlgoryCrowdsale 
Source file [../../contracts/crowdsale/AlgoryCrowdsale.sol](../../contracts/crowdsale/AlgoryCrowdsale.sol).


<br />

<hr />

```javascript
// RS Ok
pragma solidity ^0.4.15;

// RS Ok
import './InvestmentPolicyCrowdsale.sol';
import './PricingStrategy.sol';
import '../token/CrowdsaleToken.sol';
import './FinalizeAgent.sol';
import '../math/SafeMath.sol';
// RS Ok
contract AlgoryCrowdsale is InvestmentPolicyCrowdsale {

    /* Max investment count when we are still allowed to change the multisig address */
    // RS Ok
    uint constant public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
    // RS Ok
    using SafeMath for uint;

    /* The token we are selling */
    // RS Ok
    CrowdsaleToken public token;

    /* How we are going to price our offering */
    // RS Ok
    PricingStrategy public pricingStrategy;

    /* Post-success callback */
    // RS Ok
    FinalizeAgent public finalizeAgent;

    /* tokens will be transfered from this address */
    // RS Ok
    address public multisigWallet;

    /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
    // RS Ok
    address public beneficiary;

    /* the UNIX timestamp start date of the presale */
    // RS Ok
    uint public presaleStartsAt;

    /* the UNIX timestamp start date of the crowdsale */
    // RS Ok
    uint public startsAt;

    /* the UNIX timestamp end date of the crowdsale */
    // RS Ok
    uint public endsAt;

    /* the number of tokens already sold through this contract*/
    // RS Ok
    uint public tokensSold = 0;

    /* How many wei of funding we have raised */
    // RS Ok
    uint public weiRaised = 0;

    /** How many wei we have in whitelist declarations*/
    // RS Ok
    uint public whitelistWeiRaised = 0;

    /* Calculate incoming funds from presale contracts and addresses */
    // RS Ok
    uint public presaleWeiRaised = 0;

    /* How many distinct addresses have invested */
    // RS Ok
    uint public investorCount = 0;

    /* How much wei we have returned back to the contract after a failed crowdfund. */
    // RS Ok
    uint public loadedRefund = 0;

    /* How much wei we have given back to investors.*/
    // RS Ok
    uint public weiRefunded = 0;

    /* Has this crowdsale been finalized */
    // RS Ok
    bool public finalized = false;

    /* Allow investors refund theirs money */
    // RS Ok
    bool public allowRefund = false;

    // Has tokens preallocated */
    // RS Ok
    bool private isPreallocated = false;

    /** How much ETH each address has invested to this crowdsale */
    // RS Ok
    mapping (address => uint256) public investedAmountOf;

    /** How much tokens this crowdsale has credited for each investor address */
    // RS Ok
    mapping (address => uint256) public tokenAmountOf;

    /** Addresses and amount in weis that are allowed to invest even before ICO official opens. */
    // RS Ok
    mapping (address => uint) public earlyParticipantWhitelist;

    /** State machine
     *
     * - Preparing: All contract initialization calls and variables have not been set yet
     * - PreFunding: We have not passed start time yet, allow buy for whitelisted participants
     * - Funding: Active crowdsale
     * - Success: Passed end time or crowdsale is full (all tokens sold)
     * - Finalized: The finalized has been called and successfully executed
     * - Refunding: Refunds are loaded on the contract for reclaim.
     */

    // RS Ok
    enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}

    // A new investment was made
    //RS Ok
    event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);

    // Refund was processed for a contributor
    //RS Ok
    event Refund(address investor, uint weiAmount);

    // Address early participation whitelist status changed
    //RS Ok
    event Whitelisted(address addr, uint value);

    // Crowdsale time boundary has changed
    //RS Ok
    event TimeBoundaryChanged(string timeBoundary, uint timestamp);

    /** Modified allowing execution only if the crowdsale is currently running.  */
    //RS Ok
    modifier inState(State state) {
        require(getState() == state);
        _;
    }
    //RS Ok
    function AlgoryCrowdsale(address _token, address _beneficiary, PricingStrategy _pricingStrategy, address _multisigWallet, uint _presaleStart, uint _start, uint _end) public {
        //RS Ok
        owner = msg.sender;
        //RS Ok
        token = CrowdsaleToken(_token);
        //RS Ok
        beneficiary = _beneficiary;
        //RS Ok
        presaleStartsAt = _presaleStart;
        //RS Ok
        startsAt = _start;
        //RS Ok
        endsAt = _end;
        // RS Ok. I'd recommend it to move it to the top 
        require(now < presaleStartsAt && presaleStartsAt <= startsAt && startsAt < endsAt);
        // RS Ok
        setPricingStrategy(_pricingStrategy);
        //RS Ok
        setMultisigWallet(_multisigWallet);
        //RS Ok, However I'd advise to move requrire and assert statemenets at the top
        require(beneficiary != 0x0 && address(token) != 0x0);
        assert(token.balanceOf(beneficiary) == token.totalSupply());

    }

    //RS Not Ok. Owners can call multiple times. Needs extra check
    function prepareCrowdsale() onlyOwner external {
        //RS Ok
        assert(isAllTokensApproved());
        //RS Ok
        preallocateTokens();
        //RS Ok
        isPreallocated = true;
    }

    /**
     * Allow to send money and get tokens.
     */
    //RS Ok
    function() payable {
        //RS Ok
        assert(!requireCustomerId); // Crowdsale needs to track participants for thank you email
        //RS Ok
        assert(!requiredSignedAddress); // Crowdsale allows only server-side signed participants
        //RS Ok
        investInternal(msg.sender, 0);
    }
    //RS Not ok. Fallbacks are enabled. This check is redundant.
    function isCrowdsale() external constant returns (bool) {
        //RS Ok
        return true;
    }

    // ONLY BY OWNER
    //RS Ok
    function setFinalizeAgent(FinalizeAgent agent) onlyOwner external{
        //RS Ok
        finalizeAgent = agent;
        //RS Ok
        require(finalizeAgent.isFinalizeAgent());
        //RS Ok
        require(finalizeAgent.isSane());
    }
    //RS Ok
    function setPresaleStartsAt(uint presaleStart) inState(State.Preparing) onlyOwner external {
        //RS Ok
        require(presaleStart <= startsAt && presaleStart < endsAt);
        //RS Ok
        presaleStartsAt = presaleStart;
        //RS Ok
        TimeBoundaryChanged('presaleStartsAt', presaleStartsAt);
    }
    //RS Ok
    function setStartsAt(uint start) onlyOwner external {
        //RS Ok
        require(presaleStartsAt < start && start < endsAt);
        //RS Ok
        State state = getState();
        //RS Ok
        assert(state == State.Preparing || state == State.PreFunding);
        //RS Ok
        startsAt = start;
        //RS Ok
        TimeBoundaryChanged('startsAt', startsAt);
    }
    //RS Ok
    function setEndsAt(uint end) onlyOwner external {
        //RS Ok
        require(end > startsAt && end > presaleStartsAt);
        //RS Ok
        endsAt = end;
        //RS Ok
        TimeBoundaryChanged('endsAt', endsAt);
    }

    /**
     * Set array of address and values to whitelist
     */
    //RS Ok
    function loadEarlyParticipantsWhitelist(address[] participantsArray, uint[] valuesArray) onlyOwner external {
        //RS Ok
        address participant = 0x0;
        //RS Ok
        uint value = 0;
        //RS Ok
        for (uint i = 0; i < participantsArray.length; i++) {
            //RS Ok
            participant = participantsArray[i];
            //RS Ok
            value = valuesArray[i];
            //RS Ok. The function declares how much wei an investor contribute
            setEarlyParticipantWhitelist(participant, value);
        }
    }

    /**
     * Finalize a successful crowdsale.
     *
     * The owner can trigger a call the contract that provides post-crowdsale actions, like releasing the tokens.
     */
    //RS Ok
    function finalize() inState(State.Success) onlyOwner whenNotPaused external {
        // Already finalized
        //RS Ok. Use require instead of assert
        assert(!finalized);
        //RS Ok
        finalizeAgent.finalizeCrowdsale();
        //RS Ok
        finalized = true;
    }

    /** This is for manual allow refunding */
    //RS Ok
    function allowRefunding(bool val) onlyOwner external {
        //RS Ok
        State state = getState();
        //RS Ok
        assert(paused || state == State.Success || state == State.Failure || state == State.Refunding);
        //RS Ok
        allowRefund = val;
    }

    /**
     * Allow load refunds back on the contract for the refunding.
     * The team can transfer the funds back on the smart contract in the case when is set refunding mode
     */
    //RS Ok
    function loadRefund() inState(State.Failure) external payable {
        //RS Ok
        require(msg.value != 0);
        //RS Ok
        loadedRefund = loadedRefund.add(msg.value);
    }
    //RS Ok
    function refund() inState(State.Refunding) external {
        //RS Ok. Use require
        assert(allowRefund);
        //RS Ok
        uint256 weiValue = investedAmountOf[msg.sender];
        //RS Ok. Use require
        assert(weiValue != 0);
        //RS Ok
        investedAmountOf[msg.sender] = 0;
        //RS Ok
        weiRefunded = weiRefunded.add(weiValue);
        //RS Ok
        Refund(msg.sender, weiValue);
        //RS Ok. Use transfer vs send without assert
        assert(msg.sender.send(weiValue));
    }
    //RS Ok
    function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner public {
        //RS Ok
        State state = getState();
        //RS Ok
        if (state == State.PreFunding || state == State.Funding) {
            //RS Ok. Use require
            assert(paused);
        }
        //RS Ok
        pricingStrategy = _pricingStrategy;
        //RS Ok. Move statement before changing state
        require(pricingStrategy.isPricingStrategy());
        //RS Not Ok. Remove uncommented code
        //        require(pricingStrategy.isSane(address(this)));
    }
    //RS Ok
    function setMultisigWallet(address wallet) onlyOwner public {
        //RS Ok
        require(wallet != 0x0);
        //RS Ok
        assert(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
        //RS Ok
        multisigWallet = wallet;
    }

    /**
     * Allow addresses to do early participation.
     */
    //RS Ok
    function setEarlyParticipantWhitelist(address participant, uint value) onlyOwner public {
        //RS Ok
        require(value != 0 && participant != 0x0);
        //RS Ok
        require(value <= pricingStrategy.getPresaleMaxValue());
        //RS Ok
        assert(!pricingStrategy.isPresaleFull(whitelistWeiRaised));
        //RS Ok
        earlyParticipantWhitelist[participant] = value;
        //RS Ok
        whitelistWeiRaised = whitelistWeiRaised.add(value);
        Whitelisted(participant, value);
    }
    //RS Ok
    function getTokensLeft() public constant returns (uint) {
        //RS Ok
        return token.allowance(beneficiary, this);
    }

    /**
     * We are sold out when our approve pool becomes empty.
     */
    //RS Ok
    function isCrowdsaleFull() public constant returns (bool) {
        //RS Ok
        return getTokensLeft() == 0;
    }


    /**
     * Crowdfund state machine management.
     */
    //RS Ok
    function getState() public constant returns (State) {
        //RS Ok
        if(finalized) return State.Finalized;
        //RS Ok
        else if (!isPreallocated) return State.Preparing;
        //RS Ok
        else if (address(finalizeAgent) == 0) return State.Preparing;
        //RS Ok
        else if (block.timestamp < presaleStartsAt) return State.Preparing;
        //RS Ok
        else if (block.timestamp >= presaleStartsAt && block.timestamp < startsAt) return State.PreFunding;
        //RS Ok
        else if (block.timestamp <= endsAt && block.timestamp >= startsAt && !isCrowdsaleFull()) return 
        State.Funding;
        //RS Ok
        else if (!allowRefund && isCrowdsaleFull()) return State.Success;
        //RS Ok
        else if (!allowRefund && block.timestamp > endsAt) return State.Success;
        //RS Ok
        else if (allowRefund && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
        //RS Ok
        else return State.Failure;
    }


    /** Check is crowdsale can be able to transfer all tokens from beneficiary */
    //RS Ok
    function isAllTokensApproved() private constant returns (bool) {
        //RS Ok
        return getTokensLeft() == token.totalSupply() - tokensSold
        //RS Ok
                && token.transferAgents(beneficiary);
    }


    /**
     * Called from invest() to confirm if the current investment does not break our cap rule.
     */
    //RS Ok
    function isBreakingCap(uint tokenAmount) private constant returns (bool limitBroken) {
        //RS Ok
        return tokenAmount > getTokensLeft();
    }

    //RS Ok
    function investInternal(address receiver, uint128 customerId) whenNotPaused internal{
        //RS Ok
        State state = getState();
        //RS Ok
        uint weiAmount = msg.value;
        //RS Ok
        uint tokenAmount = 0;
        //RS Ok. Use require, move statement to the top
        assert(state == State.PreFunding || state == State.Funding);
        //RS Ok
        if (state == State.PreFunding) {
            //RS Ok. Use require
            assert(earlyParticipantWhitelist[receiver] > 0);
            //RS Ok
            require(weiAmount <= earlyParticipantWhitelist[receiver]);
            //RS Ok
            assert(!pricingStrategy.isPresaleFull(presaleWeiRaised));
        }
        //RS Ok
        tokenAmount = pricingStrategy.getAmountOfTokens(weiAmount, weiRaised);
        //RS Ok. Use require
        assert(tokenAmount > 0);
        //RS Ok
        if (investedAmountOf[receiver] == 0) {
            //RS Ok
            investorCount++;
        }
        //RS Ok
        investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
        //RS Ok
        tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
        //RS Ok
        weiRaised = weiRaised.add(weiAmount);
        //RS Ok
        tokensSold = tokensSold.add(tokenAmount);
        //RS Ok
        if (state == State.PreFunding) {
            //RS Ok
            presaleWeiRaised = presaleWeiRaised.add(weiAmount);
            //RS Ok
            earlyParticipantWhitelist[receiver] = earlyParticipantWhitelist[receiver].sub(weiAmount);
        }
        //RS Ok. Use require
        assert(!isBreakingCap(tokenAmount));
        //RS Ok
        assignTokens(receiver, tokenAmount);
        //RS Ok. Use require
        assert(multisigWallet.send(weiAmount));
        //RS Ok
        Invested(receiver, weiAmount, tokenAmount, customerId);
    }

    /**
     * Transfer tokens from approve() pool to the buyer.
     *
     * Use approve() given to this crowdsale to distribute the tokens.
     */
    //RS Ok
    function assignTokens(address receiver, uint tokenAmount) private {
        //RS Ok. Use require
        assert(token.transferFrom(beneficiary, receiver, tokenAmount));
    }

    /**
     * Preallocate tokens for developers, company and bounty
     */
    //RS Ok
    function preallocateTokens() private {
        //RS Not Ok. If anything else TODO, please finish it
//        TODO:
        //RS Ok 
        uint multiplier = 10 ** 18;
        //RS Ok
        assignTokens(0x58FC33aC6c7001925B4E9595b13B48bA73690a39, 6450000 * multiplier); // developers
        //RS Ok
        assignTokens(0x78534714b6b02996990cd567ebebd24e1f3dfe99, 6400000 * multiplier); // company
        //RS Ok
        assignTokens(0xd64a60de8A023CE8639c66dAe6dd5f536726041E, 2400000 * multiplier); // bounty
    }

}
```