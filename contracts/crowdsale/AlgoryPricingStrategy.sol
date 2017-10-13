

contract AlgoryPricingStrategy is PricingStrategy, Ownable {

    function AlgoryPricingStrategy() {
        //TODO
    }

    function getCurrentPrice(uint weiRaised) public constant returns (uint result) {
        //TODO
    }

    /// @dev Calculate the current price for buy in amount.
    function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {

        uint multiplier = 10 ** decimals;

        // This investor is coming through pre-ico
        if(preicoAddresses[msgSender] > 0) {
            return value.times(multiplier) / preicoAddresses[msgSender];
        }

        uint price = getCurrentPrice(weiRaised);
        return value.times(multiplier) / price;
    }

    function() payable {
        throw; // No money on this contract
    }

}