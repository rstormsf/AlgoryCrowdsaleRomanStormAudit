import isEventTriggered from './isEventTriggered';

export default async function addToWhitelist(crowdsale, participant, value) {
    let {logs} = await crowdsale.setEarlyParticipantWhitelist(participant, value);
    assert.ok(isEventTriggered(logs, "Whitelisted"));
    let currentEarlyParticipantWhitelistValue = await crowdsale.earlyParticipantWhitelist(participant);
    currentEarlyParticipantWhitelistValue.should.be.bignumber.equal(value);
}
