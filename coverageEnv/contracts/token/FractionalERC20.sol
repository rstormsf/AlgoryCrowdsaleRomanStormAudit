pragma solidity ^0.4.15;

import './ERC20.sol';

/**
 * A token that defines fractional units as decimals.
 */
contract FractionalERC20 is ERC20 {event __CoverageFractionalERC20(string fileName, uint256 lineNumber);
event __FunctionCoverageFractionalERC20(string fileName, uint256 fnId);
event __StatementCoverageFractionalERC20(string fileName, uint256 statementId);
event __BranchCoverageFractionalERC20(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageFractionalERC20(string fileName, uint256 branchId);
event __AssertPostCoverageFractionalERC20(string fileName, uint256 branchId);

    uint public decimals;
}
