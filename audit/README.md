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

* **MEDIUM IMPORTANCE** Incorrect calculation of how much wei is allowed for presale.
To reproduce:
1. call setEarlyParticipantWhitelist("0x0039F22efB07A647557C7C5d17854CFD6D489eF3", "300000000000000000000")
call again setEarlyParticipantWhitelist for the same address("0x0039F22efB07A647557C7C5d17854CFD6D489eF3", "300000000000000000000")
Result: `whitelistWeiRaised` is `600000000000000000000`. 
Expected result: since we only changed the value for whitelisted address to some other value, `whitelistWeiRaised` should not be increased.

* **LOW IMPORTANCE** Usage of fallback function.
The issue has been discussed with author of framework: https://github.com/TokenMarketNet/ico/issues/53 where
he explains that it's highly recommended that to disable fallback to prevent users from sending ETH from crypto
exchanges. Fallbacks are also executed if called method doesn't exist on a contract which might create another issues for the caller.

* **LOW IMPORTANCE** There are many instances that I found in contract that changing the state variable before checking the state. It's highly
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

This audit makes no statements or warranties about the viability of the Algory's business proposition, the individuals
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

* [x] Deploy AlgoryFinalizeAgent contract
* [x] Deploy AlgoryPricingStrategy contract
* [x] Deploy AlgoryCrowdsale contract
* [x] Deploy AlgoryToken contract
* [x] Change PricingStrategy by calling `setPricingStrategy`
* [x] Call loadEarlyParticipantsWhitelist to whitelist addresses with cap amount
* [x] Send contributions for whitelisted addresses and non-whitelisted address
* [x] Call `finalize` by owner when crowdsale is successful
* [x] Call refund if crowdsale is not succesful
* [x] Try to send tokens during the crowdsale(Should be false)
* [x] Burn tokens by calling `burn`

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

### Testnet deployments
Used tool [truffle-flattener](https://github.com/alcuadrado/truffle-flattener):
```
./node_modules/.bin/truffle-flattener contracts/crowdsale/AlgoryPricingStrategy.sol contracts/crowdsale/AlgoryCrowdsale.sol contracts/token/AlgoryToken.sol contracts/crowdsale/AlgoryFinalizeAgent.sol > algory_flat.sol
```

Algory token deployed:
https://kovan.etherscan.io/address/0x7be33d2c245c5b3807fe9afeaf667986301c15a4#code

AlgoryPricing Strategy deployed:
https://kovan.etherscan.io/address/0x4bd838d20f2a6264b1910768fb7cdfc02746a88f#code

AlgoryCrowdsale deployed:
https://kovan.etherscan.io/address/0x3f4d0836527027b24fc60b95b2b14fcc04044c07#code

AlgoryFinalizeAgent deployed:
https://kovan.etherscan.io/address/0x234ecf44be1760a8daf32af4333904b6d12ef592#code

AlgoryToken.setReleaseAgent(finalizeagent address):
https://kovan.etherscan.io/tx/0x998472a82081d565b0fc39e41d7a238e89ab6a7d40df056241ac1a93f218c59b

AlgoryCrowdsale.setFinalizeAgent(finalize agent address):
https://kovan.etherscan.io/tx/0xa806c28a661199edc335b87402aba14cce55b39885e5acb68e9656490d35351e

AlgoryToken.setTransferAgent(address from which tokens will be sold):
https://kovan.etherscan.io/tx/0xb7a56521087928eafcd102547f2d636a5860bcb31ab068a2c2f460f77295840a

AlgoryToken.approve(crowdsale, totalSupply to sell):
https://kovan.etherscan.io/tx/0xaf710008dd02b83b6bd023ab65da417bbaf8a5d9ab5b14d5e3668d682f192458

AlgoryCrowdsale.prepareCrowdsale:
https://kovan.etherscan.io/tx/0xada4fcbeee5ef37765d7868d707c665b06113fe6f7a5b74d532467fe4c982e23
Assigns tokens to the team

Whitelist an address for presale:
https://kovan.etherscan.io/tx/0xb7e9e2a3eeba596787ad8ffe19a9c301b3ad3ce460a289713f12a665710a9998

Buy presale:
https://kovan.etherscan.io/tx/0xdbe00264a517530e26071e7ec64b7a44dc8636c9238ac35afcd06eab1d6748df
123 ether = 147,600 algory tokens

Change crowdsale startAt:
https://kovan.etherscan.io/tx/0xfea1e6e9ef2ee7219f99620939b1984928a6ccb21403d905bec14d74622361fc

Call pause:
https://kovan.etherscan.io/tx/0x6a779058aae3450d237cdc1c9e4f794b9b94ff7465a5afe5e1f6df5b58944f5f

Call unpause:
https://kovan.etherscan.io/tx/0x1c4ce33906eae48a846613105a914ed116824d2312e8de91e92ac65852ae8997

Buy non-whitelisted during ICO(after presale has ended):
https://kovan.etherscan.io/tx/0xf17afca41e968ed86f27af00477caefd7fe3bc23e8e996b37c6b91031a103a44
0.5 eth = 600 algory

Call setEndsAt:
https://kovan.etherscan.io/tx/0x97bc94cb1898847203d37620458014952a22a422a415572fe702ee806ccca2ea

Call finalize:
https://kovan.etherscan.io/tx/0x69370bd215517c486e9d2ffba7cc4008257bc34cb38c36199eae41ddb4d0685d

Call burn on token contract:
https://kovan.etherscan.io/tx/0x3e7564a82003ff410cf630d6faa612a6a1a6be863e09f8579879bb5aaf4a105f

Call transfer on token contract:
https://kovan.etherscan.io/tx/0x408b9f70613943823c749cfdb10f07d97aebe0ab60418b3e7c8666e6741e5d96


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