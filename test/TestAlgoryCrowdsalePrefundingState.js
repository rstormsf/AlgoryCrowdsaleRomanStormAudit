let crowdsaleContract = artifacts.require('./crowdsale/AlgoryCrowdsale.sol');
let finalizeAgentContract = artifacts.require('./crowdsale/AlgoryFinalizeAgent.sol');
let pricingStrategyContract = artifacts.require('./crowdsale/AlgoryPricingStrategy.sol');
let tokenContract = artifacts.require('./token/AlgoryToken.sol');

const duration = {
    seconds: function(val) { return val},
    minutes: function(val) { return val * this.seconds(60) },
    hours:   function(val) { return val * this.minutes(60) },
    days:    function(val) { return val * this.hours(24) },
    weeks:   function(val) { return val * this.days(7) },
    years:   function(val) { return val * this.days(365)}
};

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


const totalSupply = 120000000 * 10**18;
let crowdsale, finalizeAgent, algory;
let investorCount = 0;
let presaleWeiRaised = 0;
let tokensSold = 0;
let investors = [];
let investorsAmount = {};

function buyAndCheckisTokensSold(from, value, expectedAmountOfTokens) {
    return crowdsale.sendTransaction({from: from, value: value})
    .then(function (result) {
        if (investors.indexOf(from) == -1) {
            investors.push(from);
            investorCount++;
            investorsAmount[from] = 0;
        }
        investorsAmount[from] += value.toNumber();
        assert.ok(checkIsEventTriggered(result, "Invested", 'Event Invested has not triggered'));
        return crowdsale.investorCount()
    })
    .then(function (investors) {
        assert.equal(investors.toNumber(), investorCount, 'Investors count is invalid');
        return crowdsale.investedAmountOf(from)
    })
    .then(function (amount) {
        assert.equal(amount.toNumber(), investorsAmount[from], 'Invested amount is invalid');
        return crowdsale.tokenAmountOf(from)
    })
    .then(function (tokensAmount) {
        assert.equal(tokensAmount.toNumber(), expectedAmountOfTokens, 'Purchased tokens amount is invalid');
        presaleWeiRaised += value.toNumber();
        tokensSold += value.toNumber() * 1200;
        return crowdsale.presaleWeiRaised()
    })
    .then(function (presaleWei) {
        assert.equal(presaleWei.toNumber(), presaleWeiRaised, 'Presale wei raised is invalid');
        return algory.balanceOf(from);
    })
    .then(function (balance) {
        assert.equal(balance.toNumber(), expectedAmountOfTokens, 'Balance of participant is invalid');
        return crowdsale.weiRaised()
    })
    .then(function (weiRaised) {
        assert.equal(weiRaised.toNumber(), presaleWeiRaised, 'Total wei raised is invalid');
        return crowdsale.tokensSold();
    })
    .then(function (tokens) {
        assert.equal(tokens.toNumber(), tokensSold, 'Tokens sold is invalid');
        return crowdsale.getTokensLeft();
    })
    .then(function (tokens) {
        assert.equal(tokens.toNumber(), totalSupply - tokensSold, 'Tokens left is invalid');
    })
}

function addToWhitelist(participant, valueParticipant) {
    return crowdsale.setEarlyParticipantWhitelist(participant, valueParticipant)
        .then(function (result) {
            assert.ok(checkIsEventTriggered(result, "Whitelisted", 'Event Whitelisted has not triggered'));
            return crowdsale.earlyParticipantWhitelist(participant).then(function (value) {
                assert.equal(value.toNumber(), valueParticipant.toNumber(), 'Participant value is invalid for account '+participant);
            })
        });
}

contract('Test Algory Crowdsale Prefunding State', function(accounts) {
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
            .then(function () {return algory.approve(crowdsale.address, totalSupply)})

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
    it("should replace pricing strategy to another only in halted state", function () {
        let error;
        let newPricingStrategy;
        return crowdsale.halt()
            .then(function () {
                return pricingStrategyContract.new()
            })
            .then(function (instance) {
                newPricingStrategy = instance;
                return crowdsale.setPricingStrategy(newPricingStrategy.address).then(function () {
                    return crowdsale.pricingStrategy().then(function (address) {
                        assert.equal(address, newPricingStrategy.address, 'New Pricing strategy is not set')
                    })
                })
            })
            .then(function () {
                return crowdsale.unhalt()
            })
            .then(function () {
                return pricingStrategyContract.new()
            })
            .then(function (instance) {
                return crowdsale.setPricingStrategy(instance.address).catch(function (err) {
                    error = err;
                }).then(function () {
                    assert.ok(error, 'Crowdsale allow to replace pricing startegy');
                })
            })
    });
    it("shouldn't set presale date", function () {
        let presaleStartsAt = latestTime() + duration.days(1);
        let error;
        return crowdsale.setPresaleStartsAt(presaleStartsAt)
            .catch(function(err) {
                error = err;
            }).then(function () {
                assert.ok(error, 'Error has not occurred')
            });

    });
    it("should set start and end dates", function () {
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
    it("shouldn't allow to buy tokens by not whitelisted participant", function () {
        let error;
        return crowdsale.sendTransaction({from: accounts[1], value: ether(1)}).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Crowdsale allow to buy')
        });
    });
    it("shouldn't allow to finalize crowdsale in prefunding state", function () {
        let error;
        return crowdsale.finalize().catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Crowdsale allow to finalize')
        });
    });
    it("shouldn't allow to set refunding in prefunding state", function () {
        let error;
        return crowdsale.allowRefunding(true).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Crowdsale allow to refund')
        });
    });
    it("shouldn't allow to refund in prefunding state", function () {
        let error;
        return crowdsale.refund({from: accounts[8]}).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Crowdsale allow to refund')
        });
    });
    it("should allow to buy some tokens by whitelisted participants", function () {
        let participant = accounts[1];
        let valueParticipant = ether(8);
        let valueToBuy = ether(4);
        let expectedAmountOfTokens = 1200 * valueToBuy.toNumber();
        let participant2 = accounts[2];
        let valueParticipant2 = ether(77);
        let valueToBuy2 = ether(6);
        let expectedAmountOfTokens2 = 1200 * valueToBuy2.toNumber();
        let participant3 = accounts[3];
        let valueParticipant3 = ether(23);
        let valueToBuy3 = ether(3);
        let expectedAmountOfTokens3 = 1200 * valueToBuy3.toNumber();
        let participant4 = accounts[4];
        let valueParticipant4 = ether(13);
        let valueToBuy4 = ether(1);
        let expectedAmountOfTokens4 = 1200 * valueToBuy4.toNumber();
        let participant5 = accounts[5];
        let valueParticipant5 = ether(12);
        let valueToBuy5 = ether(3);
        let expectedAmountOfTokens5 = 1200 * valueToBuy5.toNumber();
        let participant6 = accounts[6];
        let valueParticipant6 = ether(7);
        let valueToBuy6 = ether(2);
        let expectedAmountOfTokens6 = 1200 * valueToBuy6.toNumber();

        //Added to whitelist
        return addToWhitelist(participant, valueParticipant)
            .then(function () {
                addToWhitelist(participant2, valueParticipant2)
            })
            .then(function () {
                addToWhitelist(participant3, valueParticipant3)
            })
            .then(function () {
                addToWhitelist(participant4, valueParticipant4)
            })
            .then(function () {
                addToWhitelist(participant5, valueParticipant5)
            })
            .then(function () {
                addToWhitelist(participant6, valueParticipant6)
            })
            //Buy some tokens in prefunding
            .then(function () {
                return buyAndCheckisTokensSold(participant, valueToBuy, expectedAmountOfTokens);
            })
            .then(function () {
                return buyAndCheckisTokensSold(participant2, valueToBuy2, expectedAmountOfTokens2);
            })
            .then(function () {
                return buyAndCheckisTokensSold(participant3, valueToBuy3, expectedAmountOfTokens3);
            })
            .then(function () {
                return buyAndCheckisTokensSold(participant4, valueToBuy4, expectedAmountOfTokens4);
            })
            .then(function () {
                return buyAndCheckisTokensSold(participant5, valueToBuy5, expectedAmountOfTokens5);
            })
            .then(function () {
                return buyAndCheckisTokensSold(participant6, valueToBuy6, expectedAmountOfTokens6);
            })
    });
    it("shouldn't allow to buy more tokens per one investor than declared in whitelist", function () {
        let participant = accounts[7];
        let valueParticipant = ether(10);
        let valueToBuy = ether(15);
        let error;
        return addToWhitelist(participant, valueParticipant)
            .then(function () {
                return crowdsale.sendTransaction({from: participant, value: valueToBuy}).catch(function (err) {
                    error = err;
                }).then(function () {
                    assert.ok(error, 'Error has not occurred')
                })
            })
    });
    it("shouldn't replace multisig wallet if investment count is grater than 5", function () {
        let anotherWallet = accounts[7];
        let error;
        return crowdsale.investorCount().then(function (investorCount) {
            assert.ok(investorCount>5);
            return crowdsale.setMultisigWallet(anotherWallet).catch(function (err) {
                error = err;
            }).then(function () {
                assert.ok(error, 'Error has not occurred')
            })
        })

    });
    it("should allow to multiple buy some tokens until whitelist participate is empty", function () {
        let participant = accounts[8];
        let valueParticipant = ether(10);
        let valueToBuy1 = ether(4);
        let valueToBuy2 = ether(2);
        let valueToBuy3 = ether(2);
        let valueToBuy4 = ether(2);

        let expectedAmountOfTokens1 = 1200 * valueToBuy1.toNumber();
        let expectedAmountOfTokens2 = 1200 * valueToBuy2.toNumber() + expectedAmountOfTokens1;
        let expectedAmountOfTokens3 = 1200 * valueToBuy3.toNumber() + expectedAmountOfTokens2;
        let expectedAmountOfTokens4 = 1200 * valueToBuy4.toNumber() + expectedAmountOfTokens3;

        //not allowed to buy
        let valueToBuy5 = ether(3);
        let error;

        return addToWhitelist(participant, valueParticipant)
            .then(function () {
                return buyAndCheckisTokensSold(participant, valueToBuy1, expectedAmountOfTokens1);
            })
            .then(function () {
                return buyAndCheckisTokensSold(participant, valueToBuy2, expectedAmountOfTokens2);
            })
            .then(function () {
                return buyAndCheckisTokensSold(participant, valueToBuy3, expectedAmountOfTokens3);
            })
            .then(function () {
                return buyAndCheckisTokensSold(participant, valueToBuy4, expectedAmountOfTokens4);
            })
            .then(function () {

                return crowdsale.sendTransaction({from: participant, value: valueToBuy5}).catch(function (err) {
                    error = err;
                }).then(function () {
                    assert.ok(error, 'Error has not occurred')
                })
            })
    });
});
