pragma solidity ^0.4.15;

/**
 * Safe unsigned safe math.
 *
 * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
 *
 * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
 *
 * Maintained here until merged to mainline zeppelin-solidity.
 *
 */
library SafeMathLib {event __CoverageSafeMathLib(string fileName, uint256 lineNumber);
event __FunctionCoverageSafeMathLib(string fileName, uint256 fnId);
event __StatementCoverageSafeMathLib(string fileName, uint256 statementId);
event __BranchCoverageSafeMathLib(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageSafeMathLib(string fileName, uint256 branchId);
event __AssertPostCoverageSafeMathLib(string fileName, uint256 branchId);


  function times(uint a, uint b) returns (uint) {__FunctionCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',1);

__CoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',16);
     __StatementCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',1);
uint c = a * b;
__CoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',17);
    __AssertPreCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',1);
 __StatementCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',2);
assert(a == 0 || c / a == b);__AssertPostCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',1);

__CoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',18);
     __StatementCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',3);
return c;
  }

  function minus(uint a, uint b) returns (uint) {__FunctionCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',2);

__CoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',22);
    __AssertPreCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',2);
 __StatementCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',4);
assert(b <= a);__AssertPostCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',2);

__CoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',23);
     __StatementCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',5);
return a - b;
  }

  function plus(uint a, uint b) returns (uint) {__FunctionCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',3);

__CoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',27);
     __StatementCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',6);
uint c = a + b;
__CoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',28);
    __AssertPreCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',3);
 __StatementCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',7);
assert(c>=a);__AssertPostCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',3);

__CoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',29);
     __StatementCoverageSafeMathLib('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/math/SafeMathLib.sol',8);
return c;
  }

}