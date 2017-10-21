
let crowdsaleContract = artifacts.require('./crowdsale/AlgoryCrowdsale.sol');
let tokenContract = artifacts.require('./token/AlgoryToken.sol');

module.exports = function() {
    let crowdsaleAddress = '0xb4275db462b2cfbf0f407a382f0e36c534520b69';
    let tokenAddress = '0x1023848a15b05fb3ce1283367f3f75900db31d69';
    let finalizeAgentAddress = '0x98a4b80ceb9904b501fa9bdfea51c629eef2eb57';
    let crowdsale = crowdsaleContract.at(crowdsaleAddress);
    let token = tokenContract.at(tokenAddress);

    crowdsale.setFinalizeAgent(finalizeAgentAddress).then(function () {
        crowdsale.finalizeAgent().then(function (address) {
            if (address == finalizeAgentAddress) {
                console.log('Finalize Agent has been set at: '+address)
            } else {
                console.log('An error has occurred')
            }
        })
    })
    .then(function () {
       token.setReleaseAgent(finalizeAgentAddress).then(function () {
           console.log('Finalize Agent has been set as AlgoryToken ReleaseAgent')
       });
    });

};