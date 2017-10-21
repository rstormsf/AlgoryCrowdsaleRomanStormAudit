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


contract('Test Algory Crowdsale Preparing State', function(accounts) {
    let crowdsale, finalizeAgent, algory;
    let whitelistWeiRaised = 0;
    it("prepare suite by assign deployed contracts and set dates to make preparing state", function () {
        let presaleStartsAt = latestTime() + duration.days(10);
        let startsAt = presaleStartsAt + duration.days(10);
        let endsAt = startsAt + duration.days(10);
        return crowdsaleContract.deployed()
            .then(function(instance) {crowdsale = instance})
            .then(function() {return finalizeAgentContract.deployed()}).then(function (instance) { finalizeAgent = instance})
            .then(function() {return tokenContract.deployed()}).then(function (instance) { algory = instance})
            .then(function () {return algory.setReleaseAgent(finalizeAgent.address)})


            .then(function () {return crowdsale.setEndsAt(endsAt)})
            .then(function () {return crowdsale.setStartsAt(startsAt)})
            .then(function() {return crowdsale.setPresaleStartsAt(presaleStartsAt)})
    });
    it("should in preparing state", function () {
        return crowdsale.getState()
            .then(function (state) {
                assert.equal(state, 1, 'Crowdsale state is not in preparing state');
            })
    });
    it("should replace multisig wallet", function () {
        let anotherWallet = accounts[7];
        return crowdsale.setMultisigWallet(anotherWallet)
            .then(function () {
                return crowdsale.multisigWallet()
            })
            .then(function (wallet) {
                assert.equal(wallet, anotherWallet, 'Another Multisig Wallet has not replaced');
            });
    });
    it("should set finalize agent", function () {
        return crowdsale.setFinalizeAgent(finalizeAgent.address)
            .then(function () {
                return crowdsale.finalizeAgent()
            })
            .then(function (agent) {
                assert.equal(agent, finalizeAgent.address, 'Finalize agent has not set');
            });
    });
    it("shouldn't set invalid finalize agent", function () {
        let invalidFinalizeAgent;
        return finalizeAgentContract.new(algory.address, crowdsale.address)
            .then(function (instance) {
                invalidFinalizeAgent = instance;
                return crowdsale.setFinalizeAgent(invalidFinalizeAgent.address).catch(function (error) {
                    assert.ok(error, 'Invalid finalize agent has been set');
                });
            })
    });
    it("should replace pricing strategy to another", function () {
        let anotherPricingStrategy;
        return pricingStrategyContract.new()
            .then(function (instance) {
                anotherPricingStrategy = instance;
                return crowdsale.setPricingStrategy(anotherPricingStrategy.address)
            })
            .then(function () {
                return crowdsale.pricingStrategy()
            })
            .then(function (pricingStrategy) {
                assert.equal(pricingStrategy, anotherPricingStrategy.address, 'Another Pricing Strategy has not replaced');
            });
    });
    it("should set presale, start and end dates", function () {
        let presaleStartsAt = latestTime() + duration.days(77);
        let startsAt = presaleStartsAt + duration.days(77);
        let endsAt = startsAt + duration.days(77);
        let resultForStart, resultForEnd, resultForPresale;
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
            .then (function () {
                return crowdsale.setPresaleStartsAt(presaleStartsAt)
            })
            .then(function (result) {
                resultForPresale = result;
            })
            .then(function () {
                assert.ok(checkIsEventTriggered(resultForPresale, "TimeBoundaryChanged"), 'Event TimeBoundaryChanged for presaleStartsAt has not triggered');
                assert.ok(checkIsEventTriggered(resultForStart, "TimeBoundaryChanged"), 'Event TimeBoundaryChanged for startsAt has not triggered');
                assert.ok(checkIsEventTriggered(resultForEnd, "TimeBoundaryChanged"), 'Event TimeBoundaryChanged for endsAt has not triggered');
            })
            .then(function () {
                return crowdsale.presaleStartsAt()
            })
            .then(function (timestamp) {
                assert.equal(timestamp, presaleStartsAt, 'Presale startsAt has not replaced');
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
    it("shouldn't set invalid presale, start and end dates", function () {
        let endsAt = latestTime() - duration.days(1);
        let startsAt = endsAt - duration.days(2);
        let presaleStartsAt = startsAt - duration.days(3);
        return crowdsale.setPresaleStartsAt(presaleStartsAt)
            .catch(function(err) {
                assert.ok(err, 'Error has not occurred')
            })
            .then(function () {
                crowdsale.setStartsAt(startsAt).catch(function(err) {
                    assert.ok(err, 'Error has not occurred')
                })
            })
            .then(function () {
                crowdsale.setEndsAt(endsAt).catch(function(err) {
                    assert.ok(err, 'Error has not occurred')
                });
            })

    });
    it("should set participant to whitelist ", function () {
        let participant1 = '0x7777777'; let value1 = ether(7);
        let participant2 = accounts[2]; let value2 = ether(8);
        return crowdsale.setEarlyParticipantWhitelist(participant1, value1)
            .then(function (result) {
                assert.ok(checkIsEventTriggered(result, "Whitelisted", 'Event Whitelisted has not triggered'));
            })
            .then(function () {
                return crowdsale.earlyParticipantWhitelist(participant1).then(function (value) {
                    assert.equal(value.toNumber(), value1.toNumber(), 'Participant value is invalid');
                    whitelistWeiRaised += value1.toNumber();
                })
            })
            .then(function () {
                return crowdsale.setEarlyParticipantWhitelist(participant2, value2)
            })
            .then(function (result) {
                assert.ok(checkIsEventTriggered(result, "Whitelisted", 'Event Whitelisted has not triggered'));
            })
            .then(function () {
                return crowdsale.earlyParticipantWhitelist(participant2).then(function (value) {
                    assert.equal(value.toNumber(), value2.toNumber(), 'Participant value is invalid');
                    whitelistWeiRaised += value2.toNumber();
                })
            })
            .then(function () {
                return crowdsale.earlyParticipantWhitelist('0x9999999').then(function (value) {
                    assert.equal(value.toNumber(), 0, 'Participant value is invalid');
                })
            })
            .then(function () {
                return crowdsale.whitelistWeiRaised().then(function (weiRaised) {
                    assert.equal(weiRaised.toNumber(), whitelistWeiRaised, 'Whitelisted Wei Raised is invalid');
                })
            });
    });
    it("should load participants to whitelist from array", function () {
        let participantsAddress = [
            '0x11', '0x222', '0x333', '0x444', '0x555'
        ];
        let participantsValues = [
            ether(1), ether(2), ether(3), ether(4), ether(5)
        ];
        let totalValues = 0;
        participantsValues.forEach(function (val) {
            totalValues += val.toNumber();
        });
        return crowdsale.loadEarlyParticipantsWhitelist(participantsAddress, participantsValues)
            .then(function (result) {
                let whitelistedCount = 0;
                for (let i = 0; i < result.logs.length; i++) {
                    let log = result.logs[i];
                    if (log.event == "Whitelisted") {
                        whitelistedCount++;
                    }
                }
                assert.equal(whitelistedCount, participantsAddress.length, 'Not all participants has been whitelisted');
                whitelistWeiRaised += totalValues;
            })
            .then(function () {
                return crowdsale.earlyParticipantWhitelist(participantsAddress[0]).then(function (value) {
                    assert.equal(value.toNumber(), participantsValues[0], 'Participant value is invalid');
                })
            })
            .then(function () {
                return crowdsale.earlyParticipantWhitelist(participantsAddress[3]).then(function (value) {
                    assert.equal(value.toNumber(), participantsValues[3], 'Participant value is invalid');
                })
            })
            .then(function () {
                return crowdsale.whitelistWeiRaised().then(function (weiRaised) {
                    assert.equal(weiRaised.toNumber(), whitelistWeiRaised, 'Whitelisted Wei Raised is invalid');
                })
            });

    });
    it("shouldn't allow to buy tokens by anyone in preparing state", function () {
        return crowdsale.sendTransaction({from: accounts[1], value: ether(1)}).catch(function (error) {
            assert.ok(error, 'Crowdsale allow to buy')
        })
            .then(function () {
                // check also whitelisted account
                return crowdsale.sendTransaction({from: accounts[2], value: ether(1)}).catch(function (error) {
                    assert.ok(error, 'Crowdsale allow to buy whitelisted account')
                })
            })
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
});
