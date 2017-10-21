let crowdsaleContract = artifacts.require('./crowdsale/AlgoryCrowdsale.sol');
let finalizeAgentContract = artifacts.require('./crowdsale/AlgoryFinalizeAgent.sol');
let pricingStrategyContract = artifacts.require('./crowdsale/AlgoryPricingStrategy.sol');
let tokenContract = artifacts.require('./token/AlgoryToken.sol');

function latestTime() {
    return web3.eth.getBlock('latest').timestamp;
}

function ether(n) {
    return new web3.BigNumber(web3.toWei(n, 'ether'))
}

function checkIsEventTriggered(result, event) {
    for (let i = 0; i < result.logs.length; i++) {
        let log = result.logs[i];
        if (log.event == event) {
            return true;
        }
    }
    return false;
}

const duration = {
    seconds: function(val) { return val},
    minutes: function(val) { return val * this.seconds(60) },
    hours:   function(val) { return val * this.minutes(60) },
    days:    function(val) { return val * this.hours(24) },
    weeks:   function(val) { return val * this.days(7) },
    years:   function(val) { return val * this.days(365)}
};


contract('Test Algory Crowdsale Prefunding State', function(accounts) {
    let crowdsale, finalizeAgent, algory;
    let investorCount = 0;
    let presaleWeiRaised = 0;
    it("prepare suite by assign deployed contracts and set dates to make prefunding state", function () {
        let presaleStartsAt = latestTime();
        let startsAt = presaleStartsAt + duration.days(10);
        let endsAt = startsAt + duration.days(10);
        return crowdsaleContract.deployed()
            .then(function(instance) {crowdsale = instance})
            .then(function() {return finalizeAgentContract.deployed()}).then(function (instance) { finalizeAgent = instance})
            .then(function() {return tokenContract.deployed()}).then(function (instance) { algory = instance})
            .then(function () {return algory.setReleaseAgent(finalizeAgent.address)})
            .then(function () {return crowdsale.setFinalizeAgent(finalizeAgent.address)})

            .then(function () {return crowdsale.setEndsAt(endsAt)})
            .then(function () {return crowdsale.setStartsAt(startsAt)})
            .then(function() {return crowdsale.setPresaleStartsAt(presaleStartsAt)})
    });
    it("should in prefunding state", function () {
        return crowdsale.getState()
            .then(function (state) {
                assert.equal(state.toNumber(), 2, 'Crowdsale state is not in prefunding state');
            })
    });
    it("should replace multisig wallet if investment count is less than 6", function () {
        let anotherWallet = accounts[7];
        return crowdsale.setMultisigWallet(anotherWallet)
            .then(function () {
                return crowdsale.multisigWallet()
            })
            .then(function (wallet) {
                assert.equal(wallet, anotherWallet, 'Another Multisig Wallet has not replaced');
            });
    });
    it("shouldn't replace multisig wallet if investment count is grater than 5", function () {
        //TODO
    });
    it("shouldn't replace pricing strategy to another", function () {
        return pricingStrategyContract.new()
            .then(function (instance) {
                return crowdsale.setPricingStrategy(instance.address).catch(function (error) {
                    assert.ok(error, 'Crowdsale allow to replace pricing startegy');
                })
            })
    });
    it("shouldn't set presale date", function () {
        let presaleStartsAt = latestTime() + duration.days(1);
        return crowdsale.setPresaleStartsAt(presaleStartsAt)
            .catch(function(err) {
                assert.ok(err, 'Error has not occurred')
            });

    });
    it("should set presale, start and end dates", function () {
        let startsAt = latestTime() + duration.days(77);
        let endsAt = startsAt + duration.days(77);
        let resultForStart, resultForEnd;
        return crowdsale.setEndsAt(endsAt)
            .then(function (result) {
                resultForEnd = result;
            })
            .then(function () {
                return crowdsale.setStartsAt(startsAt)
            })
            .then(function (result) {
                resultForStart = result;
            })
            .then(function () {
                assert.ok(checkIsEventTriggered(resultForStart, "TimeBoundaryChanged"), 'Event TimeBoundaryChanged for startsAt has not triggered');
                assert.ok(checkIsEventTriggered(resultForEnd, "TimeBoundaryChanged"), 'Event TimeBoundaryChanged for endsAt has not triggered');
            })
            .then(function () {
                return crowdsale.startsAt()
            })
            .then(function (timestamp) {
                assert.equal(timestamp, startsAt, 'StartsAt has not replaced');
            })
            .then(function () {
                return crowdsale.endsAt()
            })
            .then(function (timestamp) {
                assert.equal(timestamp, endsAt, 'EndsAt has not replaced');
            });
    });
    it("shouldn't allow to buy tokens by anyone in preparing state", function () {
        return crowdsale.sendTransaction({from: accounts[1], value: ether(1)}).catch(function (error) {
            assert.ok(error, 'Crowdsale allow to buy')
        });
    });
    it("shouldn't allow to finalize crowdsale in preparing state", function () {
        return crowdsale.finalize().catch(function (error) {
            assert.ok(error, 'Crowdsale allow to finalize')
        });
    });
    it("shouldn't allow to set refunding state in preparing state", function () {
        return crowdsale.allowRefunding(true).catch(function (error) {
            assert.ok(error, 'Crowdsale allow to refund')
        });
    });
    it("shouldn't allow to refund in preparing state", function () {
        return crowdsale.refund({from: accounts[8]}).catch(function (error) {
            assert.ok(error, 'Crowdsale allow to refund')
        });
    });
    it("should allow to buy some tokens by whitelisted participant", function () {
        let participant = accounts[2];
        let valueParticipant = ether(8);
        let valueToBuy = ether(4);
        return crowdsale.setEarlyParticipantWhitelist(participant, valueParticipant)
            .then(function (result) {
                assert.ok(checkIsEventTriggered(result, "Whitelisted", 'Event Whitelisted has not triggered'));
            })
            .then(function () {
                return crowdsale.earlyParticipantWhitelist(participant).then(function (value) {
                    assert.equal(value.toNumber(), valueParticipant.toNumber(), 'Participant value is invalid');
                })
            })
            .then(function () {
                return crowdsale.sendTransaction({from: participant, value: valueToBuy})
            })
            .then(function (result) {
                investorCount++;
                assert.ok(checkIsEventTriggered(result, "Invested", 'Event Invested has not triggered'));
                return crowdsale.investorCount()
            })
            .then(function (investors) {
                assert.equal(investors.toNumber(), investorCount, 'Investors count is invalid');
                // return crowdsale.investedAmountOf(participant)
            })
            // .then(function (amount) {
            //     presaleWeiRaised += amount;
            //     assert.equal(amount.toNumber(), valueToBuy.toNumber(), 'Invested amount is invalid');
            //     return crowdsale.tokenAmountOf(participant)
            // })
            // .then(function (tokensAmount) {
            //     assert.equal(tokensAmount.toNumber(), 333333, 'Purchased tokens amount is invalid');
            //     return crowdsale.tokenAmountOf(participant)
            // })
            // .then(function (tokensAmount) {
            //     assert.equal(tokensAmount.toNumber(), 333333, 'Purchased tokens amount is invalid');
            //     return crowdsale.presaleWeiRaised()
            // })
            // .then(function (presaleWei) {
            //     assert.equal(presaleWei.toNumber(), presaleWeiRaised, 'Investors count is invalid');
            // })
    });
});
