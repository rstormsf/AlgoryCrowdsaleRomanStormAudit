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

contract('Test Algory Crowdsale Failure State', function(accounts) {
    it("prepare suite by deploy contracts and set failure state", function () {
        beneficiary = accounts[0];
        multisigWallet = accounts[accounts.length-1];

        const now = latestTime();

        const presaleStartsAt = now + duration.hours(1);
        const startsAt = now + duration.hours(1);
        const endsAt = startsAt + duration.hours(10);

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
            //
            .then(function() {return algoryCrowdsale.setPresaleStartsAt(now - duration.days(3))})
            .then(function() {return algoryCrowdsale.setStartsAt(now - duration.hours(1))})
            .then(function () {return buyAllTokensInTranche(0, accounts)})
            .then(function () {return buyAllTokensInTranche(1, accounts)})
            .then(function() {return algoryCrowdsale.setEndsAt(now)})
            .then(function() {return algoryCrowdsale.allowRefunding(true)})
    });
    it("should be in failure state", function () {
        return algoryCrowdsale.getState()
            .then(function (state) {
                assert.equal(state.toNumber(), 5, 'Crowdsale state is not in failure state');
            })
    });
    it("shouldn't allow to buy tokens by anyone in success sate", function () {
        let error;
        return algoryCrowdsale.sendTransaction({from: accounts[1], value: ether(1)}).catch(function (err) {
            error = err;
        }).then(function () {
            assert.ok(error, 'Crowdsale allow to buy')
        });
    });
    it("shouldn't allow to transfer tokens by anyone in failure sate", function () {
        let error;
        let tokensToTransfer = bigNumber(200);
        return algoryToken.balanceOf(accounts[15]).then(function (balance) {
            initBalance = balance;
            assert.ok(balance.greaterThanOrEqualTo(tokensToTransfer), 'Sender has not enough ALG')
        })
            .then(function () {
                return algoryToken.transfer(accounts[14], 200, {from: accounts[15]})
            }).catch(function (err) {
                error = err;
            }).then(function () {
                assert.ok(error, 'Error has not occurred');
            })
    });
});
