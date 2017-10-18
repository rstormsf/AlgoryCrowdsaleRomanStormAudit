pragma solidity ^0.4.15;

import '../ownership/Haltable.sol';
import './PricingStrategy.sol';
import '../token/FractionalERC20.sol';
import './FinalizeAgent.sol';
import '../math/SafeMathLib.sol';

contract AlgoryCrowdsale is Haltable {

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

    /* Do we need to have unique contributor id for each customer */
    bool public requireCustomerId = false;

    /**
      * Do we verify that contributor has been cleared on the server side (accredited investors only).
      * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
      */
    bool public requiredSignedAddress = false;

    /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
    address public signerAddress;

    /** How much ETH each address has invested to this crowdsale */
    mapping (address => uint256) public investedAmountOf;

    /** How much tokens this crowdsale has credited for each investor address */
    mapping (address => uint256) public tokenAmountOf;

    /** Addresses and amount in weis that are allowed to invest even before ICO official opens. */
    mapping (address => uint) public earlyParticipantWhitelist;

    /** How many wei we have in whitelist declarations*/
    uint whitelistWeiRaised = 0;

    /** This is for manual testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
    uint public ownerTestValue;

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

    // The rules were changed what kind of investments we accept
    event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);

    // Address early participation whitelist status changed
    event Whitelisted(address addr, bool status);

    // Crowdsale end time has been changed
    event EndsAtChanged(uint newEndsAt);

    // Presale start time has been changed
    event PresaleStartsAtChanged(uint newPresaleStartsAt);

    //
    // Modifiers
    //
    /** Modified allowing execution only if the crowdsale is currently running.  */
    modifier inState(State state) {
        if(getState() != state) revert();
        _;
    }

    function AlgoryCrowdsale(address _token, address _beneficiary, PricingStrategy _pricingStrategy, address _multisigWallet, uint _presaleStart, uint _start, uint _end) {
        owner = msg.sender;
        token = FractionalERC20(_token);
        beneficiary = _beneficiary;
        setPricingStrategy(_pricingStrategy);
        multisigWallet = _multisigWallet;
        presaleStartsAt = _presaleStart;
        startsAt = _start;
        endsAt = _end;

        if(beneficiary == 0 || token == 0 || multisigWallet == 0 || start == 0 || presaleStart == 0 || end == 0) revert();
        if(startsAt >= endsAt) revert();
        if(presaleStartsAt >= startsAt) revert();
        if(token.allowance(beneficiary, owner) != token.totalSupply()) revert();

        preallocateTokens();
    }

    /**
     * Allow to send money and get tokens.
     */
    function() payable {
        invest(msg.sender);
    }

    /**
     * Invest to tokens, recognize the payer and clear his address.
     *
     */
    function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
        investWithSignedAddress(msg.sender, customerId, v, r, s);
    }

    /**
     * Invest to tokens, recognize the payer.
     *
     */
    function buyWithCustomerId(uint128 customerId) public payable {
        investWithCustomerId(msg.sender, customerId);
    }

    /**
     * Allow anonymous contributions to this crowdsale.
     */
    function invest(address addr) public payable {
        if(requireCustomerId) revert(); // Crowdsale needs to track partipants for thank you email
        if(requiredSignedAddress) revert(); // Crowdsale allows only server-side signed participants
        investInternal(addr, 0);
    }

    /**
     * Allow anonymous contributions to this crowdsale.
     */
    function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
        bytes32 hash = sha256(addr);
        if (ecrecover(hash, v, r, s) != signerAddress) revert();
        if(customerId == 0) revert();  // UUIDv4 sanity check
        investInternal(addr, customerId);
    }

    /**
     * Track who is the customer making the payment so we can send thank you email.
     */
    function investWithCustomerId(address addr, uint128 customerId) public payable {
        if(requiredSignedAddress) revert(); // Crowdsale allows only server-side signed participants
        if(customerId == 0) revert();  // UUIDv4 sanity check
        investInternal(addr, customerId);
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
     * Set policy if all investors must be cleared on the server side first.
     *
     * This is e.g. for the accredited investor clearing.
     *
     */
    function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
        requiredSignedAddress = value;
        signerAddress = _signerAddress;
        InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
    }

    /**
     * Allow addresses to do early participation.
     */
    function setEarlyParticipantWhitelist(address addr, uint value) onlyOwner {
        if (value == 0) revert();
        if (!pricingStrategy.isPresaleFull()) revert();
        if (value > pricingStrategy.getPresaleMaxValue()) revert();
        earlyParticipantWhitelist[addr] = value;
        whitelistWeiRaised.plus(value);
        Whitelisted(addr, value);
    }

    /**
     * Set array of address and values to whitelist
     */
    function loadEarlyParticipantsWhitelist(address[] toArray, uint[] valueArray) onlyOwner() {
        uint tokens = 0;
        address to = 0x0;
        uint value = 0;
        uint tokenAmount = 0;

        for (uint i = 0; i < toArray.length; i++) {
            to = toArray[i];
            value = valueArray[i];
            setEarlyParticipantWhitelist(to, value);
        }
    }

    /**
     * Allow to (re)set finalize agent.
     *
     * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
     */
    function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
        finalizeAgent = addr;
        // Don't allow setting bad agent
        if(!finalizeAgent.isFinalizeAgent()) revert();
    }

    /**
     * Allow to (re)set pricing strategy.
     *
     * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
     */
    function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner {
        // Don't allow setting bad agent
        if(!pricingStrategy.isPricingStrategy()) revert();
        pricingStrategy = _pricingStrategy;
    }

    /**
     * Allow to change the team multisig address in the case of emergency.
     *
     * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
     * (we have done only few test transactions). After the crowdsale is going
     * then multisig address stays locked for the safety reasons.
     */
    function setMultisig(address addr) public onlyOwner {
        if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) revert();
        multisigWallet = addr;
    }

    /**
     * Set policy do we need to have server-side customer ids for the investments.
     *
     */
    function setRequireCustomerId(bool value) onlyOwner {
        requireCustomerId = value;
        InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
    }


    /** This is for manual testing of multisig wallet interaction */
    function setOwnerTestValue(uint val) onlyOwner {
        ownerTestValue = val;
    }

    /**
     * Allow crowdsale owner to close early or extend the crowdsale.
     *
     * This is useful e.g. for a manual soft cap implementation:
     * - after X amount is reached determine manual closing
     *
     * This may put the crowdsale to an invalid state,
     * but we trust owners know what they are doing.
     *
     */
    function setEndsAt(uint time) onlyOwner {
        if(now > time) revert(); // Don't change past
        endsAt = time;
        EndsAtChanged(endsAt);
    }

    function setPresaleStartsAt(uint time) inState(State.Preparing) onlyOwner {
        if(time > now) revert(); // Allow only if presale is not started
        presaleStartsAt = time;
        PresaleStartsAtChanged(presaleStartsAt);
    }

    /** This is for manual allow refunding */
    function allowRefunding(bool val) onlyOwner {
        allowRefund = val;
    }

    /**
     * Check if the contract relationship looks good.
     */
    function isFinalizerSane() public constant returns (bool sane) {
        return finalizeAgent.isSane();
    }

    /**
     * Check if the contract relationship looks good.
     */
    function isPricingSane() public constant returns (bool sane) {
        return pricingStrategy.isSane(address(this));
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
        else if (presaleStartsAt >= block.timestamp && block.timestamp < startsAt) return State.PreFunding;
        else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
        else if (!allowRefund) return State.Success;
        else if (allowRefund && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
        else return State.Failure;
    }

    /**
     * Called from invest() to confirm if the current investment does not break our cap rule.
     */
    function isBreakingCap(uint tokenAmount) constant returns (bool limitBroken) {
        return tokenAmount > getTokensLeft();
    }

    /**
     * Get the amount of unsold tokens allocated to this contract;
     */
    function getTokensLeft() public constant returns (uint) {
        return token.allowance(owner, this);
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
        if(msg.value == 0) revert();
        loadedRefund = loadedRefund.plus(msg.value);
    }

    /**
     * Investors can claim refund.
     *
     * Note that any refunds from proxy buyers should be handled separately,
     * and not through this contract.
     */
    function refund() public inState(State.Refunding) {
        uint256 weiValue = investedAmountOf[msg.sender];
        if (weiValue == 0) revert();
        investedAmountOf[msg.sender] = 0;
        weiRefunded = weiRefunded.plus(weiValue);
        Refund(msg.sender, weiValue);
        if (!msg.sender.send(weiValue)) revert();
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
    function investInternal(address receiver, uint128 customerId) stopInEmergency private {

        if (getState() == State.PreFunding) {
            if (earlyParticipantWhitelist[receiver] > 0) revert();
            if (pricingStrategy.isPresaleFull(presaleWeiRaised)) revert();
        } else if(getState() != State.Funding) {
            revert();
        }

        uint weiAmount = msg.value;
        uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised, token.decimals());

        if (tokenAmount == 0) revert();

        if (investedAmountOf[receiver] == 0) {
            investorCount++;
        }

        investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
        tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);

        weiRaised = weiRaised.plus(weiAmount);
        tokensSold = tokensSold.plus(tokenAmount);

        if (getState() == State.PreFunding) {
            if (presaleWeiRaised > earlyParticipantWhitelist[receiver]) revert();
            presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
        }

        if(isBreakingCap(tokenAmount)) revert();

        assignTokens(receiver, tokenAmount);
        if(!multisigWallet.send(weiAmount)) revert();

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
        //TODO:
//        assignTokens('address1', 7777);
//        assignTokens('address2', 7777);
//        assignTokens('address3', 7777);
//        assignTokens('address4', 7777);
//        assignTokens('address5', 7777);
//        assignTokens('address6', 7777);
    }

}