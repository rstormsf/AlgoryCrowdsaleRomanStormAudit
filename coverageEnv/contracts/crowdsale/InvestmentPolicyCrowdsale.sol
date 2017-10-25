pragma solidity ^0.4.15;

import '../ownership/Haltable.sol';

contract InvestmentPolicyCrowdsale is Haltable {event __CoverageInvestmentPolicyCrowdsale(string fileName, uint256 lineNumber);
event __FunctionCoverageInvestmentPolicyCrowdsale(string fileName, uint256 fnId);
event __StatementCoverageInvestmentPolicyCrowdsale(string fileName, uint256 statementId);
event __BranchCoverageInvestmentPolicyCrowdsale(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageInvestmentPolicyCrowdsale(string fileName, uint256 branchId);
event __AssertPostCoverageInvestmentPolicyCrowdsale(string fileName, uint256 branchId);


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
     * Set policy do we need to have server-side customer ids for the investments.
     *
     */
    function setRequireCustomerId(bool value) onlyOwner external{__FunctionCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',1);

__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',27);
         __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',1);
requireCustomerId = value;
__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',28);
         __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',2);
InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
    }

    /**
     * Set policy if all investors must be cleared on the server side first.
     *
     * This is e.g. for the accredited investor clearing.
     *
     */
    function setRequireSignedAddress(bool value, address _signerAddress) external onlyOwner {__FunctionCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',2);

__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',38);
         __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',3);
requiredSignedAddress = value;
__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',39);
         __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',4);
signerAddress = _signerAddress;
__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',40);
         __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',5);
InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
    }

    /**
     * Invest to tokens, recognize the payer and clear his address.
     */
    function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) external payable {__FunctionCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',3);

__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',47);
         __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',6);
investWithSignedAddress(msg.sender, customerId, v, r, s);
    }

    /**
     * Invest to tokens, recognize the payer.
     *
     */
    function buyWithCustomerId(uint128 customerId) external payable {__FunctionCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',4);

__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',55);
         __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',7);
investWithCustomerId(msg.sender, customerId);
    }

    /**
     * Allow anonymous contributions to this crowdsale.
     */
    function invest(address addr) public payable {__FunctionCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',5);

        __AssertPreCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',1);
 __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',8);
assert(!requireCustomerId);__AssertPostCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',1);
 // Crowdsale needs to track participants for thank you email
        __AssertPreCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',2);
 __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',9);
assert(!requiredSignedAddress);__AssertPostCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',2);
 // Crowdsale allows only server-side signed participants
__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',64);
         __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',10);
investInternal(addr, 0);
    }

    /**
     * Allow anonymous contributions to this crowdsale.
     */
    function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {__FunctionCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',6);

__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',71);
         __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',11);
bytes32 hash = sha256(addr);
__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',72);
        __AssertPreCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',3);
 __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',12);
require(ecrecover(hash, v, r, s) == signerAddress);__AssertPostCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',3);

        __AssertPreCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',4);
 __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',13);
require(customerId != 0);__AssertPostCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',4);
  // UUIDv4 sanity check
__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',74);
         __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',14);
investInternal(addr, customerId);
    }

    /**
     * Track who is the customer making the payment so we can send thank you email.
     */
    function investWithCustomerId(address addr, uint128 customerId) public payable {__FunctionCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',7);

        // Crowdsale allows only server-side signed participants
__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',82);
        __AssertPreCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',5);
 __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',15);
require(requiredSignedAddress && customerId != 0);__AssertPostCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',5);

__CoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',83);
         __StatementCoverageInvestmentPolicyCrowdsale('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/InvestmentPolicyCrowdsale.sol',16);
investInternal(addr, customerId);
    }

    function investInternal(address receiver, uint128 customerId) stopInEmergency internal;
}