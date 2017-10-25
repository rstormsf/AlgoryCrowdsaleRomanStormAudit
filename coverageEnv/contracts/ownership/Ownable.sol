pragma solidity ^0.4.15;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {event __CoverageOwnable(string fileName, uint256 lineNumber);
event __FunctionCoverageOwnable(string fileName, uint256 fnId);
event __StatementCoverageOwnable(string fileName, uint256 statementId);
event __BranchCoverageOwnable(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageOwnable(string fileName, uint256 branchId);
event __AssertPostCoverageOwnable(string fileName, uint256 branchId);

  address public owner;


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {__FunctionCoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',1);

__CoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',17);
     __StatementCoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',1);
owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {__FunctionCoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',2);

__CoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',25);
    __AssertPreCoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',1);
 __StatementCoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',2);
require(msg.sender == owner);__AssertPostCoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',1);

__CoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',26);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner {__FunctionCoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',3);

__CoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',35);
    __AssertPreCoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',2);
 __StatementCoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',3);
require(newOwner != address(0));__AssertPostCoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',2);

__CoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',36);
     __StatementCoverageOwnable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Ownable.sol',4);
owner = newOwner;
  }

}