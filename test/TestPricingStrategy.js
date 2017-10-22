
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
    it("shouldn't get tranche out of range", function () {
        let error;
        return pricingStrategy.getTranche(4).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Pricing Strategy allow to get out of range tranche');
        });
    });
    it("should check is presale full", function () {
        const outOfTranche1 = ether(10001);
        return pricingStrategy.isPresaleFull(ether(9999))
            .then(function(isPresaleFull) {
                assert.ok(!isPresaleFull, 'Presale is full');
            })
            .then (function () {
                return pricingStrategy.isPresaleFull(outOfTranche1)
            })
            .then (function (isPresaleFull) {
                assert.ok(isPresaleFull, 'Presale is not full for amount '+outOfTranche1);
            })
    });
    it("shouldn't allow to send money to this contract", function () {
        let error;
        return pricingStrategy.sendTransaction({from: accounts[1], value: ether(1)}).catch(function (err) {
            error =err;
        }).then(function () {
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
        let value = ether(7);
        let expectedAmountOfTokens = tranches[0].rate * value;

        return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function(tokensAmount) {
            assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
        }).then(function () {
            value = ether(856);
            expectedAmountOfTokens = tranches[0].rate * value;
            return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function (tokensAmount) {
                assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
            });
        }).then(function () {
            value = 6 * 10**6;
            expectedAmountOfTokens = tranches[0].rate * value;
            return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function (tokensAmount) {
                assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
            });
        }).then(function () {
            value = 7700000;
            expectedAmountOfTokens = tranches[0].rate * value;
            return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function (tokensAmount) {
                assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
            });
        }).then(function () {
            value = 77;
            expectedAmountOfTokens = tranches[0].rate * value;
            return pricingStrategy.getAmountOfTokens(value, 0).then(function (tokensAmount) {
                assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
            });
        })

    });
    it("should get proper amount of tokens in II tranche", function () {
        let weiRaised = ether(10001); // II tranche
        let value = ether(7);
        let expectedAmountOfTokens = tranches[1].rate * value.toNumber();

        return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function(tokensAmount) {
            assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens 1');
        })
        .then(function () {
            value = ether(856);
            expectedAmountOfTokens = tranches[1].rate * value;
            return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function (tokensAmount) {
                assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens 2');
            });
        })
        .then(function () {
            value = 6 * 10**5;
            expectedAmountOfTokens = tranches[1].rate * value;
            return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function (tokensAmount) {
                assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens 3');
            });
        })
    });
    it("should get proper amount of tokens in III tranche", function () {
        let weiRaised = ether(25001); // III tranche

        let value = ether(64);
        let expectedAmountOfTokens = tranches[2].rate * value;
        return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function(tokensAmount) {
            assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
        }).then(function () {
            value = ether(869);
            expectedAmountOfTokens = tranches[2].rate * value;
            return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function (tokensAmount) {
                assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
            });
        })
        .then(function () {
            value = 78 * 10**5;
            expectedAmountOfTokens = tranches[2].rate * value;
            return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function (tokensAmount) {
                assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
            });
        })
    });
    it("should get proper amount of tokens in IV tranche", function () {
        let weiRaised = ether(50001); // IV tranche

        let value = ether(1);
        let expectedAmountOfTokens = tranches[3].rate * value;
        return pricingStrategy.getAmountOfTokens(value, weiRaised).then(function(tokensAmount) {
            assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
        })
            .then(function () {
                value = ether(869);
                expectedAmountOfTokens = tranches[3].rate * value;
                return pricingStrategy.getAmountOfTokens(value, ether(75000)).then(function (tokensAmount) {
                    assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
                });
            })
            .then(function () {
                value = 78 * 10**5;
                expectedAmountOfTokens = tranches[3].rate * value;
                return pricingStrategy.getAmountOfTokens(value, ether(917777)).then(function (tokensAmount) {
                    assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Invalid amount of tokens');
                });
            })
    });
    it("shouldn't get amount of tokens for 0 value", function () {
        let error;
        return pricingStrategy.getAmountOfTokens(0, 111).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Pricing Strategy allow to get amount of tokens for 0 value');
        })
    });
});
