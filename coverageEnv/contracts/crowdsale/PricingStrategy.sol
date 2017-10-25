pragma solidity ^0.4.15;

/**
 * Interface for defining crowdsale pricing.
 */
contract PricingStrategy {event __CoveragePricingStrategy(string fileName, uint256 lineNumber);
event __FunctionCoveragePricingStrategy(string fileName, uint256 fnId);
event __StatementCoveragePricingStrategy(string fileName, uint256 statementId);
event __BranchCoveragePricingStrategy(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoveragePricingStrategy(string fileName, uint256 branchId);
event __AssertPostCoveragePricingStrategy(string fileName, uint256 branchId);


  // How many tokens per one investor is allowed in presale
  uint public presaleMaxValue = 0;

  function isPricingStrategy() external constant returns (bool) {__FunctionCoveragePricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/PricingStrategy.sol',1);

__CoveragePricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/PricingStrategy.sol',12);
       __StatementCoveragePricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/PricingStrategy.sol',1);
return true;
  }

  function getPresaleMaxValue() public constant returns (uint) {__FunctionCoveragePricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/PricingStrategy.sol',2);

__CoveragePricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/PricingStrategy.sol',16);
       __StatementCoveragePricingStrategy('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/PricingStrategy.sol',2);
return presaleMaxValue;
  }

  function isPresaleFull(uint weiRaised) public constant returns (bool);

  function getAmountOfTokens(uint value, uint weiRaised) public constant returns (uint tokensAmount);
}