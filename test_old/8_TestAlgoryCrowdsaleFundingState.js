let crowdsaleContract = artifacts.require('./algoryCrowdsale/AlgoryCrowdsale.sol');
let finalizeAgentContract = artifacts.require('./algoryCrowdsale/AlgoryFinalizeAgent.sol');
let pricingStrategyContract = artifacts.require('./algoryCrowdsale/AlgoryPricingStrategy.sol');
let tokenContract = artifacts.require('./token/AlgoryToken.sol');

const duration = {
    seconds: function(val) { return val},
    minutes: function(val) { return val * this.seconds(60) },
    hours:   function(val) { return val * this.minutes(60) },
    days:    function(val) { return val * this.hours(24) },
    weeks:   function(val) { return val * this.days(7) },
    years:   function(val) { return val * this.days(365)}
};

let beneficiary;
let multisigWallet;

const totalSupply = bigNumber(120000000 * 10**18);
const devsTokens = bigNumber(6450000 * 10**18);
const companyTokens = bigNumber(6400000 * 10**18);
const bountyTokens = bigNumber(2400000 * 10**18);
const preallocatedTokens = devsTokens.plus(companyTokens).plus(bountyTokens);
const tranches = [
    {amount: 0, rate: bigNumber(1200)},
    {amount: ether(10000), rate: bigNumber(1100)},
    {amount: ether(25000), rate: bigNumber(1050)},
    {amount: ether(50000), rate: bigNumber(1000)},
];
let algoryCrowdsale = null;
let algoryFinalizeAgent = null;
let algoryToken = null;
let algoryPricingStrategy = null;

let investorCount = 0;
let weiRaised = bigNumber(0);
let tokensSold = bigNumber(0);
let investors = [];
let investorsAmount = {};
let investorsTokens = {};
let multisigInitialBalance = bigNumber(0);

function getCurrentRate(amount) {
    for(let i=1; i < tranches.length; i++) {
        if(amount.lessThanOrEqualTo(tranches[i].amount)) {
            return tranches[i-1].rate;
        }
    }
    return tranches[tranches.length-1].rate;
}

function latestTime() {
    return web3.eth.getBlock('latest').timestamp;
}

function ether(n) {
    return new web3.BigNumber(web3.toWei(n, 'ether'))
}

function bigNumber(n) {
    return new web3.BigNumber(n)
}

function getBalance(address) {
    return web3.eth.getBalance(address);
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

function buyAndCheckIsTokensSold(from, value) {
    if (investors.indexOf(from) == -1) {
        investors.push(from);
        investorCount++;
        investorsAmount[from] = bigNumber(0);
        investorsTokens[from] = bigNumber(0);
    }
    investorsAmount[from] = investorsAmount[from].plus(value);
    investorsTokens[from] = investorsTokens[from].plus(value.times(getCurrentRate(weiRaised)));
    tokensSold = tokensSold.plus(value.times(getCurrentRate(weiRaised)));
    weiRaised = weiRaised.plus(value);
    return algoryCrowdsale.sendTransaction({from: from, value: value})
    .then(function (result) {
        assert.ok(checkIsEventTriggered(result, "Invested", 'Event Invested has not triggered'));
        return algoryCrowdsale.investorCount()
    })
    .then(function (investors) {
        assert.equal(investors.toNumber(), investorCount, 'Investors count is invalid');
        return algoryCrowdsale.investedAmountOf(from)
    })
    .then(function (amount) {
        assert.deepEqual(amount, investorsAmount[from], 'Invested amount is invalid');
        return algoryCrowdsale.tokenAmountOf(from)
    })
    .then(function (tokensAmount) {
        assert.deepEqual(tokensAmount, investorsTokens[from], 'Purchased tokens amount is invalid for value '+value);
        return algoryToken.balanceOf(from);
    })
    .then(function (balance) {
        assert.deepEqual(balance, investorsTokens[from], 'Balance of investor is invalid');
        return algoryCrowdsale.weiRaised()
    })
    .then(function (wei) {
        assert.deepEqual(wei, weiRaised, 'Total wei raised is invalid');
        return algoryCrowdsale.tokensSold();
    })
    .then(function (tokens) {
        assert.deepEqual(tokens, tokensSold, 'Tokens sold is invalid');
        return algoryCrowdsale.getTokensLeft();
    })
    .then(function (tokens) {
        assert.deepEqual(tokens, totalSupply.minus(tokensSold).minus(preallocatedTokens), 'Tokens left is invalid');
        return algoryCrowdsale.multisigWallet().then(function (address) {
            assert.equal(address, multisigWallet, 'Multisig wallet has invalid address');
        })
    })
    .then(function () {
        return getBalance(multisigWallet);
    })
    .then(function (balance) {
        assert.deepEqual(balance, weiRaised.plus(multisigInitialBalance), 'Multisig wallet '+multisigWallet+' has no proper balance');
    })

}

function buyAllTokensInTranche(n, accounts) {
    let currentWeiRaised = bigNumber(0);
    let currentRate = bigNumber(0);
    let lastValueToBuyInTranche = ether(1);
    let expectedTokensSoldByTranche = lastValueToBuyInTranche.times(tranches[n].rate);
    //fill N tranche
    let valueToBuy = bigNumber(0);
    return algoryCrowdsale.weiRaised().then(function (wei) {
        currentWeiRaised = wei;
        return algoryCrowdsale.getTokensLeft().then(function (tokens) {
            if (n == tranches.length-1) {
                valueToBuy = tokens.dividedBy(10).dividedBy(tranches[n].rate);
            } else {
                valueToBuy = (tranches[n+1].amount.minus(currentWeiRaised)).dividedBy(10);
            }
        });
    })
    .then(function () {
        return algoryPricingStrategy.getCurrentRate(currentWeiRaised).then(function (rate) {
            currentRate = rate;
            //check if is in N tranche
            assert.deepEqual(currentRate, tranches[n].rate, 'Current rate is not in '+(n+1)+' tranche');
        })
    })
    .then(function () {
        return buyAndCheckIsTokensSold(accounts[10], valueToBuy)
    })
    .then(function () {
        return buyAndCheckIsTokensSold(accounts[11], valueToBuy)
    })
    .then(function () {
        return buyAndCheckIsTokensSold(accounts[12], valueToBuy)
    })
    .then(function () {
        return buyAndCheckIsTokensSold(accounts[13], valueToBuy)
    })
    .then(function () {
        return buyAndCheckIsTokensSold(accounts[14], valueToBuy)
    })
    .then(function () {
        return buyAndCheckIsTokensSold(accounts[15], valueToBuy)
    })
    .then(function () {
        return buyAndCheckIsTokensSold(accounts[16], valueToBuy)
    })
    .then(function () {
        return buyAndCheckIsTokensSold(accounts[17], valueToBuy)
    })
    .then(function () {
        return buyAndCheckIsTokensSold(accounts[18], valueToBuy)
    })
    .then(function () {
        return buyAndCheckIsTokensSold(accounts[19], valueToBuy)
    })
    .then(function () {
        return algoryCrowdsale.weiRaised().then(function (wei) {
            currentWeiRaised = wei;
        });
    })
    .then(function () {
        return algoryPricingStrategy.getCurrentRate(currentWeiRaised).then(function (rate) {
            currentRate = rate;
        })
    })
    .then(function () {
        let amount = (n == tranches.length-1) ? weiRaised : tranches[n+1].amount;
        assert.deepEqual(currentWeiRaised, amount, 'Wei raised is not equal amount of '+(n+1)+' tranche');
        //N tranche is filled and rate should be still in N tranche
        assert.deepEqual(currentRate, tranches[n].rate, 'Current rate is not in '+(n+1)+' tranche');
        //last part in N tranche can buy for N tranche rate
        //if is last tranche all tokens should be sold
        if (n < tranches.length-1) {
            return buyAndCheckIsTokensSold(accounts[20+n], lastValueToBuyInTranche).then(function () {
                return algoryCrowdsale.tokenAmountOf(accounts[20+n]).then(function (tokens) {
                    assert.deepEqual(tokens, expectedTokensSoldByTranche, 'Tokens has sold by '+(n+2)+' rate')
                })
            })
        }
    })
}

function checkHardCap(hardCap) {
    return algoryCrowdsale.weiRaised().then(function (weiRaised) {
        assert.ok(weiRaised.greaterThan(hardCap), 'Wei is not raised to hard cap');
        // assert.deepEqual(weiRaised,hardCap, 'Wei is not raised to hard cap DEBUG');
    })
    .then(function () {
        return getBalance(multisigWallet)
    })
    .then(function (balance) {
        assert.ok(balance.minus(multisigInitialBalance).greaterThan(hardCap), 'Multisig wallet gas no hard cap');
    })
}

contract('Test Algory Crowdsale Funding State', function(accounts) {
    it("prepare suite by deploy contracts and set dates to make funding state", function () {
        const presaleStartsAt = latestTime() + duration.minutes(10);
        const startsAt = presaleStartsAt + duration.days(10);
        const endsAt = startsAt + duration.days(30);

        beneficiary = accounts[0];
        multisigWallet = accounts[accounts.length-1];

        return tokenContract.new()
            .then(function (instance) {algoryToken = instance})
            .then(function () {return pricingStrategyContract.new()}).then(function (instance) {algoryPricingStrategy = instance})
            .then(function () {return crowdsaleContract.new(algoryToken.address, beneficiary, algoryPricingStrategy.address, multisigWallet, presaleStartsAt, startsAt, endsAt)})
            .then(function(instance) {algoryCrowdsale = instance})
            .then(function() {return finalizeAgentContract.new(algoryToken.address, algoryCrowdsale.address)}).then(function (instance) { algoryFinalizeAgent = instance})
            .then(function () {return algoryToken.setReleaseAgent(algoryFinalizeAgent.address)})
            .then(function () {return algoryCrowdsale.setFinalizeAgent(algoryFinalizeAgent.address)})
            .then(function () {return algoryToken.setTransferAgent(beneficiary, true)})
            .then(function () {return algoryToken.approve(algoryCrowdsale.address, totalSupply)})
            .then(function () {return algoryCrowdsale.prepareCrowdsale()})

            .then(function() {return algoryCrowdsale.setPresaleStartsAt(latestTime() - duration.days(3))})
            .then(function() {return algoryCrowdsale.setStartsAt(latestTime())})

            //get current multisig balance
            .then(function() {return getBalance(multisigWallet)}).then(function (balance) { multisigInitialBalance = balance})
    });
    it("should in funding state", function () {
        return algoryCrowdsale.getState()
            .then(function (state) {
                assert.equal(state.toNumber(), 3, 'Crowdsale state is not in funding state');
            })
    });
    it("should replace multisig wallet if investment count is less than 6", function () {
        let anotherWallet = accounts[7];
        return algoryCrowdsale.setMultisigWallet(anotherWallet)
            .then(function () {
                return algoryCrowdsale.multisigWallet()
            })
            .then(function (wallet) {
                assert.equal(wallet, anotherWallet, 'Another Multisig Wallet has not replaced');
            })
            .then(function () {
                return algoryCrowdsale.setMultisigWallet(multisigWallet)
            })
            .then(function () {
                return algoryCrowdsale.multisigWallet()
            })
            .then(function (wallet) {
                assert.equal(wallet, multisigWallet, 'Proper Multisig Wallet has not replaced');
            });
    });
    it("should replace pricing strategy to another only in paused state", function () {
        let error;
        let newPricingStrategy;
        return algoryCrowdsale.pause()
            .then(function () {
                return pricingStrategyContract.new()
            })
            .then(function (instance) {
                newPricingStrategy = instance;
                return algoryCrowdsale.setPricingStrategy(newPricingStrategy.address).then(function () {
                    return algoryCrowdsale.pricingStrategy().then(function (address) {
                        assert.equal(address, newPricingStrategy.address, 'New Pricing strategy is not set')
                    })
                })
            })
            .then(function () {
                return algoryCrowdsale.unpause()
            })
            .then(function () {
                return pricingStrategyContract.new()
            })
            .then(function (instance) {
                return algoryCrowdsale.setPricingStrategy(instance.address).catch(function (err) {
                    error = err;
                }).then(function () {
                    assert.ok(error, 'Crowdsale allow to replace pricing startegy');
                })
            })
    });
    it("shouldn't set start date", function () {
        let startsAt = latestTime() + duration.days(1);
        let error;
        return algoryCrowdsale.setStartsAt(startsAt)
            .catch(function(err) {
                error = err;
            }).then(function () {
                assert.ok(error, 'Error has not occurred')
            });
    });
    it("should set end dates", function () {
        let endsAt = latestTime() + duration.days(77);
        let resultForEnd;
        return algoryCrowdsale.setEndsAt(endsAt)
            .then(function (result) {
                resultForEnd = result;
            })
            .then(function () {
                assert.ok(checkIsEventTriggered(resultForEnd, "TimeBoundaryChanged"), 'Event TimeBoundaryChanged for endsAt has not triggered');
            })
            .then(function () {
                return algoryCrowdsale.endsAt()
            })
            .then(function (timestamp) {
                assert.equal(timestamp, endsAt, 'EndsAt has not replaced');
            });
    });
    it("shouldn't allow to finalize algoryCrowdsale in funding state", function () {
        let error;
        return algoryCrowdsale.finalize().catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Crowdsale allow to finalize')
        });
    });
    it("shouldn't allow to set refunding in funding state", function () {
        let error;
        return algoryCrowdsale.allowRefunding(true).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Crowdsale allow to refund')
        });
    });
    it("shouldn't allow to refund in prefunding state", function () {
        let error;
        return algoryCrowdsale.refund({from: accounts[8]}).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Crowdsale allow to refund')
        });
    });
    it("should allow to buy some tokens by everyone", function () {
        let participant = accounts[1];
        let valueToBuy = ether(4);
        let participant2 = accounts[2];
        let valueToBuy2 = ether(6);
        let participant3 = accounts[3];
        let valueToBuy3 = ether(3);
        let participant4 = accounts[4];
        let valueToBuy4 = ether(1);
        let participant5 = accounts[5];
        let valueToBuy5 = ether(3);
        let participant6 = accounts[6];
        let valueToBuy6 = ether(2);

        return buyAndCheckIsTokensSold(participant, valueToBuy)
            .then(function () {
                return buyAndCheckIsTokensSold(participant2, valueToBuy2);
            })
            .then(function () {
                return buyAndCheckIsTokensSold(participant3, valueToBuy3);
            })
            .then(function () {
                return buyAndCheckIsTokensSold(participant4, valueToBuy4);
            })
            .then(function () {
                return buyAndCheckIsTokensSold(participant5, valueToBuy5);
            })
            .then(function () {
                return buyAndCheckIsTokensSold(participant6, valueToBuy6);
            })
    });
    it("shouldn't replace multisig wallet if investment count is grater than 5", function () {
        let anotherWallet = accounts[7];
        let error;
        return algoryCrowdsale.investorCount().then(function (investorCount) {
            assert.ok(investorCount>5);
            return algoryCrowdsale.setMultisigWallet(anotherWallet).catch(function (err) {
                error = err;
            }).then(function () {
                assert.ok(error, 'Error has not occurred')
            })
        })

    });
    it("should buy all tokens in I tranche", function () {
        return buyAllTokensInTranche(0, accounts);
    });
    it("should reached in multisig wallet hard cap = 10 000 ETH after I tranche", function () {
        return checkHardCap(ether(10000));
    });
    it("shouldn't has in multisig wallet more than 10 000 ETH after I tranche", function () {
        let error;
        return checkHardCap(ether(10001)).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Error has not occurred');
        });
    });
    it("shouldn't buy tokens for I tranche rate after limit exceed", function () {
        let valueToBuy = ether(20);
        let notExpectedValueOfTokens = valueToBuy.times(tranches[0].rate);
        let expectedValueOfTokens =  valueToBuy.times(tranches[1].rate);
        return buyAndCheckIsTokensSold(accounts[25], valueToBuy)
            .then(function () {
                return algoryCrowdsale.tokenAmountOf(accounts[25]).then(function (tokens) {
                    assert.deepEqual(tokens, expectedValueOfTokens, 'Tokens has not sold by II rate');
                    assert.notDeepEqual(tokens, notExpectedValueOfTokens, 'Tokens has sold by I rate');
                })
            })
    });
    it("should buy all tokens in II tranche", function () {
        return buyAllTokensInTranche(1, accounts);
    });
    it("should reached in multisig wallet hard cap = 25 000 ETH after II tranche", function () {
        return checkHardCap(ether(25000));
    });
    it("shouldn't has in multisig wallet more than 25 000 ETH after II tranche (+/- 1 ETH)", function () {
        let error;
        return checkHardCap(ether(25001)).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Error has not occurred');
        });
    });
    it("shouldn't buy tokens for II tranche rate after limit exceed", function () {
        let valueToBuy = ether(20);
        let notExpectedValueOfTokens = valueToBuy.times(tranches[1].rate);
        let expectedValueOfTokens =  valueToBuy.times(tranches[2].rate);
        return buyAndCheckIsTokensSold(accounts[26], valueToBuy)
            .then(function () {
                return algoryCrowdsale.tokenAmountOf(accounts[26]).then(function (tokens) {
                    assert.deepEqual(tokens, expectedValueOfTokens, 'Tokens has not sold by III rate');
                    assert.notDeepEqual(tokens, notExpectedValueOfTokens, 'Tokens has sold by II rate');
                })
            })
    });
    it("should buy all tokens in III tranche", function () {
        return buyAllTokensInTranche(2, accounts);
    });
    it("should reached in multisig wallet hard cap = 50 000 ETH after III tranche", function () {
        return checkHardCap(ether(50000));
    });
    it("shouldn't has in multisig wallet more than 50 000 ETH after III tranche (+/- 1 ETH)", function () {
        let error;
        return checkHardCap(ether(50001)).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Error has not occurred');
        });
    });
    it("shouldn't buy tokens for III tranche rate after limit exceed", function () {
        let valueToBuy = ether(20);
        let notExpectedValueOfTokens = valueToBuy.times(tranches[2].rate);
        let expectedValueOfTokens =  valueToBuy.times(tranches[3].rate);
        return buyAndCheckIsTokensSold(accounts[27], valueToBuy)
            .then(function () {
                return algoryCrowdsale.tokenAmountOf(accounts[27]).then(function (tokens) {
                    assert.deepEqual(tokens, expectedValueOfTokens, 'Tokens has not sold by IV rate');
                    assert.notDeepEqual(tokens, notExpectedValueOfTokens, 'Tokens has sold by III rate');
                })
            })
    });
    it("should buy all tokens in IV tranche", function () {
        return buyAllTokensInTranche(3, accounts);
    });
    it("shouldn't buy tokens after all has been sold", function () {
        let error;
        return algoryCrowdsale.sendTransaction({from: accounts[28], value: ether(20)}).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Error has not occurred')
        });
    });
    it("should has 0 tokens left after all has been sold", function () {
        return algoryCrowdsale.getTokensLeft().then(function (tokens) {
            assert.equal(tokens.toNumber(), 0, 'Tokens left not equal 0');
        })
    });
    it("should be in success state after all tokens sold", function () {
        return algoryCrowdsale.getState().then(function (state) {
            assert.equal(state.toNumber(), 4)
        })
    });
    it("should reached in multisig wallet hard cap = 100 000 ETH (-10 ETH) after crowdsale", function () {
        return checkHardCap(ether(100000).minus(ether(10)));
    });
    it("shouldn't has in multisig wallet more than 100 000 ETH after crowdsale", function () {
        let error;
        return checkHardCap(ether(100001)).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Error has not occurred');
        });
    });
});
