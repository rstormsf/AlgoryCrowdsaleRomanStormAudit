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

function bigNumber(n) {
    return new web3.BigNumber(n)
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

const devsAddress = '0x58FC33aC6c7001925B4E9595b13B48bA73690a39';
const devsTokens = bigNumber(6450000 * 10**18);
const companyAddress = '0x78534714b6b02996990cd567ebebd24e1f3dfe99';
const companyTokens = bigNumber(6400000 * 10**18);
const bountyAddress = '0xd64a60de8A023CE8639c66dAe6dd5f536726041E';
const bountyTokens = bigNumber(2400000 * 10**18);
const totalSupply = bigNumber(120000000 * 10**18);
const preallocatedTokens = devsTokens.plus(companyTokens).plus(bountyTokens);
let beneficiary;

contract('Test Algory Crowdsale Preparing State', function(accounts) {
    const multisigWallet = accounts[accounts.length-1];
    let crowdsale, pricingStrategy, finalizeAgent, algory;
    let whitelistWeiRaised = 0;
    beneficiary = accounts[0];
    it("prepare suite by deploy contracts and set dates to make preparing state", function () {
        const presaleStartsAt = latestTime() + duration.days(10);
        const startsAt = presaleStartsAt + duration.days(10);
        const endsAt = startsAt + duration.days(10);
        return tokenContract.new()
            .then(function (instance) {algory = instance})
            .then(function () {return pricingStrategyContract.new()}).then(function (instance) {pricingStrategy = instance})
            .then(function () {return crowdsaleContract.new(algory.address, beneficiary, pricingStrategy.address, multisigWallet, presaleStartsAt, startsAt, endsAt)})
            .then(function(instance) {crowdsale = instance})
            .then(function() {return finalizeAgentContract.new(algory.address, crowdsale.address)}).then(function (instance) { finalizeAgent = instance})
            .then(function () {return algory.setReleaseAgent(finalizeAgent.address)})
            .then(function () {return algory.setTransferAgent(beneficiary, true)})
            .then(function () {return algory.approve(crowdsale.address, totalSupply)})
            .then(function () {return crowdsale.prepareCrowdsale()})
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
        let error;
        return finalizeAgentContract.new(algory.address, crowdsale.address)
            .then(function (instance) {
                invalidFinalizeAgent = instance;
                return crowdsale.setFinalizeAgent(invalidFinalizeAgent.address).catch(function (err) {
                    error = err;
                }).then(function () {
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
    it("shouldn't set invalid pricing strategy", function () {
        let invalidPricingStrategy;
        let errorCatch;
        return finalizeAgentContract.new(algory.address, crowdsale.address)
            .then(function (instance) {
                invalidPricingStrategy = instance;
                return crowdsale.setPricingStrategy(invalidPricingStrategy.address).catch(function (error) {
                    errorCatch = error;
                })
                .then(function () {
                    assert.ok(errorCatch, 'Invalid pricing strategy agent has been set');
                });
            })
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
        //Invalid dates
        let endsAt = latestTime() - duration.days(1);
        let startsAt = endsAt - duration.days(2);
        let presaleStartsAt = startsAt + duration.days(333);
        let errorPresale, errorStart, errorEnd;
        return crowdsale.setPresaleStartsAt(presaleStartsAt).catch(function(err) {
            errorPresale = err;
        }).then(function () {
            assert.ok(errorPresale, 'Error for presale date has not occurred')
        })
        .then(function () {
            crowdsale.setStartsAt(startsAt).catch(function(err) {
                errorStart = err;
            }).then(function () {
                assert.ok(errorStart, 'Error for start date has not occurred')
            })
        })
        .then(function () {
            crowdsale.setEndsAt(endsAt).catch(function(err) {
                errorEnd = err;
            }).then(function () {
                assert.ok(errorEnd, 'Errorfor end date  has not occurred')
            });
        })

    });
    it("should set participant to whitelist ", function () {
        let participant1 = '0x7777777'; let value1 = ether(10);
        let participant2 = accounts[2]; let value2 = ether(290);
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
    it("shouldn't set participant to whitelist with exceeded value", function () {
        const maxValue = ether(300);
        let participant = '0x665465456'; let value = ether(301);
        let error;
        return crowdsale.setEarlyParticipantWhitelist(participant, value).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Participant with exceeded value can set');
        })
    });
    it("should load participants to whitelist from array", function () {
        let participantsAddress = [
            '0x11111111', '0x222222222', '0x33333333333', '0x4444444444', '0x5555555555'
        ];
        let participantsValues = [
            ether(100), ether(50), ether(50), ether(200), ether(300)
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

    it("shouldn't set participant to whitelist when it is full", function () {
        let whitelistFull = ether(10000);
        let participantsAddress = [];
        let participantsValues = [];
        let i = 0;
        while (whitelistWeiRaised <= whitelistFull) {
            participantsAddress[i] = 0x1 + i;
            participantsValues[i] = ether(100);
            whitelistWeiRaised += ether(100).toNumber();
            i++;
        }
        //Fill whitelist
        return crowdsale.loadEarlyParticipantsWhitelist(participantsAddress, participantsValues)
            .then(function () {
                //Check is whitelisted is full
                return crowdsale.whitelistWeiRaised().then(function (weiRaised) {
                    assert.ok(weiRaised.toNumber() >= whitelistFull.toNumber(), 'Invalid whitelisted wei raised');
                    //Special case whitelist can be fill to I tranche + 300 ETH - 1
                    assert.ok(weiRaised.toNumber() < whitelistFull.toNumber() + ether(300), 'Invalid whitelisted wei raised')
                })
            })
            .then(function () {
                let error;
                return crowdsale.setEarlyParticipantWhitelist('0x8789876757545454', ether(233)).catch(function (err) {
                    error = err;
                }).then(function () {
                    assert.ok(error, 'Error has not occurred when whitelist is full');
                })
            })
    });
    it("shouldn't allow to buy tokens by anyone in preparing state", function () {
        let error;
        return crowdsale.sendTransaction({from: accounts[1], value: ether(1)}).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Crowdsale allow to buy')
        })
            .then(function () {
                // check also whitelisted account
                let error2;
                return crowdsale.sendTransaction({from: accounts[2], value: ether(1)}).catch(function (err) {
                    error2 = err;
                }).then(function () {
                    assert.ok(error2, 'Crowdsale allow to buy whitelisted account')
                })
            })
    });
    it("shouldn't allow to finalize crowdsale in preparing state", function () {
        let error;
        return crowdsale.finalize().catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Crowdsale allow to finalize')
        });
    });
    it("shouldn't allow to set refunding state in preparing state", function () {
        let error;
        return crowdsale.allowRefunding(true).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Crowdsale allow to refund')
        });
    });
    it("shouldn't allow to refund in preparing state", function () {
        let error;
        return crowdsale.refund({from: accounts[8]}).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Crowdsale allow to refund')
        });
    });
    it("should preallocate part of tokens to company, devs and bounty", function () {
        return algory.balanceOf(devsAddress).then(function (balance) {
            assert.deepEqual(balance, devsTokens, 'Devs tokens is invalid');
            return algory.balanceOf(companyAddress).then(function (balance) {
                assert.deepEqual(balance, companyTokens, 'Company tokens is invalid');
                return algory.balanceOf(bountyAddress).then(function (balance) {
                    assert.deepEqual(balance, bountyTokens, 'Bounty tokens is invalid');
                })
            })
        }).then(function () {
            return algory.allowance(beneficiary, crowdsale.address).then(function (tokens) {
                assert.deepEqual(tokens, totalSupply.minus(preallocatedTokens), 'Allowance of crowdsale is invalid')
            })
        })
    });
});
