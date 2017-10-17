pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/token/AlgoryToken.sol";

contract TestAlgoryToken {

  function testInitialSupplyUsingDeployedContract() {
    AlgoryToken algory = AlgoryToken(DeployedAddresses.AlgoryToken());
    uint expected = 120000000;
    Assert.equal(algory.balanceOf(tx.origin), expected, "Owner should have 120000000 ALG initially");
  }

//  function testInitialBalanceWithNewMetaCoin() {
//    MetaCoin meta = new MetaCoin();
//
//    uint expected = 10000;
//
//    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 MetaCoin initially");
//  }

}
