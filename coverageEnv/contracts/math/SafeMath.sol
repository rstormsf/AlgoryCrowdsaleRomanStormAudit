pragma solidity ^0.4.15;

/**
 * Math operations with safety checks
 */
contract SafeMath {event __CoverageSafeMath(string fileName, uint256 lineNumber);
event __FunctionCoverageSafeMath(string fileName, uint256 fnId);
event __StatementCoverageSafeMath(string fileName, uint256 statementId);
event __BranchCoverageSafeMath(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageSafeMath(string fileName, uint256 branchId);
event __AssertPostCoverageSafeMath(string fileName, uint256 branchId);

  function safeMul(uint a, uint b) internal returns (uint) {__FunctionCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',1);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',8);
     __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',1);
uint c = a * b;
__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',9);
    __AssertPreCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',1);
 __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',2);
assert(a == 0 || c / a == b);__AssertPostCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',1);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',10);
     __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',3);
return c;
  }

  function safeDiv(uint a, uint b) internal returns (uint) {__FunctionCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',2);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',14);
    __AssertPreCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',2);
 __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',4);
assert(b > 0);__AssertPostCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',2);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',15);
     __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',5);
uint c = a / b;
__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',16);
    __AssertPreCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',3);
 __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',6);
assert(a == b * c + a % b);__AssertPostCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',3);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',17);
     __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',7);
return c;
  }

  function safeSub(uint a, uint b) internal returns (uint) {__FunctionCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',3);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',21);
    __AssertPreCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',4);
 __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',8);
assert(b <= a);__AssertPostCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',4);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',22);
     __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',9);
return a - b;
  }

  function safeAdd(uint a, uint b) internal returns (uint) {__FunctionCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',4);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',26);
     __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',10);
uint c = a + b;
__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',27);
    __AssertPreCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',5);
 __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',11);
assert(c>=a && c>=b);__AssertPostCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',5);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',28);
     __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',12);
return c;
  }

  function max64(uint64 a, uint64 b) internal constant returns (uint64) {__FunctionCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',5);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',32);
     __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',13);
return a >= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal constant returns (uint64) {__FunctionCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',6);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',36);
     __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',14);
return a < b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal constant returns (uint256) {__FunctionCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',7);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',40);
     __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',15);
return a >= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal constant returns (uint256) {__FunctionCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',8);

__CoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',44);
     __StatementCoverageSafeMath('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMath.sol',16);
return a < b ? a : b;
  }

}