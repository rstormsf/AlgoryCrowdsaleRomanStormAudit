# UpgradeableToken 
Source file [../../contracts/token/UpgradeableToken.sol](../../contracts/token/UpgradeableToken.sol).


<br />

<hr />




```javascript
// RS Ok
pragma solidity ^0.4.15;
// RS Ok
import './StandardToken.sol';
// RS Ok
import './UpgradeAgent.sol';

/**
 * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
 *
 * First envisioned by Golem and Lunyr projects.
 */
 // RS Ok
contract UpgradeableToken is StandardToken {

    /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
    // RS Ok
    address public upgradeMaster;

    /** The next contract where the tokens will be migrated. */
    // RS Ok
    UpgradeAgent public upgradeAgent;

    /** How many tokens we have upgraded by now. */
    // RS Ok
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
     // RS Ok
    enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}

    /**
     * Somebody has upgraded some of his tokens.
     */
     // RS Ok
    event Upgrade(address indexed _from, address indexed _to, uint256 _value);

    /**
     * New upgrade agent available.
     */
     // RS Ok
    event UpgradeAgentSet(address agent);

    /**
     * Do not allow construction without upgrade master set.
     */
     // RS Ok
    function UpgradeableToken(address _upgradeMaster) {
        // RS Ok
        upgradeMaster = _upgradeMaster;
    }

    /**
     * Allow the token holder to upgrade some of their tokens to a new contract.
     */
     // RS Ok
    function upgrade(uint256 value) public {
        // RS Ok
        require(value != 0);
        // RS Ok
        UpgradeState state = getUpgradeState();
        // RS Ok
        assert(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
        // RS Ok
        assert(value <= balanceOf(msg.sender));
        // RS Ok
        balances[msg.sender] = balances[msg.sender].sub(value);

        // Take tokens out from circulation
        // RS Ok
        totalSupply = totalSupply.sub(value);
        // RS Ok
        totalUpgraded = totalUpgraded.add(value);

        // Upgrade agent reissues the tokens
        // RS Ok
        upgradeAgent.upgradeFrom(msg.sender, value);
        // RS Ok
        Upgrade(msg.sender, upgradeAgent, value);
    }

    /**
     * Set an upgrade agent that handles
     */
     // RS Ok
    function setUpgradeAgent(address agent) external {
        // RS Ok
        require(agent != 0x0 && msg.sender == upgradeMaster);
        // RS Ok
        assert(canUpgrade());
        // RS Ok
        upgradeAgent = UpgradeAgent(agent);
        // RS Ok
        assert(upgradeAgent.isUpgradeAgent());
        // RS Ok
        assert(upgradeAgent.originalSupply() == totalSupply);
        // RS Ok
        UpgradeAgentSet(upgradeAgent);
    }

    /**
     * Get the state of the token upgrade.
     */
     // RS Ok
    function getUpgradeState() public constant returns(UpgradeState) {
        // RS Ok
        if(!canUpgrade()) return UpgradeState.NotAllowed;
        // RS Ok
        else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
        // RS Ok
        else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
        // RS Ok
        else return UpgradeState.Upgrading;
    }

    /**
     * Change the upgrade master.
     *
     * This allows us to set a new owner for the upgrade mechanism.
     */
     // RS Ok
    function setUpgradeMaster(address master) public {
        // RS Ok
        require(master != 0x0 && msg.sender == upgradeMaster);
        // RS Ok
        upgradeMaster = master;
    }

    /**
     * Child contract can enable to provide the condition when the upgrade can begun.
     */
     // RS Ok
    function canUpgrade() public constant returns(bool) {
        // RS Ok
        return true;
    }

}
```