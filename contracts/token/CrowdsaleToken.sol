pragma solidity ^0.4.15;

import './ReleasableToken.sol';
import './FractionalERC20.sol';
import './BurnableToken.sol';

/**
 * Base crowdsale token interface
 */
contract CrowdsaleToken is FractionalERC20, BurnableToken, ReleasableToken {

}