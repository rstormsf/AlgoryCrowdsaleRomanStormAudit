pragma solidity ^0.4.15;

/**
 * Finalize agent defines what happens at the end of successful crowdsale.
 * Allocate tokens for founders, bounties and community
 */
contract FinalizeAgent {event __CoverageFinalizeAgent(string fileName, uint256 lineNumber);
event __FunctionCoverageFinalizeAgent(string fileName, uint256 fnId);
event __StatementCoverageFinalizeAgent(string fileName, uint256 statementId);
event __BranchCoverageFinalizeAgent(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageFinalizeAgent(string fileName, uint256 branchId);
event __AssertPostCoverageFinalizeAgent(string fileName, uint256 branchId);


  function isFinalizeAgent() public constant returns(bool) {__FunctionCoverageFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/FinalizeAgent.sol',1);

__CoverageFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/FinalizeAgent.sol',10);
     __StatementCoverageFinalizeAgent('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/crowdsale/FinalizeAgent.sol',1);
return true;
  }

  /** Return true if we can run finalizeCrowdsale() properly.
   *
   * This is a safety check function that doesn't allow crowdsale to begin
   * unless the finalizer has been set up properly.
   */
  function isSane() public constant returns (bool);

  /** Called once by crowdsale finalize() if the sale was success. */
  function finalizeCrowdsale();

}