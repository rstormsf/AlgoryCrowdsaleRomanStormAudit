pragma solidity ^0.4.15;

import './Ownable.sol';
/*
 * Haltable
 *
 * Abstract contract that allows children to implement an
 * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
 *
 *
 * Originally envisioned in FirstBlood ICO contract.
 */
contract Haltable is Ownable {event __CoverageHaltable(string fileName, uint256 lineNumber);
event __FunctionCoverageHaltable(string fileName, uint256 fnId);
event __StatementCoverageHaltable(string fileName, uint256 statementId);
event __BranchCoverageHaltable(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageHaltable(string fileName, uint256 branchId);
event __AssertPostCoverageHaltable(string fileName, uint256 branchId);

  bool public halted;

  modifier stopInEmergency {__FunctionCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',1);

__CoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',17);
     __StatementCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',1);
if (halted) { __StatementCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',2);
__BranchCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',1,0);revert();}else { __BranchCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',1,1);}

__CoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',18);
    _;
  }

  modifier stopNonOwnersInEmergency {__FunctionCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',2);

__CoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',22);
     __StatementCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',3);
if (halted && msg.sender != owner) { __StatementCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',4);
__BranchCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',2,0);revert();}else { __BranchCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',2,1);}

__CoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',23);
    _;
  }

  modifier onlyInEmergency {__FunctionCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',3);

__CoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',27);
     __StatementCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',5);
if (!halted) { __StatementCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',6);
__BranchCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',3,0);revert();}else { __BranchCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',3,1);}

__CoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',28);
    _;
  }

  // called by the owner on emergency, triggers stopped state
  function halt() external onlyOwner {__FunctionCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',4);

__CoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',33);
     __StatementCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',7);
halted = true;
  }

  // called by the owner on end of emergency, returns to normal state
  function unhalt() external onlyOwner onlyInEmergency {__FunctionCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',5);

__CoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',38);
     __StatementCoverageHaltable('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/ownership/Haltable.sol',8);
halted = false;
  }

}