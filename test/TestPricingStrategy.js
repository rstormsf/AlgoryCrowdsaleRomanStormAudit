
let pricingStrategyContract = artifacts.require('./crowdsale/AlgoryPricingStrategy.sol');

function ether(n) {
    return new web3.BigNumber(web3.toWei(n, 'ether'))
}

contract('Test Algory Pricing Strategy', function(accounts) {
    const tokenDecimals = 18;
    const presaleMaxValue = ether(300);
    const tranches = [
        {amount: 0, rate: 1200},
        {amount: ether(10000), rate: 1100},
        {amount: ether(25000), rate: 1050},
        {amount: ether(50000), rate: 1000},
    ];

    let pricingStrategy;

    it("prepare suite by assign deployed contract", function () {
        return pricingStrategyContract.deployed()
            .then(function(instance) {pricingStrategy = instance})
    });
    it("should get proper presale max value per one investor", function () {
        return pricingStrategy.getPresaleMaxValue()
            .then(function(maxValue) {
                assert.equal(maxValue.toNumber(), presaleMaxValue, 'Presale max value is invalid');
            })
    });
    it("should get proper tranches", function () {
        return pricingStrategy.trancheCount().then(function (trancheCount) {
            assert.equal(trancheCount, tranches.length, 'There are not 4 tranches');
        })
        .then(function () {
            return pricingStrategy.getTranche(0);
        })
        .then(function (tranche) {
            assert.equal(tranche[0].toNumber(), tranches[0].amount, 'Amount is invalid');
            assert.equal(tranche[1].toNumber(), tranches[0].rate, 'Price is invalid');
        })
        .then(function () {
            return pricingStrategy.getTranche(1);
        })
        .then(function (tranche) {
            assert.equal(tranche[0].toNumber(), tranches[1].amount, 'Amount is invalid');
            assert.equal(tranche[1].toNumber(), tranches[1].rate, 'Price is invalid');
        })
        .then(function () {
            return pricingStrategy.getTranche(2);
        })
        .then(function (tranche) {
            assert.equal(tranche[0].toNumber(), tranches[2].amount, 'Amount is invalid');
            assert.equal(tranche[1].toNumber(), tranches[2].rate, 'Price is invalid');
        })
        .then(function () {
            return pricingStrategy.getTranche(3);
        })
        .then(function (tranche) {
            assert.equal(tranche[0].toNumber(), tranches[3].amount, 'Amount is invalid');
            assert.equal(tranche[1].toNumber(), tranches[3].rate, 'Price is invalid');
        });
    });
    it("should check is presale full", function () {
        return pricingStrategy.isPresaleFull(tranches[0].amount)
            .then(function(isPresaleFull) {
                assert.ok(!isPresaleFull, 'Presale is full');
            })
            .then (function () {
                return pricingStrategy.isPresaleFull(tranches[0].amount + ether(1))
            })
            .then (function (isPresaleFull) {
                assert.ok(isPresaleFull, 'Presale is not full');
            })
    });
    it("shouldn't allow to send money to this contract", function () {
        return pricingStrategy.sendTransaction({from: accounts[1], value: ether(1)}).catch(function (error) {
            assert.ok(error, 'Pricing Strategy allow to buy')
        })
    });
    it("should get current rate", function () {
        let weiRaised = ether(77);
        return pricingStrategy.getCurrentRate(weiRaised).then(function(rate) {
            assert.equal(rate.toNumber(), tranches[0].rate, 'Current rate for amount '+weiRaised+' is invalid');
        })
        .then (function () {
            weiRaised = ether(11000);
            return pricingStrategy.getCurrentRate(weiRaised).then (function (rate) {
                assert.equal(rate.toNumber(), tranches[1].rate, 'Current rate for amount '+weiRaised+' is invalid');
            })
        })
        .then (function () {
            weiRaised = ether(26000);
            return pricingStrategy.getCurrentRate(weiRaised).then (function (rate) {
                assert.equal(rate.toNumber(), tranches[2].rate, 'Current rate for amount '+weiRaised+' is invalid');
            })
        })
        .then (function () {
            weiRaised = ether(50001);
            return pricingStrategy.getCurrentRate(weiRaised).then (function (rate) {
                assert.equal(rate.toNumber(), tranches[3].rate, 'Current rate for amount '+weiRaised+' is invalid');
            })
        })
        .then (function () {
            weiRaised = ether(10000);
            return pricingStrategy.getCurrentRate(weiRaised).then (function (rate) {
                assert.equal(rate.toNumber(), tranches[0].rate, 'Current rate for amount '+weiRaised+' is invalid');
            })
        })
        .then (function () {
            weiRaised = ether(10001);
            return pricingStrategy.getCurrentRate(weiRaised).then (function (rate) {
                assert.equal(rate.toNumber(), tranches[1].rate, 'Current rate for amount '+weiRaised+' is invalid');
            })
        })
        .then (function () {
            weiRaised = ether(25000);
            return pricingStrategy.getCurrentRate(weiRaised).then (function (rate) {
                assert.equal(rate.toNumber(), tranches[1].rate, 'Current rate for amount '+weiRaised+' is invalid');
            })
        })
        .then (function () {
            weiRaised = ether(25001);
            return pricingStrategy.getCurrentRate(weiRaised).then (function (rate) {
                assert.equal(rate.toNumber(), tranches[2].rate, 'Current rate for amount '+weiRaised+' is invalid');
            })
        })
        .then (function () {
            weiRaised = ether(25001);
            return pricingStrategy.getCurrentRate(weiRaised).then (function (rate) {
                assert.equal(rate.toNumber(), tranches[2].rate, 'Current rate for amount '+weiRaised+' is invalid');
            })
        })
        .then (function () {
            weiRaised = ether(50001);
            return pricingStrategy.getCurrentRate(weiRaised).then (function (rate) {
                assert.equal(rate.toNumber(), tranches[3].rate, 'Current rate for amount '+weiRaised+' is invalid');
            })
        })
    });
    it("should get proper amount of tokens in I tranche", function () {
        let weiRaised = ether(77); // I tranche
        const multiplier = 10 ** tokenDecimals;
        let value = ether(7);
        let expectedAmountOfTokens = tranches[0].rate * 7 * multiplier;

        return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function(tokensAmount) {
            assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
        }).then(function () {
            let value = ether(856);
            let expectedAmountOfTokens = tranches[0].rate * 856 * multiplier;
            pricingStrategy.getAmountOfTokens(value, weiRaised).then(function (tokensAmount) {
                assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
            });
        }).then(function () {
            let value = ether(0.006);
            let expectedAmountOfTokens = tranches[0].rate * 0.006 * multiplier;
            pricingStrategy.getAmountOfTokens(value, weiRaised).then(function (tokensAmount) {
                assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
            });
        }).then(function () {
            let value = 7700000;
            let expectedAmountOfTokens = tranches[0].rate * 7700000;
            pricingStrategy.getAmountOfTokens(value, weiRaised).then(function (tokensAmount) {
                assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
            });
        })

    });
    it("should get proper amount of tokens in II tranche", function () {
        let weiRaised = ether(10001); // I tranche
        const multiplier = 10 ** tokenDecimals;
        let value = ether(7);
        let expectedAmountOfTokens = tranches[1].rate * 7 * multiplier;

        return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function(tokensAmount) {
            assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
        }).then(function () {
            let value = ether(856);
            let expectedAmountOfTokens = tranches[1].rate * 856 * multiplier;
            pricingStrategy.getAmountOfTokens(value, weiRaised).then(function (tokensAmount) {
                assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
            });
        })
        // .then(function () {
        //     let value = ether(0.006);
        //     let expectedAmountOfTokens = tranches[1].rate * 0.006 * multiplier;
        //     pricingStrategy.getAmountOfTokens(value, weiRaised).then(function (tokensAmount) {
        //         assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
        //     });
        // })
    });
});
