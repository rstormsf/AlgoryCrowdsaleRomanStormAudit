pragma solidity ^0.4.15;

import './ReleasableToken.sol';
import './FractionalERC20.sol';
import './BurnableToken.sol';

/**
 * Base crowdsale token interface
 */
contract CrowdsaleToken is FractionalERC20, BurnableToken, ReleasableToken {event __CoverageCrowdsaleToken(string fileName, uint256 lineNumber);
event __FunctionCoverageCrowdsaleToken(string fileName, uint256 fnId);
event __StatementCoverageCrowdsaleToken(string fileName, uint256 statementId);
event __BranchCoverageCrowdsaleToken(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageCrowdsaleToken(string fileName, uint256 branchId);
event __AssertPostCoverageCrowdsaleToken(string fileName, uint256 branchId);


}