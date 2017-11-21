# ReleasableToken 
Source file [../../contracts/token/ReleasableToken.sol](../../contracts/token/ReleasableToken.sol).


<br />

<hr />



```javascript
// RS Ok
pragma solidity ^0.4.15;
// RS Ok
import './ERC20.sol';
// RS Ok
import '../ownership/Ownable.sol';

/**
 * Define interface for releasing the token transfer after a successful crowdsale.
 */
 // RS Ok
contract ReleasableToken is ERC20, Ownable {

    /* The finalizer contract that allows unlift the transfer limits on this token */
    // RS Ok
    address public releaseAgent;

    /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
    // RS Ok
    bool public released = false;

    /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
    // RS Ok
    mapping (address => bool) public transferAgents;

    /**
     * Limit token transfer until the crowdsale is over.
     *
     */
     // RS Ok
    modifier canTransfer(address _sender) {
        // RS Ok. 
        if(!released) {
            // RS Ok
            assert(transferAgents[_sender]);
        }
        _;
    }

    /**
     * Set the contract that can call release and make the token transferable.
     *
     * Design choice. Allow reset the release agent to fix fat finger mistakes.
     */
     // RS Ok
    function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
        // RS Ok
        require(addr != 0x0);
        // We don't do interface check here as we might want to a normal wallet address to act as a release agent
        // RS Ok
        releaseAgent = addr;
    }

    /**
     * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
     */
     // RS Ok
    function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
        // RS Ok
        require(addr != 0x0);
        // RS Ok
        transferAgents[addr] = state;
    }

    /**
     * One way function to release the tokens to the wild.
     *
     * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
     */
     // RS Ok
    function releaseTokenTransfer() public onlyReleaseAgent {
        // RS Ok
        released = true;
    }

    /** The function can be called only before or after the tokens have been releasesd */
    // RS Ok
    modifier inReleaseState(bool releaseState) {
        // RS Ok
        require(releaseState == released);
        // RS Ok
        _;
    }

    /** The function can be called only by a whitelisted release agent. */
    // RS Ok
    modifier onlyReleaseAgent() {
        // RS Ok
        require(msg.sender == releaseAgent);
        // RS Ok
        _;
    }
    // RS Ok
    function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
        // Call StandardToken.transfer()
        // RS Ok
        return super.transfer(_to, _value);
    }
    // RS Ok
    function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
        // Call StandardToken.transferForm()
        // RS Ok
        return super.transferFrom(_from, _to, _value);
    }

}
```