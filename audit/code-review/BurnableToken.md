# BurnableToken 
Source file [../../contracts/token/BurnableToken.sol](../../contracts/token/BurnableToken.sol).


<br />

<hr />


```javascript
// RS Ok
pragma solidity ^0.4.15;
// RS Ok
import './StandardToken.sol';

/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
 // RS Ok
contract BurnableToken is StandardToken {
    // RS Ok
    event Burn(address indexed burner, uint256 value);

    /**
     * @dev Burns a specific amount of tokens.
     * @param _value The amount of token to be burned.
     */
     // RS Ok
    function burn(uint256 _value) public {
        // RS Ok
        require(_value > 0);
        // RS Ok
        require(_value <= balances[msg.sender]);
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure
        // RS Ok
        address burner = msg.sender;
        // RS Ok
        balances[burner] = balances[burner].sub(_value);
        // RS Ok
        totalSupply = totalSupply.sub(_value);
        // RS Ok
        Burn(burner, _value);
    }
}
```