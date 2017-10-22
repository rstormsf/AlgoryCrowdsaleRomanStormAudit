pragma solidity ^0.4.15;

import '../ownership/Haltable.sol';

contract InvestmentPolicyCrowdsale is Haltable {

    /* Do we need to have unique contributor id for each customer */
    bool public requireCustomerId = false;

    /**
      * Do we verify that contributor has been cleared on the server side (accredited investors only).
      * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
      */
    bool public requiredSignedAddress = false;

    /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
    address public signerAddress;

    event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);

    /**
     * Set policy if all investors must be cleared on the server side first.
     *
     * This is e.g. for the accredited investor clearing.
     *
     */
    function setRequireSignedAddress(bool value, address _signerAddress) external onlyOwner {
        requiredSignedAddress = value;
        signerAddress = _signerAddress;
        InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
    }

    /**
     * Invest to tokens, recognize the payer and clear his address.
     */
    function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) external payable {
        investWithSignedAddress(msg.sender, customerId, v, r, s);
    }

    /**
     * Invest to tokens, recognize the payer.
     *
     */
    function buyWithCustomerId(uint128 customerId) external payable {
        investWithCustomerId(msg.sender, customerId);
    }

    /**
     * Allow anonymous contributions to this crowdsale.
     */
    function invest(address addr) public payable {
        assert(!requireCustomerId); // Crowdsale needs to track participants for thank you email
        assert(!requiredSignedAddress); // Crowdsale allows only server-side signed participants
        investInternal(addr, 0);
    }

    /**
     * Allow anonymous contributions to this crowdsale.
     */
    function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
        bytes32 hash = sha256(addr);
        require(ecrecover(hash, v, r, s) == signerAddress);
        require(customerId != 0);  // UUIDv4 sanity check
        investInternal(addr, customerId);
    }

    /**
     * Track who is the customer making the payment so we can send thank you email.
     */
    function investWithCustomerId(address addr, uint128 customerId) public payable {
        // Crowdsale allows only server-side signed participants
        require(requiredSignedAddress && customerId != 0);
        investInternal(addr, customerId);
    }

    /**
     * Set policy do we need to have server-side customer ids for the investments.
     *
     */
    function setRequireCustomerId(bool value) onlyOwner external{
        requireCustomerId = value;
        InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
    }

    function investInternal(address receiver, uint128 customerId) stopInEmergency internal;
}