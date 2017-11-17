# AlgoryPricingStrategy
Source file [../../contracts/crowdsale/AlgoryPricingStrategy.sol](../../contracts/crowdsale/AlgoryPricingStrategy.sol).


<br />

<hr />

```javascript
// RS Ok
pragma solidity ^0.4.15;
// RS Ok
import '../ownership/Ownable.sol';
// RS Ok
import './PricingStrategy.sol';
// RS Ok
import '../math/SafeMath.sol';
// RS Ok
contract AlgoryPricingStrategy is PricingStrategy, Ownable {
    // RS Ok
    using SafeMath for uint;

    /**
    * Define pricing schedule using tranches.
    */
    // RS Ok
    struct Tranche {
        // Amount in weis when this tranche becomes active
        // RS Ok
        uint amount;
        // How many tokens per wei you will get while this tranche is active
        // RS Ok
        uint rate;
    }
    // RS Ok
    Tranche[4] public tranches;

    // How many active tranches we have
    // RS Ok
    uint public trancheCount = 4;
    // RS Ok
    function AlgoryPricingStrategy() {
        // RS Ok
        tranches[0].amount = 0;
        tranches[0].rate = 1200;
        // RS Ok
        tranches[1].amount = 10000 ether;
        tranches[1].rate = 1100;
        // RS Ok
        tranches[2].amount = 25000 ether;
        tranches[2].rate = 1050;
        // RS Ok
        tranches[3].amount = 50000 ether;
        tranches[3].rate = 1000;
        // RS Ok
        trancheCount = tranches.length;
        presaleMaxValue = 300 ether;
    }
    // RS Ok
    function() public payable {
        // RS Ok
        revert();
    }
    // RS Ok. Public is preferred vs `external`
    function getTranche(uint n) external constant returns (uint amount, uint rate) {
        // RS Ok
        require(n < trancheCount);
        // RS Ok
        return (tranches[n].amount, tranches[n].rate);
    }
    // RS Ok
    function isPresaleFull(uint presaleWeiRaised) public constant returns (bool) {
        // RS Ok
        return presaleWeiRaised > tranches[1].amount;
    }
    // RS Ok
    function getCurrentRate(uint weiRaised) public constant returns (uint) {
        // RS Ok
        return getCurrentTranche(weiRaised).rate;
    }
    // RS Ok
    function getAmountOfTokens(uint value, uint weiRaised) public constant returns (uint tokensAmount) {
        // RS Ok
        require(value > 0);
        // RS Ok
        uint rate = getCurrentRate(weiRaised);
        // RS Ok
        return value.mul(rate);
    }
    // RS Ok
    function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {
        // RS Ok
        for(uint i=1; i < tranches.length; i++) {
            // RS Ok
            if(weiRaised <= tranches[i].amount) {
                // RS Ok
                return tranches[i-1];
            }
        }// RS Ok
        return tranches[tranches.length-1];
    }
}
```