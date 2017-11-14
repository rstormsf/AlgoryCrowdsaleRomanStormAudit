# Algory Crowdsale Contract Audit

## Summary

[Algory](https:// /) intends to run a crowdsale commencing in Nov 2017.

Roman Storm was commissioned to perform an audit on the Algory's crowdsale and token Ethereum smart contract.

This audit has been conducted on Aigang's source code in commits
[6853423](https://gitlab.com/marcin.gordel/algory-ico/commit/6853423c05e1b21c70f698482635293b3907e1e8).

No potential vulnerabilities have been identified in the crowdsale and token contract.

<br />

### Mainnet Addresses

`TBA`

<br />

### Crowdsale Contract

Ethers contributed by participants to the crowdsale contract will result in ALG tokens being allocated to the participant's 
account in the token contract. The contributed ethers are immediately transferred to the crowdsale multisig wallet, reducing the 
risk of the loss of ethers in this bespoke smart contract.

<br />

### Token Contract

The *ALG* contract is built on the *ReleasableToken, UpgradeableToken* token contracts from https://github.com/TokenMarketNet/ico.

Algory token implements Upgradeable token which means users can opt-in amount of tokens to the next smart contract revision
Transfers will be halted during the ICO, and only will be enabled after crowdsale is finished.
Only 1 token address will be allowed to make transfers: the address from which tokens will be sold.
<br />

## Table Of Contents

* [Summary](#summary)
* [Recommendations](#recommendations)
* [Potential Vulnerabilities](#potential-vulnerabilities)
* [Scope](#scope)
* [Limitations](#limitations)
* [Due Diligence](#due-diligence)
* [Risks](#risks)
* [Testing](#testing)
* [Code Review](#code-review)

<br />

<hr />

## Recommendations

The following two recommendations are optional changes to the crowdsale and token contract:

* **MEDIUM IMPORTANCE** Usage of fallback function.
The issue has been discussed with author of framework: https://github.com/TokenMarketNet/ico/issues/53 where
he explains that it's highly recommended that to disable fallback to prevent users from sending ETH from crypto
exchanges. Fallbacks are also executed if called method doesn't exist on a contract which might create another issues for the caller.

* **MEDIUM IMPORTANCE** prepareCrowdsale method could be called multiple times.
It's intended to call this method only once to prevent double token generation for founder's allocation.
In order to provide trustless behavior, I'd recommend adding the following code in `prepareCrowdsale` method:
```
require(!isPreallocated);
```

* **LOW IMPORTANCE** Usage of `send` vs `transfer`.
While it's perfectly fine to use `send` if it's used with `if` or `require` statement, there is already implemented 
`transfer` function which throws an error on unsuccesful transfer. 
https://github.com/TokenMarketNet/ico/issues/83

* **LOW IMPORTANCE** Redundant method `isCrowdsale` that is not used anywhere else.
LINK TO LINE NUMBER
Since fallback function is enabled, it's not recommended to use such checks because if they fail, fallback will be executed.

* **LOW IMPORTANCE** Usage of `assert(...)` keyword rather than the
  `require(...)` keyword. Using the `require(...)` keyword instead of `assert(...)` will result in lower gas cost for participants when there is an error
  Here is list of all `assert` statements used in the contract:

* **LOW IMPORTANCE** ReleasableToken. Use the OpenZeppelin Claimable contract instead of the Ownable contract to provide more safety during the ownership transfer process

* **LOW IMPORTANCE** AlgoryToken#L23. Redundant check for `totalSupply > 0` while `INITIAL_SUPPLY` has already been declared.
I don't think it's necessary to check since INITIAL_SUPPLY is already hard coded into the contract.

* **LOW IMPORTANCE** NullFinalizeAgent is not used anywhere

* **LOW IMPORTANCE** MultiSigWallet has different line formating than original gnosis/MultiSigWallet.sol

<br />

<hr />

## Potential Vulnerabilities

No potential vulnerabilities have been identified in the crowdsale and token contract.

<br />

<hr />

## Scope

This audit is into the technical aspects of the crowdsale contracts. The primary aim of this audit is to ensure that funds
contributed to these contracts are not easily attacked or stolen by third parties. The secondary aim of this audit is that
ensure the coded algorithms work as expected. This audit does not guarantee that that the code is bugfree, but intends to
highlight any areas of weaknesses.

<br />

<hr />

## Limitations

This audit makes no statements or warranties about the viability of the Aigang's business proposition, the individuals
involved in this business or the regulatory regime for the business model.

<br />

<hr />

## Due Diligence

As always, potential participants in any crowdsale are encouraged to perform their due diligence on the business proposition
before funding any crowdsales.

Potential participants are also encouraged to only send their funds to the official crowdsale Ethereum address, published on
the crowdsale beneficiary's official communication channel.

Scammers have been publishing phishing address in the forums, twitter and other communication channels, and some go as far as
duplicating crowdsale websites. Potential participants should NOT just click on any links received through these messages.
Scammers have also hacked the crowdsale website to replace the crowdsale contract address with their scam address.
 
Potential participants should also confirm that the verified source code on EtherScan.io for the published crowdsale address
matches the audited source code, and that the deployment parameters are correctly set, including the constant parameters.

<br />

<hr />

## Risks

* This crowdsale contract has a low risk of having the ETH hacked or stolen, as any contributions by participants are immediately transferred
  to the crowdsale wallet.

<br />

<hr />

## Testing

The following functions were tested using the script [test/01_test1.sh](test/01_test1.sh) with the summary results saved
in [test/test1results.txt](test/test1results.txt) and the detailed output saved in [test/test1output.txt](test/test1output.txt):

* [] Deploy AlgoryFinalizeAgent contract
* [] Deploy AlgoryPricingStrategy contract
* [] Deploy AlgoryCrowdsale contract
* [] Deploy AlgoryToken contract
* [] Send contributions for whitelisted addresses and non-whitelisted address
* [] Call refund if crowdsale is not succesful

<br />

<hr />

## Code Review

* [x] [code-review/AlgoryCrowdsale.md](code-review/AlgoryCrowdsale.md)
  * [x] contract AlgoryCrowdsale is InvestmentPolicyCrowdsale
* [] [code-review/AlgoryFinalizeAgent.md](code-review/AlgoryFinalizeAgent.md)
  * [] contract AlgoryFinalizeAgent
* [] [code-review/AlgoryPricingStrategy.md](code-review/AlgoryPricingStrategy.md)
  * [] contract AlgoryPricingStrategy
* [] [code-review/FinalizeAgent.md](code-review/FinalizeAgent.md)
  * [] contract FinalizeAgent
* [] [code-review/InvestmentPolicyCrowdsale.md](code-review/InvestmentPolicyCrowdsale.md)
  * [] contract InvestmentPolicyCrowdsale
* [] [code-review/PricingStrategy.md](code-review/PricingStrategy.md)
  * [] contract PricingStrategy
* [] [code-review/SafeMath.md](code-review/SafeMath.md)
  * [] library SafeMath
* [] [code-review/Ownable.md](code-review/Ownable.md)
  * [] contract Ownable
* [] [code-review/AlgoryToken.md](code-review/AlgoryToken.md)
  * [] contract AlgoryToken
* [] [code-review/BurnableToken.md](code-review/BurnableToken.md)
  * [] contract BurnableToken
* [] [code-review/CrowdsaleToken.md](code-review/CrowdsaleToken.md)
  * [] contract CrowdsaleToken
* [] [code-review/ERC20.md](code-review/ERC20.md)
  * [] contract ERC20
* [] [code-review/ERC20Basic.md](code-review/ERC20Basic.md)
  * [] contract ERC20Basic
* [] [code-review/ReleasableToken.md](code-review/ReleasableToken.md)
  * [] contract ReleasableToken
* [] [code-review/StandardToken.md](code-review/StandardToken.md)
  * [] contract StandardToken
* [] [code-review/UpgradeableToken.md](code-review/UpgradeableToken.md)
  * [] contract UpgradeableToken
* [] [code-review/UpgradeAgent.md](code-review/UpgradeAgent.md)
  * [] contract UpgradeAgent

<br />

### Not Reviewed

* [../contracts/wallet/MultiSigWallet.sol](../contracts/wallet/MultiSigWallet.sol)
  The ConsenSys/Gnosis multisig wallet is the same as used in the [Gnosis MultiSig](https://github.com/gnosis/MultiSigWallet/commits/master/contracts/MultiSigWallet.sol).

  The only difference is in the line formating version number:

  ```diff
  $ diff MultiSigWallet/contracts/MultiSigWallet.sol algory-ico/contracts/wallet/MultiSigWallet.sol
  37,40c37,40
<         address destination;
<         uint value;
<         bytes data;
<         bool executed;
---
>     address destination;
>     uint value;
>     bytes data;
>     bool executed;
48c48
.... and in the whole file
  ```

* [../contracts/lifecycle/Migrations.sol](../contracts/lifecycle/Migrations.sol)

  This is a part of the Truffles testing framework

<br />

<br />

<br />
(c) Roman Storm / Roman Storm Consulting for Algory - Nov 13 2017. The MIT License.
Thank you to BokkyPooBah for inspiring me to write audits.