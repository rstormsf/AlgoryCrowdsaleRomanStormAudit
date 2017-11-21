# Algory Crowdsale Contract Audit

## Summary

[Algory](https:// /) intends to run a crowdsale commencing in Nov 2017.

Roman Storm was commissioned to perform an audit on the Algory's crowdsale and token Ethereum smart contract.

This audit has been conducted on Alrogy's source code in commits
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

The *ALG* contract is built on the *ReleasableToken, UpgradeableToken, BurnableToken, StandardToken* token contracts from https://github.com/TokenMarketNet/ico.

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
* **MEDIUM IMPORTANCE** There are many instances that I found in contract that changing the state variable before checking the state. It's highly
recommended to change state AFTER the `require/assert` check. Also reported in https://github.com/TokenMarketNet/ico/issues/84
Please look over every file in [code-review](./code-review) folder

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

* **LOW IMPORTANCE** Remove unused code from * [../contracts/crowdsale/AlgoryCrowdsale.sol#L233](../contracts/crowdsale/AlgoryCrowdsale.sol#L233)

```        //        require(pricingStrategy.isSane(address(this)));```

* **LOW IMPORTANCE** Remove unused variable that I [reported](https://github.com/OpenZeppelin/zeppelin-solidity/issues/572) in openzeppelin repo for StandardToken contract. Awaiting comment from zeppelin team.


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
* [] Change PricingStrategy by calling `setPricingStrategy`
* [] Change MultiSig by calling `setMultisigWallet`
* [] Call loadEarlyParticipantsWhitelist to whitelist addresses with cap amount
* [] Send contributions for whitelisted addresses and non-whitelisted address
* [] Call `finalize` by owner when crowdsale is successful
* [] Call refund if crowdsale is not succesful
* [] Try to send tokens during the crowdsale(Should be false)
* [] Burn tokens by calling `burn`

<br />

<hr />

## Code Review

* [x] [code-review/AlgoryCrowdsale.md](code-review/AlgoryCrowdsale.md)
  * [x] contract AlgoryCrowdsale is InvestmentPolicyCrowdsale
* [x] [code-review/AlgoryFinalizeAgent.md](code-review/AlgoryFinalizeAgent.md)
  * [x] contract AlgoryFinalizeAgent
* [x] [code-review/AlgoryPricingStrategy.md](code-review/AlgoryPricingStrategy.md)
  * [x] contract AlgoryPricingStrategy
* [x] [code-review/FinalizeAgent.md](code-review/FinalizeAgent.md)
  * [x] contract FinalizeAgent
* [x] [code-review/InvestmentPolicyCrowdsale.md](code-review/InvestmentPolicyCrowdsale.md)
  * [x] contract InvestmentPolicyCrowdsale
* [x] [code-review/PricingStrategy.md](code-review/PricingStrategy.md)
  * [x] contract PricingStrategy
* [x] [code-review/SafeMath.md](code-review/SafeMath.md)
  * [x] library SafeMath
* [x] [code-review/Ownable.md](code-review/Ownable.md)
  * [x] contract Ownable
* [x] [code-review/AlgoryToken.md](code-review/AlgoryToken.md)
  * [x] contract AlgoryToken
* [x] [code-review/BurnableToken.md](code-review/BurnableToken.md)
  * [x] contract BurnableToken
* [x] [code-review/CrowdsaleToken.md](code-review/CrowdsaleToken.md)
  * [x] contract CrowdsaleToken
* [x] [code-review/ERC20.md](code-review/ERC20.md)
  * [x] contract ERC20
* [x] [code-review/ERC20Basic.md](code-review/ERC20Basic.md)
  * [x] contract ERC20Basic
* [x] [code-review/ReleasableToken.md](code-review/ReleasableToken.md)
  * [x] contract ReleasableToken
* [x] [code-review/StandardToken.md](code-review/StandardToken.md)
  * [x] contract StandardToken
* [x] [code-review/UpgradeableToken.md](code-review/UpgradeableToken.md)
  * [x] contract UpgradeableToken
* [x] [code-review/UpgradeAgent.md](code-review/UpgradeAgent.md)
  * [x] contract UpgradeAgent

<br />

### Not Reviewed
* [../contracts/lifecycle/Migrations.sol](../contracts/lifecycle/Migrations.sol)

  This is a part of the Truffles testing framework

* [../contracts/crowdsale/NullFinalizeAgent.sol](../contracts/crowdsale/NullFinalizeAgent.sol)
  NullFinalizeAgent is not used anywhere in the code

* [../contracts/wallet/MultiSigWallet.sol](../contracts/wallet/MultiSigWallet.sol)
  The ConsenSys/Gnosis multisig wallet is the same as used in the [Gnosis MultiSig](https://github.com/gnosis/MultiSigWallet/commits/master/contracts/MultiSigWallet.sol).

  The only difference is in the line formating version number:

```diff
diff MultiSigWallet/contracts/MultiSigWallet.sol algory-ico/contracts/wallet/MultiSigWallet.sol
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
<             throw;
---
>         throw;
54c54
<             throw;
---
>         throw;
60c60
<             throw;
---
>         throw;
66c66
<             throw;
---
>         throw;
72c72
<             throw;
---
>         throw;
78c78
<             throw;
---
>         throw;
84c84
<             throw;
---
>         throw;
90c90
<             throw;
---
>         throw;
96,99c96,99
<             || _required > ownerCount
<             || _required == 0
<             || ownerCount == 0)
<             throw;
---
>         || _required > ownerCount
>         || _required == 0
>         || ownerCount == 0)
>         throw;
105c105
<         payable
---
>     payable
108c108
<             Deposit(msg.sender, msg.value);
---
>         Deposit(msg.sender, msg.value);
118,119c118,119
<         public
<         validRequirement(_owners.length, _required)
---
>     public
>     validRequirement(_owners.length, _required)
123c123
<                 throw;
---
>             throw;
133,137c133,137
<         public
<         onlyWallet
<         ownerDoesNotExist(owner)
<         notNull(owner)
<         validRequirement(owners.length + 1, required)
---
>     public
>     onlyWallet
>     ownerDoesNotExist(owner)
>     notNull(owner)
>     validRequirement(owners.length + 1, required)
147,149c147,149
<         public
<         onlyWallet
<         ownerExists(owner)
---
>     public
>     onlyWallet
>     ownerExists(owner)
153,156c153,156
<             if (owners[i] == owner) {
<                 owners[i] = owners[owners.length - 1];
<                 break;
<             }
---
>         if (owners[i] == owner) {
>             owners[i] = owners[owners.length - 1];
>             break;
>         }
159c159
<             changeRequirement(owners.length);
---
>         changeRequirement(owners.length);
167,170c167,170
<         public
<         onlyWallet
<         ownerExists(owner)
<         ownerDoesNotExist(newOwner)
---
>     public
>     onlyWallet
>     ownerExists(owner)
>     ownerDoesNotExist(newOwner)
173,176c173,176
<             if (owners[i] == owner) {
<                 owners[i] = newOwner;
<                 break;
<             }
---
>         if (owners[i] == owner) {
>             owners[i] = newOwner;
>             break;
>         }
186,188c186,188
<         public
<         onlyWallet
<         validRequirement(owners.length, _required)
---
>     public
>     onlyWallet
>     validRequirement(owners.length, _required)
200,201c200,201
<         public
<         returns (uint transactionId)
---
>     public
>     returns (uint transactionId)
210,213c210,213
<         public
<         ownerExists(msg.sender)
<         transactionExists(transactionId)
<         notConfirmed(transactionId, msg.sender)
---
>     public
>     ownerExists(msg.sender)
>     transactionExists(transactionId)
>     notConfirmed(transactionId, msg.sender)
223,226c223,226
<         public
<         ownerExists(msg.sender)
<         confirmed(transactionId, msg.sender)
<         notExecuted(transactionId)
---
>     public
>     ownerExists(msg.sender)
>     confirmed(transactionId, msg.sender)
>     notExecuted(transactionId)
235,238c235,238
<         public
<         ownerExists(msg.sender)
<         confirmed(transactionId, msg.sender)
<         notExecuted(transactionId)
---
>     public
>     ownerExists(msg.sender)
>     confirmed(transactionId, msg.sender)
>     notExecuted(transactionId)
244c244
<                 Execution(transactionId);
---
>             Execution(transactionId);
256,258c256,258
<         public
<         constant
<         returns (bool)
---
>     public
>     constant
>     returns (bool)
263c263
<                 count += 1;
---
>             count += 1;
265c265
<                 return true;
---
>             return true;
278,280c278,280
<         internal
<         notNull(destination)
<         returns (uint transactionId)
---
>     internal
>     notNull(destination)
>     returns (uint transactionId)
284,287c284,287
<             destination: destination,
<             value: value,
<             data: data,
<             executed: false
---
>         destination: destination,
>         value: value,
>         data: data,
>         executed: false
300,302c300,302
<         public
<         constant
<         returns (uint count)
---
>     public
>     constant
>     returns (uint count)
305,306c305,306
<             if (confirmations[transactionId][owners[i]])
<                 count += 1;
---
>         if (confirmations[transactionId][owners[i]])
>         count += 1;
314,316c314,316
<         public
<         constant
<         returns (uint count)
---
>     public
>     constant
>     returns (uint count)
319,321c319,321
<             if (   pending && !transactions[i].executed
<                 || executed && transactions[i].executed)
<                 count += 1;
---
>         if (   pending && !transactions[i].executed
>         || executed && transactions[i].executed)
>         count += 1;
327,329c327,329
<         public
<         constant
<         returns (address[])
---
>     public
>     constant
>     returns (address[])
338,340c338,340
<         public
<         constant
<         returns (address[] _confirmations)
---
>     public
>     constant
>     returns (address[] _confirmations)
346,349c346,349
<             if (confirmations[transactionId][owners[i]]) {
<                 confirmationsTemp[count] = owners[i];
<                 count += 1;
<             }
---
>         if (confirmations[transactionId][owners[i]]) {
>             confirmationsTemp[count] = owners[i];
>             count += 1;
>         }
352c352
<             _confirmations[i] = confirmationsTemp[i];
---
>         _confirmations[i] = confirmationsTemp[i];
362,364c362,364
<         public
<         constant
<         returns (uint[] _transactionIds)
---
>     public
>     constant
>     returns (uint[] _transactionIds)
370,375c370,375
<             if (   pending && !transactions[i].executed
<                 || executed && transactions[i].executed)
<             {
<                 transactionIdsTemp[count] = i;
<                 count += 1;
<             }
---
>         if (   pending && !transactions[i].executed
>         || executed && transactions[i].executed)
>         {
>             transactionIdsTemp[count] = i;
>             count += 1;
>         }
378c378
<             _transactionIds[i - from] = transactionIdsTemp[i];
---
>         _transactionIds[i - from] = transactionIdsTemp[i];
380c380
< }
---
> }
\ No newline at end of file

```


<br />

<br />

<br />
(c) Roman Storm / Roman Storm Consulting for Algory - Nov 13 2017. The MIT License.
Thank you to BokkyPooBah for inspiring me to write audits.