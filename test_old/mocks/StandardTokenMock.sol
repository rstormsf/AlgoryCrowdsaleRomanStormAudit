pragma solidity ^0.4.15;

import '../../contracts/token/StandardToken.sol';

contract StandardTokenMock is StandardToken {

    string public name = 'Mock';
    string public symbol = 'MCK';
    uint public decimals = 18;

    function StandardTokenMock() {
        totalSupply = 120000000;
        balances[msg.sender] = totalSupply;
    }
}