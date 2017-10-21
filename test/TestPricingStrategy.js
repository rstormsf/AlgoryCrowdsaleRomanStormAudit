
let pricingStrategyContract = artifacts.require('./crowdsale/AlgoryPricingStrategy.sol');

contract('Test Algory Pricing Strategy', function(accounts) {
    let pricingStrategy;
    it("prepare suite by assign deployed contract", function () {
        return pricingStrategyContract.deployed()
            .then(function(instance) {pricingStrategy = instance})
    });
    it("should check is crowdsale", function () {
        return crowdsale.isCrowdsale()
            .then(function (isCrowdsale) {
                assert.ok(isCrowdsale, 'Contract is not crowdsale');
            });
    });
});
