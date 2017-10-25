pragma solidity ^0.4.15;

import './StandardToken.sol';

contract BurnableToken is StandardToken {event __CoverageBurnableToken(string fileName, uint256 lineNumber);
event __FunctionCoverageBurnableToken(string fileName, uint256 fnId);
event __StatementCoverageBurnableToken(string fileName, uint256 statementId);
event __BranchCoverageBurnableToken(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageBurnableToken(string fileName, uint256 branchId);
event __AssertPostCoverageBurnableToken(string fileName, uint256 branchId);


    address public constant BURN_ADDRESS = 0x0;

    /** How many tokens we burned */
    event Burned(address burner, uint burnedAmount);

    /**
     * Burn extra tokens from a balance.
     */
    function burn(uint burnAmount) {__FunctionCoverageBurnableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/BurnableToken.sol',1);

__CoverageBurnableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/BurnableToken.sol',16);
         __StatementCoverageBurnableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/BurnableToken.sol',1);
address burner = msg.sender;
__CoverageBurnableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/BurnableToken.sol',17);
         __StatementCoverageBurnableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/BurnableToken.sol',2);
balances[burner] = safeSub(balances[burner], burnAmount);
__CoverageBurnableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/BurnableToken.sol',18);
         __StatementCoverageBurnableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/BurnableToken.sol',3);
totalSupply = safeSub(totalSupply, burnAmount);
__CoverageBurnableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/BurnableToken.sol',19);
         __StatementCoverageBurnableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/BurnableToken.sol',4);
Burned(burner, burnAmount);
    }
}