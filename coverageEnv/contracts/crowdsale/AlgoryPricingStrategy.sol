pragma solidity ^0.4.15;

import '../ownership/Ownable.sol';
import './PricingStrategy.sol';
import '../math/SafeMathLib.sol';

contract AlgoryPricingStrategy is PricingStrategy, Ownable {event __CoverageAlgoryPricingStrategy(string fileName, uint256 lineNumber);
event __FunctionCoverageAlgoryPricingStrategy(string fileName, uint256 fnId);
event __StatementCoverageAlgoryPricingStrategy(string fileName, uint256 statementId);
event __BranchCoverageAlgoryPricingStrategy(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageAlgoryPricingStrategy(string fileName, uint256 branchId);
event __AssertPostCoverageAlgoryPricingStrategy(string fileName, uint256 branchId);


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

    function AlgoryPricingStrategy() {__FunctionCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',1);


__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',28);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',1);
tranches[0].amount = 0;
__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',29);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',2);
tranches[0].rate = 1200;

__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',31);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',3);
tranches[1].amount = 10000 ether;
__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',32);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',4);
tranches[1].rate = 1100;

__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',34);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',5);
tranches[2].amount = 25000 ether;
__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',35);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',6);
tranches[2].rate = 1050;

__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',37);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',7);
tranches[3].amount = 50000 ether;
__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',38);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',8);
tranches[3].rate = 1000;

__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',40);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',9);
trancheCount = tranches.length;
__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',41);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',10);
presaleMaxValue = 300 ether;
    }

    function() public payable {__FunctionCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',2);

__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',45);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',11);
revert();
    }

    function getTranche(uint n) external constant returns (uint amount, uint rate) {__FunctionCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',3);

__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',49);
        __AssertPreCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',1);
 __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',12);
require(n <= trancheCount);__AssertPostCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',1);

__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',50);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',13);
return (tranches[n].amount, tranches[n].rate);
    }

    function isPresaleFull(uint presaleWeiRaised) public constant returns (bool) {__FunctionCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',4);

__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',54);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',14);
return presaleWeiRaised > tranches[1].amount;
    }

    function getCurrentRate(uint weiRaised) public constant returns (uint) {__FunctionCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',5);

__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',58);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',15);
return getCurrentTranche(weiRaised).rate;
    }

    function getAmountOfTokens(uint value, uint weiRaised) public constant returns (uint tokensAmount) {__FunctionCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',6);

__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',62);
        __AssertPreCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',2);
 __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',16);
require(value > 0);__AssertPostCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',2);

__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',63);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',17);
uint rate = getCurrentRate(weiRaised);
__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',64);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',18);
return value.times(rate);
    }

    function getCurrentTranche(uint weiRaised) private constant returns (Tranche) {__FunctionCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',7);

__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',68);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',19);
for(uint i=1; i < tranches.length; i++) {
__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',69);
             __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',20);
if(weiRaised <= tranches[i].amount) {__BranchCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',3,0);
__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',70);
                 __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',21);
return tranches[i-1];
            }else { __BranchCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',3,1);}

        }
__CoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',73);
         __StatementCoverageAlgoryPricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/AlgoryPricingStrategy.sol',22);
return tranches[tranches.length-1];
    }
}