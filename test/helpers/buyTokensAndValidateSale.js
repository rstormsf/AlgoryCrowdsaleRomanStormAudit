import isEventTriggered from './isEventTriggered';
import {constants} from './constants';

const BigNumber = web3.BigNumber;
require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(BigNumber))
    .should();

let expectedInvestorCount = 0;
let expectedPresaleWeiRaised = new BigNumber(0);
let expectedTokensSold = new BigNumber(0);
let expectedTokensLeft = new BigNumber(0);
let expectedInvestors = [];
let expectedInvestorsAmount = {};
let expectedInvestorsTokens = {};

export default async function buyTokensAndValidateSale(crowdsale, algory, from, value, expectedAmountOfTokens) {
    let {logs} = await crowdsale.sendTransaction({from: from, value: value});
    assert.ok(isEventTriggered(logs, 'Invested'));

    if (expectedInvestors.indexOf(from) == -1) {
        expectedInvestors.push(from);
        expectedInvestorCount++;
        expectedInvestorsAmount[from] = new BigNumber(0);
        expectedInvestorsTokens[from] = new BigNumber(0);
    }
    expectedInvestorsAmount[from] = expectedInvestorsAmount[from].plus(value);
    expectedInvestorsTokens[from] = expectedInvestorsTokens[from].plus(expectedAmountOfTokens);
    expectedPresaleWeiRaised = expectedPresaleWeiRaised.plus(value);
    expectedTokensSold = expectedTokensSold.plus(expectedAmountOfTokens);
    expectedTokensLeft = constants.totalSupply.minus(constants.preallocatedTokens()).minus(expectedTokensSold);

    let currentInvestorsCount = await crowdsale.investorCount();
    currentInvestorsCount.should.be.bignumber.equal(expectedInvestorCount);

    let currentInvestedAmountOf = await crowdsale.investedAmountOf(from);
    currentInvestedAmountOf.should.be.bignumber.equal(expectedInvestorsAmount[from]);

    let currentTokenAmountOf = await crowdsale.tokenAmountOf(from);
    currentTokenAmountOf.should.be.bignumber.equal(expectedInvestorsTokens[from]);

    let currentPresaleWeiRaised = await crowdsale.presaleWeiRaised();
    currentPresaleWeiRaised.should.be.bignumber.equal(expectedPresaleWeiRaised);

    let currentBalanceOf = await algory.balanceOf(from);
    currentBalanceOf.should.be.bignumber.equal(expectedInvestorsTokens[from]);

    let currentCrowdsaleWeiRaised = await crowdsale.weiRaised();
    currentCrowdsaleWeiRaised.should.be.bignumber.equal(expectedPresaleWeiRaised);

    let currentTokensSold = await crowdsale.tokensSold();
    currentTokensSold.should.be.bignumber.equal(expectedTokensSold);

    let currentTokensLeft = await crowdsale.getTokensLeft();
    currentTokensLeft.should.be.bignumber.equal(expectedTokensLeft);
}
