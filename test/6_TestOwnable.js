'use strict';

const Ownable = artifacts.require('./ownership/Ownable.sol');

const EVMThrow = require('./helpers/EVMThrow');

contract('Test Ownable Behavior', function(accounts) {
    let ownable;

    beforeEach(async function() {
        ownable = await Ownable.new();
    });

    it('should have an owner', async function() {
        let owner = await ownable.owner();
        assert.isTrue(owner !== 0);
    });

    it('changes owner after transfer', async function() {
        let other = accounts[1];
        await ownable.transferOwnership(other);
        let owner = await ownable.owner();

        assert.isTrue(owner === other);
    });

    it('should prevent non-owners from transfering', async function() {
        const other = accounts[2];
        const owner = await ownable.owner.call();
        assert.isTrue(owner !== other);
        await ownable.transferOwnership(other, {from: other})
            .should.be.rejectedWith(EVMThrow)
    });

    it('should guard ownership against stuck state', async function() {
        let originalOwner = await ownable.owner();
        await ownable.transferOwnership(null, {from: originalOwner})
            .should.be.rejectedWith(EVMThrow)
    });

});
