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
        uint rate;
    }

    Tranche[4] public tranches;

    // How many active tranches we have
    uint public trancheCount = 4;

    function AlgoryPricingStrategy() {

        tranches[0].amount = 0;
        tranches[0].rate = 1200;

        tranches[1].amount = 10000 ether;
        tranches[1].rate = 1100;

        tranches[2].amount = 25000 ether;
        tranches[2].rate = 1050;

        tranches[3].amount = 50000 ether;
        tranches[3].rate = 1000;

        presaleMaxValue = 300 ether;
        trancheCount = tranches.length;
    }

    function isSane(address crowdsale) public constant returns (bool) {
        return true;
    }

    function getTranche(uint n) public constant returns (uint amount, uint) {
        require(n <= trancheCount);
        return (tranches[n].amount, tranches[n].rate);
    }

    function isPresaleFull(uint presaleWeiRaised) public constant returns (bool) {
        return presaleWeiRaised > tranches[0].amount;
    }

    function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {
        for(uint i=0; i < tranches.length; i++) {
            if(weiRaised <= tranches[i].amount) {
                return tranches[i-1];
            }
        }
        return tranches[3];
    }

    function getCurrentRate(uint weiRaised) public constant returns (uint rate) {
        return getCurrentTranche(weiRaised).rate;
    }

    function getAmountOfTokens(uint value, uint weiRaised) public constant returns (uint tokensAmount) {
        require(value > 0 && weiRaised > 0);
        uint rate = getCurrentRate(weiRaised);
        return value * rate;
    }

    function() public payable {
        revert();
    }

}