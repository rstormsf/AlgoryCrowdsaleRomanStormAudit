pragma solidity ^0.4.15;

import './CrowdsaleToken.sol';
import './UpgradeableToken.sol';

/**
 * A Algory token.
 *
 */
contract AlgoryToken is UpgradeableToken, CrowdsaleToken {event __CoverageAlgoryToken(string fileName, uint256 lineNumber);
event __FunctionCoverageAlgoryToken(string fileName, uint256 fnId);
event __StatementCoverageAlgoryToken(string fileName, uint256 statementId);
event __BranchCoverageAlgoryToken(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageAlgoryToken(string fileName, uint256 branchId);
event __AssertPostCoverageAlgoryToken(string fileName, uint256 branchId);


    string public name = 'Algory';
    string public symbol = 'ALG';
    uint public decimals = 18;

    event UpdatedTokenInformation(string newName, string newSymbol);

    function AlgoryToken(uint _initialSupply) UpgradeableToken(msg.sender) {__FunctionCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',1);

__CoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',19);
         __StatementCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',1);
owner = msg.sender;
__CoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',20);
         __StatementCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',2);
totalSupply = _initialSupply;
__CoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',21);
        __AssertPreCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',1);
 __StatementCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',3);
require(totalSupply > 0);__AssertPostCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',1);

__CoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',22);
         __StatementCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',4);
balances[owner] = totalSupply;
__CoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',23);
         __StatementCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',5);
Minted(owner, totalSupply);
    }

    function releaseTokenTransfer() public onlyReleaseAgent {__FunctionCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',2);

__CoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',27);
        super.releaseTokenTransfer();
    }

    function canUpgrade() public constant returns(bool) {__FunctionCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',3);

__CoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',31);
         __StatementCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',6);
return released && super.canUpgrade();
    }

    function setTokenInformation(string _name, string _symbol) onlyOwner {__FunctionCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',4);

__CoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',35);
         __StatementCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',7);
name = _name;
__CoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',36);
         __StatementCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',8);
symbol = _symbol;
        // use StringUtils
//        require(name != '' && symbol != '');
__CoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',39);
         __StatementCoverageAlgoryToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/AlgoryToken.sol',9);
UpdatedTokenInformation(name, symbol);
    }

}