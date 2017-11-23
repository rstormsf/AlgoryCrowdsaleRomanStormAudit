pragma solidity ^0.4.15;

// File: contracts/math/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

// File: contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

// File: contracts/crowdsale/PricingStrategy.sol

/**
 * Interface for defining crowdsale pricing.
 */
contract PricingStrategy {

  // How many tokens per one investor is allowed in presale
  uint public presaleMaxValue = 0;

  function isPricingStrategy() external constant returns (bool) {
      return true;
  }

  function getPresaleMaxValue() public constant returns (uint) {
      return presaleMaxValue;
  }

  function isPresaleFull(uint weiRaised) public constant returns (bool);

  function getAmountOfTokens(uint value, uint weiRaised) public constant returns (uint tokensAmount);
}

// File: contracts/crowdsale/AlgoryPricingStrategy.sol

contract AlgoryPricingStrategy is PricingStrategy, Ownable {

    using SafeMath for uint;

    /**
    * Define pricing schedule using tranches.
    */
    struct Tranche {
        // Amount in weis when this tranche becomes active
        uint amount;
        // How many tokens per wei you will get while this tranche is active
        uint rate;
    }

    Tranche[4] public tranches;

    // How many active tranches we have
    uint public trancheCount = 4;

    function AlgoryPricingStrategy() {

        tranches[0].amount = 0;
        tranches[0].rate = 1200;

        tranches[1].amount = 10000 ether;
        tranches[1].rate = 1100;

        tranches[2].amount = 25000 ether;
        tranches[2].rate = 1050;

        tranches[3].amount = 50000 ether;
        tranches[3].rate = 1000;

        trancheCount = tranches.length;
        presaleMaxValue = 300 ether;
    }

    function() public payable {
        revert();
    }

    function getTranche(uint n) external constant returns (uint amount, uint rate) {
        require(n < trancheCount);
        return (tranches[n].amount, tranches[n].rate);
    }

    function isPresaleFull(uint presaleWeiRaised) public constant returns (bool) {
        return presaleWeiRaised > tranches[1].amount;
    }

    function getCurrentRate(uint weiRaised) public constant returns (uint) {
        return getCurrentTranche(weiRaised).rate;
    }

    function getAmountOfTokens(uint value, uint weiRaised) public constant returns (uint tokensAmount) {
        require(value > 0);
        uint rate = getCurrentRate(weiRaised);
        return value.mul(rate);
    }

    function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {
        for(uint i=1; i < tranches.length; i++) {
            if(weiRaised <= tranches[i].amount) {
                return tranches[i-1];
            }
        }
        return tranches[tranches.length-1];
    }
}

// File: contracts/token/ERC20Basic.sol

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
    uint256 public totalSupply;
    function balanceOf(address who) public constant returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: contracts/token/ERC20.sol

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public constant returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/token/StandardToken.sol

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20 {

    using SafeMath for uint256;

    mapping(address => uint256) balances;

    mapping (address => mapping (address => uint256)) internal allowed;

    /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     *
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    /**
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     */
    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

}

// File: contracts/token/BurnableToken.sol

/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
contract BurnableToken is StandardToken {

    event Burn(address indexed burner, uint256 value);

    /**
     * @dev Burns a specific amount of tokens.
     * @param _value The amount of token to be burned.
     */
    function burn(uint256 _value) public {
        require(_value > 0);
        require(_value <= balances[msg.sender]);
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        address burner = msg.sender;
        balances[burner] = balances[burner].sub(_value);
        totalSupply = totalSupply.sub(_value);
        Burn(burner, _value);
    }
}

// File: contracts/token/ReleasableToken.sol

/**
 * Define interface for releasing the token transfer after a successful crowdsale.
 */
contract ReleasableToken is ERC20, Ownable {

    /* The finalizer contract that allows unlift the transfer limits on this token */
    address public releaseAgent;

    /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
    bool public released = false;

    /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
    mapping (address => bool) public transferAgents;

    /**
     * Limit token transfer until the crowdsale is over.
     *
     */
    modifier canTransfer(address _sender) {
        if(!released) {
            assert(transferAgents[_sender]);
        }
        _;
    }

    /**
     * Set the contract that can call release and make the token transferable.
     *
     * Design choice. Allow reset the release agent to fix fat finger mistakes.
     */
    function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
        require(addr != 0x0);
        // We don't do interface check here as we might want to a normal wallet address to act as a release agent
        releaseAgent = addr;
    }

    /**
     * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
     */
    function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
        require(addr != 0x0);
        transferAgents[addr] = state;
    }

    /**
     * One way function to release the tokens to the wild.
     *
     * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
     */
    function releaseTokenTransfer() public onlyReleaseAgent {
        released = true;
    }

    /** The function can be called only before or after the tokens have been releasesd */
    modifier inReleaseState(bool releaseState) {
        require(releaseState == released);
        _;
    }

    /** The function can be called only by a whitelisted release agent. */
    modifier onlyReleaseAgent() {
        require(msg.sender == releaseAgent);
        _;
    }

    function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
        // Call StandardToken.transfer()
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
        // Call StandardToken.transferForm()
        return super.transferFrom(_from, _to, _value);
    }

}

// File: contracts/token/CrowdsaleToken.sol

/**
 * Base crowdsale token interface
 */
contract CrowdsaleToken is BurnableToken, ReleasableToken {
    uint public decimals;
}

// File: contracts/crowdsale/FinalizeAgent.sol

/**
 * Finalize agent defines what happens at the end of successful crowdsale.
 * Allocate tokens for founders, bounties and community
 */
contract FinalizeAgent {

  function isFinalizeAgent() public constant returns(bool) {
    return true;
  }

  /** Return true if we can run finalizeCrowdsale() properly.
   *
   * This is a safety check function that doesn't allow crowdsale to begin
   * unless the finalizer has been set up properly.
   */
  function isSane() public constant returns (bool);

  /** Called once by crowdsale finalize() if the sale was success. */
  function finalizeCrowdsale();

}

// File: contracts/lifecycle/Pausable.sol

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
    event Pause();
    event Unpause();

    bool public paused = false;


    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(paused);
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() onlyOwner whenNotPaused public {
        paused = true;
        Pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() onlyOwner whenPaused public {
        paused = false;
        Unpause();
    }
}

// File: contracts/crowdsale/InvestmentPolicyCrowdsale.sol

contract InvestmentPolicyCrowdsale is Pausable {

    /* Do we need to have unique contributor id for each customer */
    bool public requireCustomerId = false;

    /**
      * Do we verify that contributor has been cleared on the server side (accredited investors only).
      * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
      */
    bool public requiredSignedAddress = false;

    /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
    address public signerAddress;

    event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);

    /**
     * Set policy do we need to have server-side customer ids for the investments.
     *
     */
    function setRequireCustomerId(bool value) onlyOwner external{
        requireCustomerId = value;
        InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
    }

    /**
     * Set policy if all investors must be cleared on the server side first.
     *
     * This is e.g. for the accredited investor clearing.
     *
     */
    function setRequireSignedAddress(bool value, address _signerAddress) external onlyOwner {
        requiredSignedAddress = value;
        signerAddress = _signerAddress;
        InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
    }

    /**
     * Invest to tokens, recognize the payer and clear his address.
     */
    function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) external payable {
        assert(requiredSignedAddress);
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 hash = sha3(prefix, sha3(msg.sender));
        assert(ecrecover(hash, v, r, s) == signerAddress);
        require(customerId != 0);  // UUIDv4 sanity check
        investInternal(msg.sender, customerId);
    }

    /**
     * Invest to tokens, recognize the payer.
     *
     */
    function buyWithCustomerId(uint128 customerId) external payable {
        assert(requireCustomerId);
        require(customerId != 0);
        investInternal(msg.sender, customerId);
    }


    function investInternal(address receiver, uint128 customerId) whenNotPaused internal;
}

// File: contracts/crowdsale/AlgoryCrowdsale.sol

contract AlgoryCrowdsale is InvestmentPolicyCrowdsale {

    /* Max investment count when we are still allowed to change the multisig address */
    uint constant public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;

    using SafeMath for uint;

    /* The token we are selling */
    CrowdsaleToken public token;

    /* How we are going to price our offering */
    PricingStrategy public pricingStrategy;

    /* Post-success callback */
    FinalizeAgent public finalizeAgent;

    /* tokens will be transfered from this address */
    address public multisigWallet;

    /* The party who holds the full token pool and has approve()'ed tokens for this crowdsale */
    address public beneficiary;

    /* the UNIX timestamp start date of the presale */
    uint public presaleStartsAt;

    /* the UNIX timestamp start date of the crowdsale */
    uint public startsAt;

    /* the UNIX timestamp end date of the crowdsale */
    uint public endsAt;

    /* the number of tokens already sold through this contract*/
    uint public tokensSold = 0;

    /* How many wei of funding we have raised */
    uint public weiRaised = 0;

    /** How many wei we have in whitelist declarations*/
    uint public whitelistWeiRaised = 0;

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

    // Has tokens preallocated */
    bool private isPreallocated = false;

    /** How much ETH each address has invested to this crowdsale */
    mapping (address => uint256) public investedAmountOf;

    /** How much tokens this crowdsale has credited for each investor address */
    mapping (address => uint256) public tokenAmountOf;

    /** Addresses and amount in weis that are allowed to invest even before ICO official opens. */
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
    enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}

    // A new investment was made
    event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);

    // Refund was processed for a contributor
    event Refund(address investor, uint weiAmount);

    // Address early participation whitelist status changed
    event Whitelisted(address addr, uint value);

    // Crowdsale time boundary has changed
    event TimeBoundaryChanged(string timeBoundary, uint timestamp);

    /** Modified allowing execution only if the crowdsale is currently running.  */
    modifier inState(State state) {
        require(getState() == state);
        _;
    }

    function AlgoryCrowdsale(address _token, address _beneficiary, PricingStrategy _pricingStrategy, address _multisigWallet, uint _presaleStart, uint _start, uint _end) public {
        owner = msg.sender;
        token = CrowdsaleToken(_token);
        beneficiary = _beneficiary;

        presaleStartsAt = _presaleStart;
        startsAt = _start;
        endsAt = _end;

        require(now < presaleStartsAt && presaleStartsAt <= startsAt && startsAt < endsAt);

        setPricingStrategy(_pricingStrategy);
        setMultisigWallet(_multisigWallet);

        require(beneficiary != 0x0 && address(token) != 0x0);
        assert(token.balanceOf(beneficiary) == token.totalSupply());

    }


    function prepareCrowdsale() onlyOwner external {
        assert(isAllTokensApproved());
        preallocateTokens();
        isPreallocated = true;
    }

    /**
     * Allow to send money and get tokens.
     */
    function() payable {
        assert(!requireCustomerId); // Crowdsale needs to track participants for thank you email
        assert(!requiredSignedAddress); // Crowdsale allows only server-side signed participants
        investInternal(msg.sender, 0);
    }

    function isCrowdsale() external constant returns (bool) {
        return true;
    }

    // ONLY BY OWNER

    function setFinalizeAgent(FinalizeAgent agent) onlyOwner external{
        finalizeAgent = agent;
        require(finalizeAgent.isFinalizeAgent());
        require(finalizeAgent.isSane());
    }

    function setPresaleStartsAt(uint presaleStart) inState(State.Preparing) onlyOwner external {
        require(presaleStart <= startsAt && presaleStart < endsAt);
        presaleStartsAt = presaleStart;
        TimeBoundaryChanged('presaleStartsAt', presaleStartsAt);
    }

    function setStartsAt(uint start) onlyOwner external {
        require(presaleStartsAt < start && start < endsAt);
        State state = getState();
        assert(state == State.Preparing || state == State.PreFunding);
        startsAt = start;
        TimeBoundaryChanged('startsAt', startsAt);
    }

    function setEndsAt(uint end) onlyOwner external {
        require(end > startsAt && end > presaleStartsAt);
        endsAt = end;
        TimeBoundaryChanged('endsAt', endsAt);
    }

    /**
     * Set array of address and values to whitelist
     */
    function loadEarlyParticipantsWhitelist(address[] participantsArray, uint[] valuesArray) onlyOwner external {
        address participant = 0x0;
        uint value = 0;
        for (uint i = 0; i < participantsArray.length; i++) {
            participant = participantsArray[i];
            value = valuesArray[i];
            setEarlyParticipantWhitelist(participant, value);
        }
    }

    /**
     * Finalize a successful crowdsale.
     *
     * The owner can trigger a call the contract that provides post-crowdsale actions, like releasing the tokens.
     */
    function finalize() inState(State.Success) onlyOwner whenNotPaused external {
        // Already finalized
        assert(!finalized);
        finalizeAgent.finalizeCrowdsale();
        finalized = true;
    }

    /** This is for manual allow refunding */
    function allowRefunding(bool val) onlyOwner external {
        State state = getState();
        assert(paused || state == State.Success || state == State.Failure || state == State.Refunding);
        allowRefund = val;
    }

    /**
     * Allow load refunds back on the contract for the refunding.
     * The team can transfer the funds back on the smart contract in the case when is set refunding mode
     */
    function loadRefund() inState(State.Failure) external payable {
        require(msg.value != 0);
        loadedRefund = loadedRefund.add(msg.value);
    }

    function refund() inState(State.Refunding) external {
        assert(allowRefund);
        uint256 weiValue = investedAmountOf[msg.sender];
        assert(weiValue != 0);
        investedAmountOf[msg.sender] = 0;
        weiRefunded = weiRefunded.add(weiValue);
        Refund(msg.sender, weiValue);
        assert(msg.sender.send(weiValue));
    }

    function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner public {
        State state = getState();
        if (state == State.PreFunding || state == State.Funding) {
            assert(paused);
        }
        pricingStrategy = _pricingStrategy;
        require(pricingStrategy.isPricingStrategy());
        //        require(pricingStrategy.isSane(address(this)));
    }

    function setMultisigWallet(address wallet) onlyOwner public {
        require(wallet != 0x0);
        assert(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);
        multisigWallet = wallet;
    }

    /**
     * Allow addresses to do early participation.
     */
    function setEarlyParticipantWhitelist(address participant, uint value) onlyOwner public {
        require(value != 0 && participant != 0x0);
        require(value <= pricingStrategy.getPresaleMaxValue());
        assert(!pricingStrategy.isPresaleFull(whitelistWeiRaised));
        earlyParticipantWhitelist[participant] = value;
        whitelistWeiRaised = whitelistWeiRaised.add(value);
        Whitelisted(participant, value);
    }

    function getTokensLeft() public constant returns (uint) {
        return token.allowance(beneficiary, this);
    }

    /**
     * We are sold out when our approve pool becomes empty.
     */
    function isCrowdsaleFull() public constant returns (bool) {
        return getTokensLeft() == 0;
    }


    /**
     * Crowdfund state machine management.
     */
    function getState() public constant returns (State) {
        if(finalized) return State.Finalized;
        else if (!isPreallocated) return State.Preparing;
        else if (address(finalizeAgent) == 0) return State.Preparing;
        else if (block.timestamp < presaleStartsAt) return State.Preparing;
        else if (block.timestamp >= presaleStartsAt && block.timestamp < startsAt) return State.PreFunding;
        else if (block.timestamp <= endsAt && block.timestamp >= startsAt && !isCrowdsaleFull()) return State.Funding;
        else if (!allowRefund && isCrowdsaleFull()) return State.Success;
        else if (!allowRefund && block.timestamp > endsAt) return State.Success;
        else if (allowRefund && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
        else return State.Failure;
    }


    /** Check is crowdsale can be able to transfer all tokens from beneficiary */
    function isAllTokensApproved() private constant returns (bool) {
        return getTokensLeft() == token.totalSupply() - tokensSold
                && token.transferAgents(beneficiary);
    }


    /**
     * Called from invest() to confirm if the current investment does not break our cap rule.
     */
    function isBreakingCap(uint tokenAmount) private constant returns (bool limitBroken) {
        return tokenAmount > getTokensLeft();
    }


    function investInternal(address receiver, uint128 customerId) whenNotPaused internal{
        State state = getState();
        uint weiAmount = msg.value;
        uint tokenAmount = 0;

        assert(state == State.PreFunding || state == State.Funding);
        if (state == State.PreFunding) {
            assert(earlyParticipantWhitelist[receiver] > 0);
            require(weiAmount <= earlyParticipantWhitelist[receiver]);
            assert(!pricingStrategy.isPresaleFull(presaleWeiRaised));
        }

        tokenAmount = pricingStrategy.getAmountOfTokens(weiAmount, weiRaised);
        assert(tokenAmount > 0);
        if (investedAmountOf[receiver] == 0) {
            investorCount++;
        }

        investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
        tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
        weiRaised = weiRaised.add(weiAmount);
        tokensSold = tokensSold.add(tokenAmount);

        if (state == State.PreFunding) {
            presaleWeiRaised = presaleWeiRaised.add(weiAmount);
            earlyParticipantWhitelist[receiver] = earlyParticipantWhitelist[receiver].sub(weiAmount);
        }

        assert(!isBreakingCap(tokenAmount));

        assignTokens(receiver, tokenAmount);

        assert(multisigWallet.send(weiAmount));

        Invested(receiver, weiAmount, tokenAmount, customerId);
    }

    /**
     * Transfer tokens from approve() pool to the buyer.
     *
     * Use approve() given to this crowdsale to distribute the tokens.
     */
    function assignTokens(address receiver, uint tokenAmount) private {
        assert(token.transferFrom(beneficiary, receiver, tokenAmount));
    }

    /**
     * Preallocate tokens for developers, company and bounty
     */
    function preallocateTokens() private {
//        TODO:
        uint multiplier = 10 ** 18;
        assignTokens(0x58FC33aC6c7001925B4E9595b13B48bA73690a39, 6450000 * multiplier); // developers
        assignTokens(0x78534714b6b02996990cd567ebebd24e1f3dfe99, 6400000 * multiplier); // company
        assignTokens(0xd64a60de8A023CE8639c66dAe6dd5f536726041E, 2400000 * multiplier); // bounty
    }

}

// File: contracts/token/UpgradeAgent.sol

/**
 * Upgrade agent interface inspired by Lunyr.
 *
 * Upgrade agent transfers tokens to a new contract.
 * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
 */
contract UpgradeAgent {

    uint public originalSupply;

    /** Interface marker */
    function isUpgradeAgent() public constant returns (bool) {
        return true;
    }

    function upgradeFrom(address _from, uint256 _value) public;

}

// File: contracts/token/UpgradeableToken.sol

/**
 * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
 *
 * First envisioned by Golem and Lunyr projects.
 */
contract UpgradeableToken is StandardToken {

    /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
    address public upgradeMaster;

    /** The next contract where the tokens will be migrated. */
    UpgradeAgent public upgradeAgent;

    /** How many tokens we have upgraded by now. */
    uint256 public totalUpgraded;

    /**
     * Upgrade states.
     *
     * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
     * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
     * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
     * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
     *
     */
    enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}

    /**
     * Somebody has upgraded some of his tokens.
     */
    event Upgrade(address indexed _from, address indexed _to, uint256 _value);

    /**
     * New upgrade agent available.
     */
    event UpgradeAgentSet(address agent);

    /**
     * Do not allow construction without upgrade master set.
     */
    function UpgradeableToken(address _upgradeMaster) {
        upgradeMaster = _upgradeMaster;
    }

    /**
     * Allow the token holder to upgrade some of their tokens to a new contract.
     */
    function upgrade(uint256 value) public {
        require(value != 0);
        UpgradeState state = getUpgradeState();
        assert(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
        assert(value <= balanceOf(msg.sender));

        balances[msg.sender] = balances[msg.sender].sub(value);

        // Take tokens out from circulation
        totalSupply = totalSupply.sub(value);
        totalUpgraded = totalUpgraded.add(value);

        // Upgrade agent reissues the tokens
        upgradeAgent.upgradeFrom(msg.sender, value);
        Upgrade(msg.sender, upgradeAgent, value);
    }

    /**
     * Set an upgrade agent that handles
     */
    function setUpgradeAgent(address agent) external {
        require(agent != 0x0 && msg.sender == upgradeMaster);
        assert(canUpgrade());
        upgradeAgent = UpgradeAgent(agent);
        assert(upgradeAgent.isUpgradeAgent());
        assert(upgradeAgent.originalSupply() == totalSupply);
        UpgradeAgentSet(upgradeAgent);
    }

    /**
     * Get the state of the token upgrade.
     */
    function getUpgradeState() public constant returns(UpgradeState) {
        if(!canUpgrade()) return UpgradeState.NotAllowed;
        else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
        else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
        else return UpgradeState.Upgrading;
    }

    /**
     * Change the upgrade master.
     *
     * This allows us to set a new owner for the upgrade mechanism.
     */
    function setUpgradeMaster(address master) public {
        require(master != 0x0 && msg.sender == upgradeMaster);
        upgradeMaster = master;
    }

    /**
     * Child contract can enable to provide the condition when the upgrade can begun.
     */
    function canUpgrade() public constant returns(bool) {
        return true;
    }

}

// File: contracts/token/AlgoryToken.sol

/**
 * A Algory token.
 *
 */
contract AlgoryToken is UpgradeableToken, CrowdsaleToken {

    string public name = 'Algory';
    string public symbol = 'ALG';
    uint public decimals = 18;

    uint256 public INITIAL_SUPPLY = 120000000 * (10 ** uint256(decimals));

    event UpdatedTokenInformation(string newName, string newSymbol);

    function AlgoryToken() UpgradeableToken(msg.sender) {
        owner = msg.sender;
        totalSupply = INITIAL_SUPPLY;
        require(totalSupply > 0);
        balances[owner] = totalSupply;
    }

    function canUpgrade() public constant returns(bool) {
        return released && super.canUpgrade();
    }

    function setTokenInformation(string _name, string _symbol) onlyOwner {
        name = _name;
        symbol = _symbol;
        UpdatedTokenInformation(name, symbol);
    }

}

// File: contracts/crowdsale/AlgoryFinalizeAgent.sol

/**
 * At the end of the successful crowdsale unlock tokens transfer.
 *
 */
contract AlgoryFinalizeAgent is FinalizeAgent {

    using SafeMath for uint;

    AlgoryToken public token;
    AlgoryCrowdsale public crowdsale;

    function AlgoryFinalizeAgent(AlgoryToken _token, AlgoryCrowdsale _crowdsale) {
        token = _token;
        crowdsale = _crowdsale;
        require(address(token) != 0x0 && address(crowdsale) != 0x0);
    }

    /* Can we run finalize properly */
    function isSane() public constant returns (bool) {
        return token.releaseAgent() == address(this) && crowdsale.finalizeAgent() == address(this);
    }

    /** Called once by crowdsale finalize() if the sale was success. */
    function finalizeCrowdsale() public {
        require(msg.sender == address(crowdsale));

        // Make token transferable
        token.releaseTokenTransfer();
    }

}
