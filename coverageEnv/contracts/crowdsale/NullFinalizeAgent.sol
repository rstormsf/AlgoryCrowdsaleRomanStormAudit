pragma solidity ^0.4.15;

import './FinalizeAgent.sol';
import '../math/SafeMathLib.sol';
import './AlgoryCrowdsale.sol';

/**
 * A finalize agent that does nothing.
 * Token transfer must be manually released by the owner
 */
contract NullFinalizeAgent is FinalizeAgent {event __CoverageNullFinalizeAgent(string fileName, uint256 lineNumber);
event __FunctionCoverageNullFinalizeAgent(string fileName, uint256 fnId);
event __StatementCoverageNullFinalizeAgent(string fileName, uint256 statementId);
event __BranchCoverageNullFinalizeAgent(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageNullFinalizeAgent(string fileName, uint256 branchId);
event __AssertPostCoverageNullFinalizeAgent(string fileName, uint256 branchId);


    AlgoryCrowdsale public crowdsale;

    function NullFinalizeAgent(AlgoryCrowdsale _crowdsale) {__FunctionCoverageNullFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/NullFinalizeAgent.sol',1);

__CoverageNullFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/NullFinalizeAgent.sol',16);
         __StatementCoverageNullFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/NullFinalizeAgent.sol',1);
crowdsale = _crowdsale;
    }

    function isSane() public constant returns (bool) {__FunctionCoverageNullFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/NullFinalizeAgent.sol',2);

__CoverageNullFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/NullFinalizeAgent.sol',20);
         __StatementCoverageNullFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/NullFinalizeAgent.sol',2);
return crowdsale.finalizeAgent() == address(this);
    }

    /** Called once by crowdsale finalize() if the sale was success. */
    function finalizeCrowdsale() public {__FunctionCoverageNullFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/NullFinalizeAgent.sol',3);

        // nothing to do
    }

}