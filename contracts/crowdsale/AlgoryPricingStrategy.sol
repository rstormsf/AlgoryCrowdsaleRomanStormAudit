pragma solidity ^0.4.15;

import '../ownership/Ownable.sol';
import './PricingStrategy.sol';
import '../math/SafeMathLib.sol';

contract AlgoryPricingStrategy is PricingStrategy, Ownable {

    using SafeMathLib for uint;

    /**
    * Define pricing schedule using tranches.
    */
    struct Tranche {
        // Amount in weis when this tranche becomes active
        uint amount;
        // How many tokens per wei you will get while this tranche is active
        uint price;
    }

    Tranche[4] public tranches;

    // How many active tranches we have
    uint public trancheCount = 4;

    function AlgoryPricingStrategy() {

        tranches[0].amount = 10000 ether;
        tranches[0].price = 1200;
//        tranches[0].price = 1200 / 1 ether;

        tranches[1].amount = 15000 ether;
        tranches[1].price = 1100;
//        tranches[1].price = 1100 / 1 ether;

        tranches[2].amount = 25000 ether;
        tranches[2].price = 1050;
//        tranches[2].price = 1050 / 1 ether;

        tranches[3].amount = 50000 ether;
        tranches[3].price = 1000;
//        tranches[3].price = 1000 / 1 ether;

        presaleMaxValue = 300 ether;
        trancheCount = tranches.length;
    }

    function isSane(address crowdsale) public constant returns (bool) {
        return true;
    }

    function getTranche(uint n) public constant returns (uint, uint) {
        if (n > trancheCount) revert();
        return (tranches[n].amount, tranches[n].price);
    }

    function getFirstTranche() private constant returns (Tranche) {
        return tranches[0];
    }

    function getLastTranche() private constant returns (Tranche) {
        return tranches[trancheCount-1];
    }

    function getPricingStartsAt() public constant returns (uint) {
        return getFirstTranche().amount;
    }

    function getPricingEndsAt() public constant returns (uint) {
        return getLastTranche().amount;
    }

    function isPresaleFull(uint presaleWeiRaised) public constant returns (bool) {
        return presaleWeiRaised > getFirstTranche().amount;
    }

    function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {
        for(uint i=0; i < tranches.length; i++) {
            if(weiRaised < tranches[i].amount) {
                return tranches[i-1];
            }
        }
    }

    function getCurrentPrice(uint weiRaised) public constant returns (uint result) {
        return getCurrentTranche(weiRaised).price;
    }

    /// @dev Calculate the current price for buy in amount.
    function calculatePrice(uint value, uint weiRaised, uint decimals) public constant returns (uint) {
        //uint multiplier = 10 ** decimals;
        uint price = getCurrentPrice(weiRaised);
//        return value.times(multiplier) / price;
        return value * price;
    }

    function() payable {
        revert();
    }

}