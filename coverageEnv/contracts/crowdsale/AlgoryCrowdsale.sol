pragma solidity ^0.4.15;

import './InvestmentPolicyCrowdsale.sol';
import './PricingStrategy.sol';
import '../token/CrowdsaleToken.sol';
import './FinalizeAgent.sol';
import '../math/SafeMathLib.sol';

contract AlgoryCrowdsale is InvestmentPolicyCrowdsale {event __CoverageAlgoryCrowdsale(string fileName, uint256 lineNumber);
event __FunctionCoverageAlgoryCrowdsale(string fileName, uint256 fnId);
event __StatementCoverageAlgoryCrowdsale(string fileName, uint256 statementId);
event __BranchCoverageAlgoryCrowdsale(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageAlgoryCrowdsale(string fileName, uint256 branchId);
event __AssertPostCoverageAlgoryCrowdsale(string fileName, uint256 branchId);


    /* Max investment count when we are still allowed to change the multisig address */
    uint constant public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;

    using SafeMathLib for uint;

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
    modifier inState(State state) {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',1);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',104);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',1);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',1);
require(getState() == state);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',1);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',105);
        _;
    }

    function AlgoryCrowdsale(address _token, address _beneficiary, PricingStrategy _pricingStrategy, address _multisigWallet, uint _presaleStart, uint _start, uint _end) public {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',2);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',109);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',2);
owner = msg.sender;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',110);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',3);
token = CrowdsaleToken(_token);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',111);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',4);
beneficiary = _beneficiary;

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',113);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',5);
presaleStartsAt = _presaleStart;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',114);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',6);
startsAt = _start;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',115);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',7);
endsAt = _end;

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',117);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',2);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',8);
require(now < presaleStartsAt && presaleStartsAt <= startsAt && startsAt < endsAt);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',2);


__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',119);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',9);
setPricingStrategy(_pricingStrategy);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',120);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',10);
setMultisigWallet(_multisigWallet);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',122);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',3);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',11);
require(beneficiary != 0x0 && address(token) != 0x0);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',3);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',123);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',4);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',12);
assert(token.balanceOf(beneficiary) == token.totalSupply());__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',4);


    }


    function prepareCrowdsale() onlyOwner external {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',3);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',129);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',5);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',13);
assert(isAllTokensApproved());__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',5);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',130);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',14);
preallocateTokens();
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',131);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',15);
isPreallocated = true;
    }

    /**
     * Allow to send money and get tokens.
     */
    function() payable {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',4);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',138);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',16);
invest(msg.sender);
    }

    function isCrowdsale() external constant returns (bool) {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',5);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',142);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',17);
return true;
    }

    // ONLY BY OWNER

    function setFinalizeAgent(FinalizeAgent agent) onlyOwner external{__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',6);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',148);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',18);
finalizeAgent = agent;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',149);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',6);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',19);
require(finalizeAgent.isFinalizeAgent());__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',6);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',150);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',7);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',20);
require(finalizeAgent.isSane());__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',7);

    }

    function setPresaleStartsAt(uint presaleStart) inState(State.Preparing) onlyOwner external {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',7);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',154);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',8);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',21);
require(presaleStart <= startsAt && presaleStart < endsAt);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',8);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',155);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',22);
presaleStartsAt = presaleStart;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',156);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',23);
TimeBoundaryChanged('presaleStartsAt', presaleStartsAt);
    }

    function setStartsAt(uint start) onlyOwner external {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',8);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',160);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',9);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',24);
require(presaleStartsAt < start && start < endsAt);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',9);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',161);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',25);
State state = getState();
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',162);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',10);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',26);
assert(state == State.Preparing || state == State.PreFunding);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',10);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',163);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',27);
startsAt = start;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',164);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',28);
TimeBoundaryChanged('startsAt', startsAt);
    }

    function setEndsAt(uint end) onlyOwner external {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',9);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',168);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',11);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',29);
require(end > startsAt && end > presaleStartsAt);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',11);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',169);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',12);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',30);
require(presaleStartsAt < startsAt && startsAt < end);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',12);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',170);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',31);
endsAt = end;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',171);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',32);
TimeBoundaryChanged('endsAt', endsAt);
    }

    /**
     * Set array of address and values to whitelist
     */
    function loadEarlyParticipantsWhitelist(address[] participantsArray, uint[] valuesArray) onlyOwner external {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',10);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',178);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',33);
address participant = 0x0;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',179);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',34);
uint value = 0;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',180);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',35);
for (uint i = 0; i < participantsArray.length; i++) {
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',181);
             __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',36);
participant = participantsArray[i];
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',182);
             __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',37);
value = valuesArray[i];
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',183);
             __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',38);
setEarlyParticipantWhitelist(participant, value);
        }
    }

    /**
     * Finalize a successful crowdsale.
     *
     * The owner can trigger a call the contract that provides post-crowdsale actions, like releasing the tokens.
     */
    function finalize() inState(State.Success) onlyOwner stopInEmergency external {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',11);

        // Already finalized
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',194);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',13);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',39);
assert(!finalized);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',13);

        // Finalizing is optional. We only call it if we are given a finalizing agent.
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',196);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',40);
if(address(finalizeAgent) != 0) {__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',14,0);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',197);
            finalizeAgent.finalizeCrowdsale();
        }else { __BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',14,1);}

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',199);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',41);
finalized = true;
    }

    /** This is for manual allow refunding */
    function allowRefunding(bool val) onlyOwner external {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',12);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',204);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',42);
State state = getState();
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',205);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',15);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',43);
assert(halted || state == State.Success || state == State.Failure || state == State.Refunding);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',15);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',206);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',44);
allowRefund = val;
    }

    /**
     * Allow load refunds back on the contract for the refunding.
     * The team can transfer the funds back on the smart contract in the case when is set refunding mode
     */
    function loadRefund() inState(State.Failure) external payable {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',13);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',214);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',16);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',45);
require(msg.value != 0);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',16);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',215);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',46);
loadedRefund = loadedRefund.plus(msg.value);
    }

    function refund() inState(State.Refunding) external {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',14);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',219);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',17);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',47);
assert(allowRefund);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',17);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',220);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',48);
uint256 weiValue = investedAmountOf[msg.sender];
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',221);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',18);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',49);
assert(weiValue != 0);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',18);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',222);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',50);
investedAmountOf[msg.sender] = 0;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',223);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',51);
weiRefunded = weiRefunded.plus(weiValue);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',224);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',52);
Refund(msg.sender, weiValue);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',225);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',19);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',53);
assert(msg.sender.send(weiValue));__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',19);

    }

    function setPricingStrategy(PricingStrategy _pricingStrategy) onlyOwner public {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',15);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',229);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',54);
State state = getState();
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',230);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',55);
if (state == State.PreFunding || state == State.Funding) {__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',20,0);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',231);
            __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',21);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',56);
assert(halted);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',21);

        }else { __BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',20,1);}

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',233);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',57);
pricingStrategy = _pricingStrategy;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',234);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',22);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',58);
require(pricingStrategy.isPricingStrategy());__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',22);

        //        require(pricingStrategy.isSane(address(this)));
    }

    function setMultisigWallet(address wallet) onlyOwner public {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',16);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',239);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',23);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',59);
require(wallet != 0x0);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',23);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',240);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',24);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',60);
assert(investorCount <= MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',24);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',241);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',61);
multisigWallet = wallet;
    }

    /**
     * Allow addresses to do early participation.
     */
    function setEarlyParticipantWhitelist(address participant, uint value) onlyOwner public {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',17);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',248);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',25);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',62);
require(value != 0 && participant != 0x0);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',25);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',249);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',26);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',63);
require(value <= pricingStrategy.getPresaleMaxValue());__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',26);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',250);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',27);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',64);
assert(!pricingStrategy.isPresaleFull(whitelistWeiRaised));__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',27);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',251);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',65);
earlyParticipantWhitelist[participant] = value;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',252);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',66);
whitelistWeiRaised = whitelistWeiRaised.plus(value);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',253);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',67);
Whitelisted(participant, value);
    }

    function getTokensLeft() public constant returns (uint) {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',18);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',257);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',68);
return token.allowance(beneficiary, this);
    }

    /**
     * We are sold out when our approve pool becomes empty.
     */
    function isCrowdsaleFull() public constant returns (bool) {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',19);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',264);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',69);
return getTokensLeft() == 0;
    }


    /**
     * Crowdfund state machine management.
     */
    function getState() public constant returns (State) {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',20);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',272);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',70);
if(finalized) { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',71);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',28,0);return State.Finalized;}
        else { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',72);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',28,1);if (!isPreallocated) { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',73);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',29,0);return State.Preparing;}
        else { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',74);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',29,1);if (address(finalizeAgent) == 0) { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',75);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',30,0);return State.Preparing;}
        else { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',76);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',30,1);if (!finalizeAgent.isSane()) { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',77);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',31,0);return State.Preparing;}
        else { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',78);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',31,1);if (block.timestamp < presaleStartsAt) { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',79);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',32,0);return State.Preparing;}
        else { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',80);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',32,1);if (block.timestamp >= presaleStartsAt && block.timestamp < startsAt) { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',81);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',33,0);return State.PreFunding;}
        else { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',82);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',33,1);if (block.timestamp <= endsAt && block.timestamp >= startsAt && !isCrowdsaleFull()) { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',83);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',34,0);return State.Funding;}
        else { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',84);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',34,1);if (!allowRefund && isCrowdsaleFull()) { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',85);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',35,0);return State.Success;}
        else { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',86);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',35,1);if (!allowRefund && block.timestamp > endsAt) { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',87);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',36,0);return State.Success;}
        else { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',88);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',36,1);if (allowRefund && weiRaised > 0 && loadedRefund >= weiRaised) { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',89);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',37,0);return State.Refunding;}
        else { __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',90);
__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',37,1);return State.Failure;}}}}}}}}}}
    }


    /** Check is crowdsale can be able to transfer all tokens from beneficiary */
    function isAllTokensApproved() private constant returns (bool) {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',21);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',288);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',91);
return getTokensLeft() == token.totalSupply() - tokensSold
                && token.transferAgents(beneficiary);
    }


    /**
     * Called from invest() to confirm if the current investment does not break our cap rule.
     */
    function isBreakingCap(uint tokenAmount) private constant returns (bool limitBroken) {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',22);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',297);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',92);
return tokenAmount > getTokensLeft();
    }


    function investInternal(address receiver, uint128 customerId) stopInEmergency internal{__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',23);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',302);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',93);
State state = getState();
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',303);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',94);
uint weiAmount = msg.value;
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',304);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',95);
uint tokenAmount = 0;

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',306);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',38);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',96);
assert(state == State.PreFunding || state == State.Funding);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',38);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',307);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',97);
if (state == State.PreFunding) {__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',39,0);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',308);
            __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',40);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',98);
assert(earlyParticipantWhitelist[receiver] > 0);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',40);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',309);
            __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',41);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',99);
require(weiAmount <= earlyParticipantWhitelist[receiver]);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',41);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',310);
            __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',42);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',100);
assert(!pricingStrategy.isPresaleFull(presaleWeiRaised));__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',42);

        }else { __BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',39,1);}


__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',313);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',101);
tokenAmount = pricingStrategy.getAmountOfTokens(weiAmount, weiRaised);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',314);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',43);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',102);
assert(tokenAmount > 0);__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',43);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',315);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',103);
if (investedAmountOf[receiver] == 0) {__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',44,0);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',316);
            investorCount++;
        }else { __BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',44,1);}


__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',319);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',104);
investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',320);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',105);
tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',321);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',106);
weiRaised = weiRaised.plus(weiAmount);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',322);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',107);
tokensSold = tokensSold.plus(tokenAmount);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',324);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',108);
if (state == State.PreFunding) {__BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',45,0);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',325);
             __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',109);
presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',326);
             __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',110);
earlyParticipantWhitelist[receiver] = earlyParticipantWhitelist[receiver].minus(weiAmount);
        }else { __BranchCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',45,1);}


__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',329);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',46);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',111);
assert(!isBreakingCap(tokenAmount));__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',46);


__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',331);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',112);
assignTokens(receiver, tokenAmount);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',333);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',47);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',113);
assert(multisigWallet.send(weiAmount));__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',47);


__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',335);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',114);
Invested(receiver, weiAmount, tokenAmount, customerId);
    }

    /**
     * Transfer tokens from approve() pool to the buyer.
     *
     * Use approve() given to this crowdsale to distribute the tokens.
     */
    function assignTokens(address receiver, uint tokenAmount) private {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',24);

__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',344);
        __AssertPreCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',48);
 __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',115);
assert(token.transferFrom(beneficiary, receiver, tokenAmount));__AssertPostCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',48);

    }

    /**
     * Preallocate tokens for developers, company and bounty
     */
    function preallocateTokens() private {__FunctionCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',25);

//        TODO:
__CoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',352);
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',116);
uint multiplier = 10 ** 18;
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',117);
assignTokens(0x58FC33aC6c7001925B4E9595b13B48bA73690a39, 6450000 * multiplier); // developers
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',118);
assignTokens(0x78534714b6b02996990cd567ebebd24e1f3dfe99, 6400000 * multiplier); // company
         __StatementCoverageAlgoryCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryCrowdsale.sol',119);
assignTokens(0xd64a60de8A023CE8639c66dAe6dd5f536726041E, 2400000 * multiplier); // bounty
    }

}