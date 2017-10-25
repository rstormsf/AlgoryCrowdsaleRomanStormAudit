pragma solidity ^0.4.15;

import '../math/SafeMath.sol';
import './ERC20.sol';

/**
 * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
 *
 * Based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, SafeMath {event __CoverageStandardToken(string fileName, uint256 lineNumber);
event __FunctionCoverageStandardToken(string fileName, uint256 fnId);
event __StatementCoverageStandardToken(string fileName, uint256 statementId);
event __BranchCoverageStandardToken(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageStandardToken(string fileName, uint256 branchId);
event __AssertPostCoverageStandardToken(string fileName, uint256 branchId);


    /* Token supply got increased and a new owner received these tokens */
    event Minted(address receiver, uint amount);

    /* Actual balances of token holders */
    mapping(address => uint) balances;

    /* approve() allowances */
    mapping (address => mapping (address => uint)) allowed;

    /* Interface declaration */
    function isToken() public constant returns (bool weAre) {__FunctionCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',1);

__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',25);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',1);
return true;
    }

    function transfer(address _to, uint _value) returns (bool success) {__FunctionCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',2);

__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',29);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',2);
balances[msg.sender] = safeSub(balances[msg.sender], _value);
__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',30);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',3);
balances[_to] = safeAdd(balances[_to], _value);
__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',31);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',4);
Transfer(msg.sender, _to, _value);
__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',32);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',5);
return true;
    }

    function transferFrom(address _from, address _to, uint _value) returns (bool success) {__FunctionCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',3);

__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',36);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',6);
uint _allowance = allowed[_from][msg.sender];

__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',38);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',7);
balances[_to] = safeAdd(balances[_to], _value);
__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',39);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',8);
balances[_from] = safeSub(balances[_from], _value);
__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',40);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',9);
allowed[_from][msg.sender] = safeSub(_allowance, _value);
__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',41);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',10);
Transfer(_from, _to, _value);
__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',42);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',11);
return true;
    }

    function balanceOf(address _owner) constant returns (uint balance) {__FunctionCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',4);

__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',46);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',12);
return balances[_owner];
    }

    function approve(address _spender, uint _value) returns (bool success) {__FunctionCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',5);

          // To change the approve amount you first have to reduce the addresses`
          //  allowance to zero by calling `approve(_spender, 0)` if it is not
          //  already 0 to mitigate the race condition described here:
          //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',54);
           __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',13);
if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) { __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',14);
__BranchCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',1,0);revert();}else { __BranchCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',1,1);}


__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',56);
           __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',15);
allowed[msg.sender][_spender] = _value;
__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',57);
           __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',16);
Approval(msg.sender, _spender, _value);
__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',58);
           __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',17);
return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint remaining) {__FunctionCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',6);

__CoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',62);
         __StatementCoverageStandardToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/StandardToken.sol',18);
return allowed[_owner][_spender];
    }

}