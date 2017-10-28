'use strict';

const PausableMock = artifacts.require('./mocks/PausableMock.sol');

const EVMThrow = require('./helpers/EVMThrow');

contract('Test Pausable Behavior', function(accounts) {

    it('can perform normal process in non-pause', async function() {
        let Pausable = await PausableMock.new();
        let count0 = await Pausable.count();
        assert.equal(count0, 0);

        await Pausable.normalProcess();
        let count1 = await Pausable.count();
        assert.equal(count1, 1);
    });

    it('can not perform normal process in pause', async function() {
        let Pausable = await PausableMock.new();
        await Pausable.pause();
        let count0 = await Pausable.count();
        assert.equal(count0, 0);

        await Pausable.normalProcess()
            .should.be.rejectedWith(EVMThrow)
        let count1 = await Pausable.count();
        assert.equal(count1, 0);
    });


    it('can not take drastic measure in non-pause', async function() {
        let Pausable = await PausableMock.new();
        await Pausable.drasticMeasure()
            .should.be.rejectedWith(EVMThrow)
        const drasticMeasureTaken = await Pausable.drasticMeasureTaken();
        assert.isFalse(drasticMeasureTaken);
    });

    it('can take a drastic measure in a pause', async function() {
        let Pausable = await PausableMock.new();
        await Pausable.pause();
        await Pausable.drasticMeasure();
        let drasticMeasureTaken = await Pausable.drasticMeasureTaken();

        assert.isTrue(drasticMeasureTaken);
    });

    it('should resume allowing normal process after pause is over', async function() {
        let Pausable = await PausableMock.new();
        await Pausable.pause();
        await Pausable.unpause();
        await Pausable.normalProcess();
        let count0 = await Pausable.count();

        assert.equal(count0, 1);
    });

    it('should prevent drastic measure after pause is over', async function() {
        let Pausable = await PausableMock.new();
        await Pausable.pause();
        await Pausable.unpause();
        await Pausable.drasticMeasure()
            .should.be.rejectedWith(EVMThrow)

        const drasticMeasureTaken = await Pausable.drasticMeasureTaken();
        assert.isFalse(drasticMeasureTaken);
    });

});
