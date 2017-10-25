pragma solidity ^0.4.15;

import './StandardToken.sol';
import './UpgradeAgent.sol';

/**
 * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
 *
 * First envisioned by Golem and Lunyr projects.
 */
contract UpgradeableToken is StandardToken {event __CoverageUpgradeableToken(string fileName, uint256 lineNumber);
event __FunctionCoverageUpgradeableToken(string fileName, uint256 fnId);
event __StatementCoverageUpgradeableToken(string fileName, uint256 statementId);
event __BranchCoverageUpgradeableToken(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageUpgradeableToken(string fileName, uint256 branchId);
event __AssertPostCoverageUpgradeableToken(string fileName, uint256 branchId);


    /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
    address public upgradeMaster;

    /** The next contract where the tokens will be migrated. */
    UpgradeAgent public upgradeAgent;

    /** How many tokens we have upgraded by now. */
    uint256 public totalUpgraded;

    /**
     * Upgrade states.
     *
     * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
     * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
     * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
     * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
     *
     */
    enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}

    /**
     * Somebody has upgraded some of his tokens.
     */
    event Upgrade(address indexed _from, address indexed _to, uint256 _value);

    /**
     * New upgrade agent available.
     */
    event UpgradeAgentSet(address agent);

    /**
     * Do not allow construction without upgrade master set.
     */
    function UpgradeableToken(address _upgradeMaster) {__FunctionCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',1);

__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',47);
         __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',1);
upgradeMaster = _upgradeMaster;
    }

    /**
     * Allow the token holder to upgrade some of their tokens to a new contract.
     */
    function upgrade(uint256 value) public {__FunctionCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',2);

__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',54);
        __AssertPreCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',1);
 __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',2);
require(value != 0);__AssertPostCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',1);

__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',55);
         __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',3);
UpgradeState state = getUpgradeState();
__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',56);
         __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',4);
if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {__BranchCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',2,0);
__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',57);
             __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',5);
revert();
        }else { __BranchCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',2,1);}


__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',60);
         __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',6);
balances[msg.sender] = safeSub(balances[msg.sender], value);

        // Take tokens out from circulation
__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',63);
         __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',7);
totalSupply = safeSub(totalSupply, value);
__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',64);
         __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',8);
totalUpgraded = safeAdd(totalUpgraded, value);

        // Upgrade agent reissues the tokens
__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',67);
        upgradeAgent.upgradeFrom(msg.sender, value);
__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',68);
         __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',9);
Upgrade(msg.sender, upgradeAgent, value);
    }

    /**
     * Set an upgrade agent that handles
     */
    function setUpgradeAgent(address agent) external {__FunctionCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',3);

__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',75);
        __AssertPreCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',3);
 __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',10);
require(agent != 0x0 && msg.sender == upgradeMaster);__AssertPostCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',3);

__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',76);
        __AssertPreCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',4);
 __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',11);
assert(canUpgrade());__AssertPostCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',4);

__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',77);
         __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',12);
upgradeAgent = UpgradeAgent(agent);
__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',78);
        __AssertPreCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',5);
 __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',13);
assert(upgradeAgent.isUpgradeAgent());__AssertPostCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',5);

__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',79);
        __AssertPreCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',6);
 __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',14);
assert(upgradeAgent.originalSupply() == totalSupply);__AssertPostCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',6);

__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',80);
         __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',15);
UpgradeAgentSet(upgradeAgent);
    }

    /**
     * Get the state of the token upgrade.
     */
    function getUpgradeState() public constant returns(UpgradeState) {__FunctionCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',4);

__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',87);
         __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',16);
if(!canUpgrade()) { __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',17);
__BranchCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',7,0);return UpgradeState.NotAllowed;}
        else { __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',18);
__BranchCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',7,1);if(address(upgradeAgent) == 0x00) { __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',19);
__BranchCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',8,0);return UpgradeState.WaitingForAgent;}
        else { __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',20);
__BranchCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',8,1);if(totalUpgraded == 0) { __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',21);
__BranchCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',9,0);return UpgradeState.ReadyToUpgrade;}
        else { __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',22);
__BranchCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',9,1);return UpgradeState.Upgrading;}}}
    }

    /**
     * Change the upgrade master.
     *
     * This allows us to set a new owner for the upgrade mechanism.
     */
    function setUpgradeMaster(address master) public {__FunctionCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',5);

__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',99);
        __AssertPreCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',10);
 __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',23);
require(master != 0x0 && msg.sender == upgradeMaster);__AssertPostCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',10);

__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',100);
         __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',24);
upgradeMaster = master;
    }

    /**
     * Child contract can enable to provide the condition when the upgrade can begun.
     */
    function canUpgrade() public constant returns(bool) {__FunctionCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',6);

__CoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',107);
         __StatementCoverageUpgradeableToken('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/token/UpgradeableToken.sol',25);
return true;
    }

}