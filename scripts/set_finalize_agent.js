
let allocatedCrowdsaleContract = artifacts.require('./crowdsale/AllocatedCrowdsale.sol');

module.exports = function() {
    let allocatedCrowdsaleAddress = '0xcf9afa9b3b76e84f61f3ed8a1d32cfec921213af';
    let finalizeAgentAddress = '0x2a9ddae54b78b3b8a0b8a6625ce50b8b6774545e';
    let crowdsale = allocatedCrowdsaleContract.at(allocatedCrowdsaleAddress);

    crowdsale.setFinalizeAgent(finalizeAgentAddress).then(function () {
        crowdsale.finalizeAgent().then(function (address) {
            if (address == finalizeAgentAddress) {
                console.log('Finalize Agent has been set at: '+address)
            } else {
                console.log('An error has occurred')
            }
        })
    });

};