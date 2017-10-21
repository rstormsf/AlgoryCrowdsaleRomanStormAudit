
let crowdsaleContract = artifacts.require('./crowdsale/AlgoryCrowdsale.sol');
let tokenContract = artifacts.require('./token/AlgoryToken.sol');
let pricingStrategyContract = artifacts.require('./crowdsale/AlgoryPricingStrategy.sol');
let multisigWalletContract = artifacts.require('./wallet/MultisigWallet.sol');
let finalizeAgentContract = artifacts.require('./crowdsale/AlgoryFinalizeAgent.sol');

contract('Test Algory Crowdsale Initializing', function(accounts) {
    let crowdsale, algory, multisigWallet, pricingStrategy, finalizeAgent;
    let beneficiary = accounts[0];
    it("prepare suite by assign deployed contracts", function () {
        return crowdsaleContract.deployed()
            .then(function(instance) {crowdsale = instance})
            .then(function() {return tokenContract.deployed()}).then(function (instance) { algory = instance})
            .then(function() {return multisigWalletContract.deployed()}).then(function (instance) { multisigWallet = instance})
            .then(function() {return pricingStrategyContract.deployed()}).then(function (instance) { pricingStrategy = instance})
            .then(function() {return finalizeAgentContract.deployed()}).then(function (instance) { finalizeAgent = instance; return 1;})
    });
    it("should set expected owner, token, beneficiary, pricing strategy, multisig wallet, presale start, crowdsale start, crowdsale end", function() {
        let owner, tokenAddress, beneficiaryAddress, pricingStrategyAddress, multisigWalletAddress, presaleStart, start, end;

        return crowdsale.owner.call().then(function(address) {owner = address})
            .then(function() {return crowdsale.token.call()}).then(function(address) {tokenAddress = address})
            .then(function() {return crowdsale.beneficiary.call()}).then(function(address) {beneficiaryAddress = address})
            .then(function() {return crowdsale.pricingStrategy.call()}).then(function(address) {pricingStrategyAddress = address})
            .then(function() {return crowdsale.multisigWallet.call()}).then(function(address) {multisigWalletAddress = address})
            .then(function() {return crowdsale.presaleStartsAt.call()}).then(function(timestamp) {presaleStart = timestamp})
            .then(function() {return crowdsale.startsAt.call()}).then(function(timestamp) {start = timestamp})
            .then(function() {return crowdsale.endsAt.call()}).then(function(timestamp) {end = timestamp})

            .then(function () {
                assert.equal(owner.valueOf(), accounts[0], "Owner is not " +accounts[0]);
                assert.equal(tokenAddress, algory.address, 'Token does not equal proper address');
                assert.equal(beneficiaryAddress, beneficiary, 'Beneficiary does not equal proper address');
                assert.equal(pricingStrategyAddress, pricingStrategy.address, 'Pricing Strategy does not equal proper address');
                assert.equal(multisigWalletAddress, multisigWallet.address, 'Multisig Wallet does not equal proper address');
                assert.ok(presaleStart.valueOf(), 'Presale start is null');
                assert.ok(start.valueOf(), 'Start is null');
                assert.ok(end.valueOf(), 'End is null');
                assert.ok(start.valueOf() < end.valueOf(), 'End is not greater than Start');
                assert.ok(presaleStart.valueOf() < start.valueOf(), 'Start is not greater than Presale Start');
            });
    });
    it("should check is crowdsale", function () {
        return crowdsale.isCrowdsale()
            .then(function (isCrowdsale) {
                assert.ok(isCrowdsale, 'Contract is not crowdsale');
            });
    });
    it("shouldn't allow refunding", function () {
        return crowdsale.allowRefund()
            .then(function (allow) {
                assert.ok(!allow, 'Contract allow to refund');
            });
    });
    it("shouldn't be finalized", function () {
        return crowdsale.finalized()
            .then(function (finalized) {
                assert.ok(!finalized, 'Contract is finalized');
            });
    });
    it("shouldn't be full", function () {
        return crowdsale.isCrowdsaleFull()
            .then(function (full) {
                assert.ok(!full, 'Contract is full');
            });
    });
    it("should has all token to sell", function () {
        let tokensLeft = 0;
        return crowdsale.getTokensLeft()
            .then(function (tokens) {
                tokensLeft = tokens;
            })
            .then(function () {
                return algory.totalSupply();
            }).then(function (total) {
                assert.equal(tokensLeft.toNumber(), total.toNumber(), 'Tokens left not equal total supply');
            });
    });
});
