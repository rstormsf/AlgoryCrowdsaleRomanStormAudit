# InvestmentPolicyCrowdsale
Source file [../../contracts/crowdsale/FinalizeAgent.sol](../../contracts/crowdsale/FinalizeAgent.sol).


<br />

<hr />

```javascript
// RS Ok
pragma solidity ^0.4.15;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
 // RS Ok
contract Ownable {
  // RS Ok
  address public owner;

  // RS Ok
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
   // RS Ok
  function Ownable() {
    // RS Ok
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
   // RS Ok
  modifier onlyOwner() {
    // RS Ok
    require(msg.sender == owner);
    // RS Ok
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
   // RS Ok
  function transferOwnership(address newOwner) onlyOwner public {
    // RS Ok
    require(newOwner != address(0));
    // RS Ok
    OwnershipTransferred(owner, newOwner);
    // RS Ok
    owner = newOwner;
  }

}
```