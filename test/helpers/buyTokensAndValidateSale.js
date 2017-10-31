import isEventTriggered from './isEventTriggered';

const BigNumber = web3.BigNumber;
require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(BigNumber))
    .should();

export default async function buyTokensAndValidateSale(crowdsale, algory, from, value, expectedAmountOfTokens) {
    let initWeiRaised = await crowdsale.weiRaised();
    let initPresaleWeiRaised = await crowdsale.presaleWeiRaised();
    let initInvestorsAmount = await crowdsale.investedAmountOf(from);
    let initInvestorsTokens = await algory.balanceOf(from);
    let initTokensSold = await crowdsale.tokensSold();
    let initTokensLeft = await crowdsale.getTokensLeft();
    let initInvestorCount = await crowdsale.investorCount();
    let state = await crowdsale.getState();

    let expectedInvestorsAmount = initInvestorsAmount.plus(value);
    let expectedInvestorsTokens = initInvestorsTokens.plus(expectedAmountOfTokens);
    let expectedPresaleWeiRaised = state.equals(2) ? initPresaleWeiRaised.plus(value) : new BigNumber(0);
    let expectedWeiRaised = initWeiRaised.plus(value);
    let expectedTokensSold = initTokensSold.plus(expectedAmountOfTokens);
    let expectedTokensLeft = initTokensLeft.minus(expectedAmountOfTokens);
    let expectedInvestorCount = initInvestorsAmount.equals(0) ? initInvestorCount.plus(1) : initInvestorCount;

    let result = await crowdsale.sendTransaction({from: from, value: value});
    assert.ok(isEventTriggered(result.logs, 'Invested'));
    //Gas limit should be 200 000
    result.receipt.cumulativeGasUsed.should.be.bignumber.below(250000);
    result.receipt.gasUsed.should.be.bignumber.below(250000);

    let currentInvestorsCount = await crowdsale.investorCount();
    currentInvestorsCount.should.be.bignumber.equal(expectedInvestorCount);

    let currentInvestedAmountOf = await crowdsale.investedAmountOf(from);
    currentInvestedAmountOf.should.be.bignumber.equal(expectedInvestorsAmount);

    let currentTokenAmountOf = await crowdsale.tokenAmountOf(from);
    currentTokenAmountOf.should.be.bignumber.equal(expectedInvestorsTokens);

    let currentPresaleWeiRaised = await crowdsale.presaleWeiRaised();
    currentPresaleWeiRaised.should.be.bignumber.equal(expectedPresaleWeiRaised);

    let currentWeiRaised = await crowdsale.weiRaised();
    currentWeiRaised.should.be.bignumber.equal(expectedWeiRaised);

    let currentBalanceOf = await algory.balanceOf(from);
    currentBalanceOf.should.be.bignumber.equal(expectedInvestorsTokens);

    let currentTokensSold = await crowdsale.tokensSold();
    currentTokensSold.should.be.bignumber.equal(expectedTokensSold);

    let currentTokensLeft = await crowdsale.getTokensLeft();
    currentTokensLeft.should.be.bignumber.equal(expectedTokensLeft);
}
