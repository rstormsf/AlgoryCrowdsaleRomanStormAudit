pragma solidity ^0.4.15;

import './ERC20.sol';
import '../ownership/Ownable.sol';

/**
 * Define interface for releasing the token transfer after a successful crowdsale.
 */
contract ReleasableToken is ERC20, Ownable {event __CoverageReleasableToken(string fileName, uint256 lineNumber);
event __FunctionCoverageReleasableToken(string fileName, uint256 fnId);
event __StatementCoverageReleasableToken(string fileName, uint256 statementId);
event __BranchCoverageReleasableToken(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageReleasableToken(string fileName, uint256 branchId);
event __AssertPostCoverageReleasableToken(string fileName, uint256 branchId);


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
    modifier canTransfer(address _sender) {__FunctionCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',1);

__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',25);
         __StatementCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',1);
if(!released) {__BranchCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',1,0);
__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',26);
            __AssertPreCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',2);
 __StatementCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',2);
assert(transferAgents[_sender]);__AssertPostCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',2);

        }else { __BranchCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',1,1);}

__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',28);
        _;
    }

    /**
     * Set the contract that can call release and make the token transferable.
     *
     * Design choice. Allow reset the release agent to fix fat finger mistakes.
     */
    function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {__FunctionCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',2);

__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',37);
        __AssertPreCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',3);
 __StatementCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',3);
require(addr != 0x0);__AssertPostCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',3);

        // We don't do interface check here as we might want to a normal wallet address to act as a release agent
__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',39);
         __StatementCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',4);
releaseAgent = addr;
    }

    /**
     * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
     */
    function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {__FunctionCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',3);

__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',46);
        __AssertPreCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',4);
 __StatementCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',5);
require(addr != 0x0);__AssertPostCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',4);

__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',47);
         __StatementCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',6);
transferAgents[addr] = state;
    }

    /**
     * One way function to release the tokens to the wild.
     *
     * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
     */
    function releaseTokenTransfer() public onlyReleaseAgent {__FunctionCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',4);

__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',56);
         __StatementCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',7);
released = true;
    }

    /** The function can be called only before or after the tokens have been releasesd */
    modifier inReleaseState(bool releaseState) {__FunctionCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',5);

__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',61);
        __AssertPreCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',5);
 __StatementCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',8);
require(releaseState == released);__AssertPostCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',5);

__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',62);
        _;
    }

    /** The function can be called only by a whitelisted release agent. */
    modifier onlyReleaseAgent() {__FunctionCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',6);

__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',67);
        __AssertPreCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',6);
 __StatementCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',9);
require(msg.sender == releaseAgent);__AssertPostCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',6);

__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',68);
        _;
    }

    function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {__FunctionCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',7);

        // Call StandardToken.transfer()
__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',73);
         __StatementCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',10);
return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {__FunctionCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',8);

        // Call StandardToken.transferForm()
__CoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',78);
         __StatementCoverageReleasableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/ReleasableToken.sol',11);
return super.transferFrom(_from, _to, _value);
    }

}