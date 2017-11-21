# AlgoryToken 
Source file [../../contracts/token/StandardToken.sol](../../contracts/token/StandardToken.sol).


<br />

<hr />



```javascript
// RS Ok
pragma solidity ^0.4.15;
// RS Ok
import './ERC20.sol';
// RS Ok
import '../math/SafeMath.sol';

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
 // RS Ok
contract StandardToken is ERC20 {
    // RS Ok
    using SafeMath for uint256;
    // RS Ok
    mapping(address => uint256) balances;
    // RS Ok
    mapping (address => mapping (address => uint256)) internal allowed;

    /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */// RS Ok
    function transfer(address _to, uint256 _value) public returns (bool) {
        // RS Ok
        require(_to != address(0));
        // RS Ok
        require(_value <= balances[msg.sender]);

        // SafeMath.sub will throw if there is not enough balance.
        // RS Ok
        balances[msg.sender] = balances[msg.sender].sub(_value);
        // RS Ok
        balances[_to] = balances[_to].add(_value);
        // RS Ok
        Transfer(msg.sender, _to, _value);
        // RS Ok
        return true;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    // RS Ok
    function balanceOf(address _owner) public constant returns (uint256 balance) {
        // RS Ok
        return balances[_owner];
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
     // RS Ok
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        // RS Ok
        require(_to != address(0));
        // RS Ok
        require(_value <= balances[_from]);
        // RS Ok
        require(_value <= allowed[_from][msg.sender]);
        // RS Ok
        balances[_from] = balances[_from].sub(_value);
        // RS Ok
        balances[_to] = balances[_to].add(_value);
        // RS Ok
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        // RS Ok
        Transfer(_from, _to, _value);
        // RS Ok
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     *
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
     // RS Ok
    function approve(address _spender, uint256 _value) public returns (bool) {
        // RS Ok
        allowed[msg.sender][_spender] = _value;
        // RS Ok
        Approval(msg.sender, _spender, _value);
        // RS Ok
        return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
     // RS Ok
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        // RS Ok
        return allowed[_owner][_spender];
    }

    /**
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     */
     // RS Ok
    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
        // RS Ok
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        // RS Ok
        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        // RS Ok
        return true;
    }
    // RS Ok
    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
        // RS Ok
        uint oldValue = allowed[msg.sender][_spender];
        // RS Ok
        if (_subtractedValue > oldValue) {
            // RS Ok
            allowed[msg.sender][_spender] = 0;
            // RS Ok
        } else {
            // RS Ok
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        // RS Ok
        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        // RS Ok
        return true;
    }

}
```