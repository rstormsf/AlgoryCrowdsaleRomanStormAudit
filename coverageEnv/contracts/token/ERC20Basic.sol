pragma solidity ^0.4.15;

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {event __CoverageERC20Basic(string fileName, uint256 lineNumber);
event __FunctionCoverageERC20Basic(string fileName, uint256 fnId);
event __StatementCoverageERC20Basic(string fileName, uint256 statementId);
event __BranchCoverageERC20Basic(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageERC20Basic(string fileName, uint256 branchId);
event __AssertPostCoverageERC20Basic(string fileName, uint256 branchId);

    uint256 public totalSupply;
    function balanceOf(address who) constant returns (uint256);
    function transfer(address to, uint256 value) returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}