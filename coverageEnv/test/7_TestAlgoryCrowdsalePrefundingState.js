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

const devsAddress = '0x58FC33aC6c7001925B4E9595b13B48bA73690a39';
const devsTokens = bigNumber(6450000 * 10**18);
const companyAddress = '0x78534714b6b02996990cd567ebebd24e1f3dfe99';
const companyTokens = bigNumber(6400000 * 10**18);
const bountyAddress = '0xd64a60de8A023CE8639c66dAe6dd5f536726041E';
const bountyTokens = bigNumber(2400000 * 10**18);
const totalSupply = bigNumber(120000000 * 10**18);
const preallocatedTokens = devsTokens.plus(companyTokens).plus(bountyTokens);

let crowdsale, pricingStrategy, finalizeAgent, algory;

let investorCount = 0;
let presaleWeiRaised = 0;
let tokensSold = bigNumber(0);
let investors = [];
let investorsAmount = {};

let beneficiary;

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
        tokensSold = tokensSold.plus(value.times(1200));
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
        assert.deepEqual(tokens, tokensSold, 'Tokens sold is invalid');
        return crowdsale.getTokensLeft()
    })
    .then(function (tokens) {
        let tokensLeft = totalSupply.minus(preallocatedTokens).minus(tokensSold);
        assert.equal(tokens.toNumber(), tokensLeft.toNumber(), 'Tokens left is invalid');
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
    beneficiary = accounts[0];
    const multisigWallet = accounts[accounts.length-1];
    it("prepare suite by deploy contracts and set dates to make prefunding state", function () {
        let presaleStartsAt = latestTime() + duration.minutes(10);
        const startsAt = presaleStartsAt + duration.days(10);
        const endsAt = startsAt + duration.days(10);
        return tokenContract.new(totalSupply)
            .then(function (instance) {algory = instance})
            .then(function () {return pricingStrategyContract.new()}).then(function (instance) {pricingStrategy = instance})
            .then(function () {return crowdsaleContract.new(algory.address, beneficiary, pricingStrategy.address, multisigWallet, presaleStartsAt, startsAt, endsAt)})
            .then(function(instance) {crowdsale = instance})
            .then(function() {return finalizeAgentContract.new(algory.address, crowdsale.address)}).then(function (instance) { finalizeAgent = instance})
            .then(function () {return algory.setReleaseAgent(finalizeAgent.address)})
            .then(function () {return crowdsale.setFinalizeAgent(finalizeAgent.address)})
            .then(function () {return algory.setTransferAgent(beneficiary, true)})
            .then(function () {return algory.approve(crowdsale.address, totalSupply)})
            .then(function () {return crowdsale.prepareCrowdsale()})

            .then(function() {return crowdsale.setPresaleStartsAt(latestTime())})
    });
    it("should in prefunding state", function () {
        return crowdsale.getState()
            .then(function (state) {
                assert.equal(state.toNumber(), 2, 'Crowdsale state is not in prefunding state');
            })
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
                return addToWhitelist(participant2, valueParticipant2)
            })
            .then(function () {
                return addToWhitelist(participant3, valueParticipant3)
            })
            .then(function () {
                return addToWhitelist(participant4, valueParticipant4)
            })
            .then(function () {
                return addToWhitelist(participant5, valueParticipant5)
            })
            .then(function () {
                return addToWhitelist(participant6, valueParticipant6)
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
