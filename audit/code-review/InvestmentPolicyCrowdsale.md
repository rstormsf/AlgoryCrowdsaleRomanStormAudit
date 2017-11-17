# InvestmentPolicyCrowdsale
Source file [../../contracts/crowdsale/FinalizeAgent.sol](../../contracts/crowdsale/FinalizeAgent.sol).


<br />

<hr />

```javascript
//RS OK
pragma solidity ^0.4.15;
//RS OK
import '../lifecycle/Pausable.sol';
//RS OK
contract InvestmentPolicyCrowdsale is Pausable {

    /* Do we need to have unique contributor id for each customer */
    //RS OK
    bool public requireCustomerId = false;

    /**
      * Do we verify that contributor has been cleared on the server side (accredited investors only).
      * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
      */
    //RS OK
    bool public requiredSignedAddress = false;

    /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
    //RS OK
    address public signerAddress;
    //RS OK
    event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);

    /**
     * Set policy do we need to have server-side customer ids for the investments.
     *
     */
     //RS OK
    function setRequireCustomerId(bool value) onlyOwner external{
        //RS OK
        requireCustomerId = value;
        //RS OK
        InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
    }

    /**
     * Set policy if all investors must be cleared on the server side first.
     *
     * This is e.g. for the accredited investor clearing.
     *
     */
     //RS OK
    function setRequireSignedAddress(bool value, address _signerAddress) external onlyOwner {
        //RS OK
        requiredSignedAddress = value;
        //RS OK
        signerAddress = _signerAddress;
        //RS OK
        InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
    }

    /**
     * Invest to tokens, recognize the payer and clear his address.
     */
     //RS OK
    function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) external payable {
        //RS OK. Use require
        assert(requiredSignedAddress);
        //RS OK
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        //RS OK
        bytes32 hash = sha3(prefix, sha3(msg.sender));
        //RS OK. Use require
        assert(ecrecover(hash, v, r, s) == signerAddress);
        //RS OK
        require(customerId != 0);  // UUIDv4 sanity check
        //RS OK
        investInternal(msg.sender, customerId);
    }

    /**
     * Invest to tokens, recognize the payer.
     *
     */
     //RS OK
    function buyWithCustomerId(uint128 customerId) external payable {
        //RS OK. Use require
        assert(requireCustomerId);
        //RS OK
        require(customerId != 0);
        //RS OK
        investInternal(msg.sender, customerId);
    }

    //RS OK
    function investInternal(address receiver, uint128 customerId) whenNotPaused internal;
}
```