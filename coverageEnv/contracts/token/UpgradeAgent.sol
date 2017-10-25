pragma solidity ^0.4.15;

/**
 * Upgrade agent interface inspired by Lunyr.
 *
 * Upgrade agent transfers tokens to a new contract.
 * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
 */
contract UpgradeAgent {event __CoverageUpgradeAgent(string fileName, uint256 lineNumber);
event __FunctionCoverageUpgradeAgent(string fileName, uint256 fnId);
event __StatementCoverageUpgradeAgent(string fileName, uint256 statementId);
event __BranchCoverageUpgradeAgent(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageUpgradeAgent(string fileName, uint256 branchId);
event __AssertPostCoverageUpgradeAgent(string fileName, uint256 branchId);


    uint public originalSupply;

    /** Interface marker */
    function isUpgradeAgent() public constant returns (bool) {__FunctionCoverageUpgradeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeAgent.sol',1);

__CoverageUpgradeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeAgent.sol',15);
         __StatementCoverageUpgradeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeAgent.sol',1);
return true;
    }

    function upgradeFrom(address _from, uint256 _value) public;

}