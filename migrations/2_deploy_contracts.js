let multiSigWallet = artifacts.require('./wallet/MultiSigWallet.sol');
let token = artifacts.require('./token/AlgoryToken.sol');
let pricingStrategy = artifacts.require('./crowdsale/AlgoryPricingStrategy.sol');
let crowdsale = artifacts.require('./crowdsale/AlgoryCrowdsale.sol');
let finalizeAgent = artifacts.require('./crowdsale/AlgoryFinalizeAgent.sol');
let safeMath = artifacts.require('./math/SafeMath.sol');

// const Pudding = require('ether-pudding');

function latestTime() {
    return web3.eth.getBlock('latest').timestamp;
}

const duration = {
    seconds: function(val) { return val},
    minutes: function(val) { return val * this.seconds(60) },
    hours:   function(val) { return val * this.minutes(60) },
    days:    function(val) { return val * this.hours(24) },
    weeks:   function(val) { return val * this.days(7) },
    years:   function(val) { return val * this.days(365)}
};

module.exports = function(deployer, network, accounts) {

    // MultiSigWallet
    const requiredConfirmations = 1;

    // Token
    let algory;

    // Crowdsale
    let algoryCrowdsale;
    const beneficiary = accounts[0];
    // const beneficiary = "0x1e418971a85de4cd13fb3f4c57230de4fa776653";

    const presaleStart = latestTime() + duration.seconds(10);
    const start = presaleStart + duration.minutes(10);
    const end = start + duration.hours(1);

    // Deploy MultiSigWallet
    return deployer.deploy(multiSigWallet, [accounts[0], accounts[1], accounts[2]], requiredConfirmations)
    //Deploy SafeMathLib
    .then(function() {
        return deployer.deploy(safeMath)
    })
    //Link SafeMathLib
    .then(function() {
        return deployer.link(safeMath, [crowdsale, pricingStrategy, token]);
    })
    // Deploy Token
    .then(function() {
        return deployer.deploy(token);
    })
    // Deploy Pricing Strategy
    .then(function() {
        return deployer.deploy(pricingStrategy);
    })
    // Deploy Crowdsale
    .then(function() {
        return deployer.deploy(
            crowdsale,
            token.address,
            beneficiary,
            pricingStrategy.address,
            multiSigWallet.address,
            presaleStart,
            start,
            end
        );
    })
    //Deploy Finalize Agent
    .then(function() {
        algoryCrowdsale = crowdsale.at(crowdsale.address);
        return deployer.deploy(finalizeAgent, token.address, crowdsale.address);
    })
    .then(function() {
        algory = token.at(token.address);
        console.log("\n\n\t----------------------- DEPLOYED CONTRACTS -----------------------\n\n");

        console.log("\tBeneficiary address: " + beneficiary);
        console.log("\tMultisig Wallet address: " + multiSigWallet.address);
        console.log("\tCrowdsale address: " + crowdsale.address);
        console.log("\tAlgory Token address: " + algory.address);
        console.log("\tPricing Strategy address: " + pricingStrategy.address);
        console.log("\tFinalize Agent address: " + finalizeAgent.address + "\n");
        // console.log("\tCrowdsale constructor parameters: "
        //     + '"'+algory.address+'",'
        //     + '"'+beneficiary+'",'
        //     + '"'+pricingStrategy.address+'",'
        //     + '"'+multiSigWallet.address+'",'
        //     + +presaleStart+','
        //     + +start+','
        //     + +end+''
        //     + "\n\n"
        // );
    })
    //Set Finalize Agent to Crowdsale
    // .then(function () {
    //     return algoryCrowdsale.setFinalizeAgent(finalizeAgent.address);
    // })
    // .then(function () {
    //     return algoryCrowdsale.finalizeAgent();
    // })
    // .then(function (address) {
    //     if (address == finalizeAgent.address) {
    //         console.log("\tFinalize Agent has been set at: "+address)
    //     } else {
    //         console.log("\tAn error has occurred")
    //     }
    // })
    // //Set Finalize Agent as ReleaseAgent in Token
    // .then(function () {
    //     algory.setReleaseAgent(finalizeAgent.address).then(function () {
    //         console.log("\tFinalize Agent has been set as AlgoryToken ReleaseAgent")
    //     });
    // });
};

