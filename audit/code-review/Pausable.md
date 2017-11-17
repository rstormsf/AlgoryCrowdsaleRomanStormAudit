
# Pausable
Source file [../../contracts/lifecycle/Pausable.sol](../../contracts/lifecycle/Pausable.sol).


<br />

<hr />

```javascript
// RS Ok
pragma solidity ^0.4.11;
// RS Ok
import "../ownership/Ownable.sol";

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
 // RS Ok
contract Pausable is Ownable {
    // RS Ok
    event Pause();
    // RS Ok
    event Unpause();
    // RS Ok
    bool public paused = false;


    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
     // RS Ok
    modifier whenNotPaused() {
        // RS Ok
        require(!paused);
        // RS Ok
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
     // RS Ok
    modifier whenPaused() {
        // RS Ok
        require(paused);
        // RS Ok
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
     // RS Ok
    function pause() onlyOwner whenNotPaused public {
        // RS Ok
        paused = true;
        // RS Ok
        Pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
     // RS Ok
    function unpause() onlyOwner whenPaused public {
        // RS Ok
        paused = false;
        // RS Ok
        Unpause();
    }
}
```