pragma solidity ^0.4.15;

import './FinalizeAgent.sol';
import './AlgoryCrowdsale.sol';
import '../math/SafeMathLib.sol';
import '../token/AlgoryToken.sol';

/**
 * At the end of the successful crowdsale unlock tokens transfer.
 *
 */
contract AlgoryFinalizeAgent is FinalizeAgent {event __CoverageAlgoryFinalizeAgent(string fileName, uint256 lineNumber);
event __FunctionCoverageAlgoryFinalizeAgent(string fileName, uint256 fnId);
event __StatementCoverageAlgoryFinalizeAgent(string fileName, uint256 statementId);
event __BranchCoverageAlgoryFinalizeAgent(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageAlgoryFinalizeAgent(string fileName, uint256 branchId);
event __AssertPostCoverageAlgoryFinalizeAgent(string fileName, uint256 branchId);


    using SafeMathLib for uint;

    AlgoryToken public token;
    AlgoryCrowdsale public crowdsale;

    function AlgoryFinalizeAgent(AlgoryToken _token, AlgoryCrowdsale _crowdsale) {__FunctionCoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',1);

__CoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',20);
         __StatementCoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',1);
token = _token;
__CoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',21);
         __StatementCoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',2);
crowdsale = _crowdsale;
__CoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',22);
        __AssertPreCoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',1);
 __StatementCoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',3);
require(address(token) != 0x0 && address(crowdsale) != 0x0);__AssertPostCoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',1);

    }

    /* Can we run finalize properly */
    function isSane() public constant returns (bool) {__FunctionCoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',2);

__CoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',27);
         __StatementCoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',4);
return token.releaseAgent() == address(this) && crowdsale.finalizeAgent() == address(this);
    }

    /** Called once by crowdsale finalize() if the sale was success. */
    function finalizeCrowdsale() public {__FunctionCoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',3);

__CoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',32);
        __AssertPreCoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',2);
 __StatementCoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',5);
require(msg.sender == address(crowdsale));__AssertPostCoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',2);


        // Make token transferable
__CoverageAlgoryFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryFinalizeAgent.sol',35);
        token.releaseTokenTransfer();
    }

}