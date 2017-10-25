pragma solidity ^0.4.15;


/// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
/// @author Stefan George - <stefan.george@consensys.net>
contract MultiSigWallet {event __CoverageMultiSigWallet(string fileName, uint256 lineNumber);
event __FunctionCoverageMultiSigWallet(string fileName, uint256 fnId);
event __StatementCoverageMultiSigWallet(string fileName, uint256 statementId);
event __BranchCoverageMultiSigWallet(string fileName, uint256 branchId, uint256 locationIdx);
event __AssertPreCoverageMultiSigWallet(string fileName, uint256 branchId);
event __AssertPostCoverageMultiSigWallet(string fileName, uint256 branchId);


    /*
     *  Events
     */
    event Confirmation(address indexed sender, uint indexed transactionId);
    event Revocation(address indexed sender, uint indexed transactionId);
    event Submission(uint indexed transactionId);
    event Execution(uint indexed transactionId);
    event ExecutionFailure(uint indexed transactionId);
    event Deposit(address indexed sender, uint value);
    event OwnerAddition(address indexed owner);
    event OwnerRemoval(address indexed owner);
    event RequirementChange(uint required);

    /*
     *  Constants
     */
    uint constant public MAX_OWNER_COUNT = 50;

    /*
     *  Storage
     */
    mapping (uint => Transaction) public transactions;
    mapping (uint => mapping (address => bool)) public confirmations;
    mapping (address => bool) public isOwner;
    address[] public owners;
    uint public required;
    uint public transactionCount;

    struct Transaction {
        address destination;
        uint value;
        bytes data;
        bool executed;
    }

    /*
     *  Modifiers
     */
    modifier onlyWallet() {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',1);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',47);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',1);
if (msg.sender != address(this))
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',2);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',1,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',48);
revert();}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',1,1);}

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',49);
        _;
    }

    modifier ownerDoesNotExist(address owner) {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',2);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',53);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',3);
if (isOwner[owner])
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',4);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',2,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',54);
revert();}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',2,1);}

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',55);
        _;
    }

    modifier ownerExists(address owner) {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',3);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',59);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',5);
if (!isOwner[owner])
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',6);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',3,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',60);
revert();}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',3,1);}

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',61);
        _;
    }

    modifier transactionExists(uint transactionId) {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',4);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',65);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',7);
if (transactions[transactionId].destination == 0)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',8);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',4,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',66);
revert();}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',4,1);}

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',67);
        _;
    }

    modifier confirmed(uint transactionId, address owner) {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',5);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',71);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',9);
if (!confirmations[transactionId][owner])
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',10);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',5,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',72);
revert();}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',5,1);}

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',73);
        _;
    }

    modifier notConfirmed(uint transactionId, address owner) {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',6);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',77);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',11);
if (confirmations[transactionId][owner])
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',12);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',6,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',78);
revert();}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',6,1);}

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',79);
        _;
    }

    modifier notExecuted(uint transactionId) {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',7);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',83);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',13);
if (transactions[transactionId].executed)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',14);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',7,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',84);
revert();}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',7,1);}

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',85);
        _;
    }

    modifier notNull(address _address) {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',8);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',89);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',15);
if (_address == 0)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',16);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',8,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',90);
revert();}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',8,1);}

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',91);
        _;
    }

    modifier validRequirement(uint ownerCount, uint _required) {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',9);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',95);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',17);
if (   ownerCount > MAX_OWNER_COUNT
        || _required > ownerCount
        || _required == 0
        || ownerCount == 0)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',18);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',9,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',99);
revert();}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',9,1);}

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',100);
        _;
    }

    /// @dev Fallback function allows to deposit ether.
    function()
    payable
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',10);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',107);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',19);
if (msg.value > 0)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',20);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',10,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',108);
Deposit(msg.sender, msg.value);}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',10,1);}

    }

    /*
     * Public functions
     */
    /// @dev Contract constructor sets initial owners and required number of confirmations.
    /// @param _owners List of initial owners.
    /// @param _required Number of required confirmations.
    function MultiSigWallet(address[] _owners, uint _required)
    public
    validRequirement(_owners.length, _required)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',11);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',121);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',21);
for (uint i=0; i<_owners.length; i++) {
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',122);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',22);
if (isOwner[_owners[i]] || _owners[i] == 0)
            { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',23);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',11,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',123);
revert();}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',11,1);}

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',124);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',24);
isOwner[_owners[i]] = true;
        }
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',126);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',25);
owners = _owners;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',127);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',26);
required = _required;
    }

    /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
    /// @param owner Address of new owner.
    function addOwner(address owner)
    public
    onlyWallet
    ownerDoesNotExist(owner)
    notNull(owner)
    validRequirement(owners.length + 1, required)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',12);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',139);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',27);
isOwner[owner] = true;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',140);
        owners.push(owner);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',141);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',28);
OwnerAddition(owner);
    }

    /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
    /// @param owner Address of owner.
    function removeOwner(address owner)
    public
    onlyWallet
    ownerExists(owner)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',13);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',151);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',29);
isOwner[owner] = false;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',152);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',30);
for (uint i=0; i<owners.length - 1; i++)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',31);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',153);
if (owners[i] == owner) {__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',12,0);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',154);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',32);
owners[i] = owners[owners.length - 1];
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',155);
            break;
        }else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',12,1);}
}
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',157);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',33);
owners.length -= 1;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',158);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',34);
if (required > owners.length)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',35);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',13,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',159);
changeRequirement(owners.length);}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',13,1);}

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',160);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',36);
OwnerRemoval(owner);
    }

    /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
    /// @param owner Address of owner to be replaced.
    /// @param newOwner Address of new owner.
    function replaceOwner(address owner, address newOwner)
    public
    onlyWallet
    ownerExists(owner)
    ownerDoesNotExist(newOwner)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',14);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',172);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',37);
for (uint i=0; i<owners.length; i++)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',38);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',173);
if (owners[i] == owner) {__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',14,0);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',174);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',39);
owners[i] = newOwner;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',175);
            break;
        }else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',14,1);}
}
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',177);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',40);
isOwner[owner] = false;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',178);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',41);
isOwner[newOwner] = true;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',179);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',42);
OwnerRemoval(owner);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',180);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',43);
OwnerAddition(newOwner);
    }

    /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
    /// @param _required Number of required confirmations.
    function changeRequirement(uint _required)
    public
    onlyWallet
    validRequirement(owners.length, _required)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',15);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',190);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',44);
required = _required;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',191);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',45);
RequirementChange(_required);
    }

    /// @dev Allows an owner to submit and confirm a transaction.
    /// @param destination Transaction target address.
    /// @param value Transaction ether value.
    /// @param data Transaction data payload.
    /// @return Returns transaction ID.
    function submitTransaction(address destination, uint value, bytes data)
    public
    returns (uint transactionId)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',16);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',203);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',46);
transactionId = addTransaction(destination, value, data);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',204);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',47);
confirmTransaction(transactionId);
    }

    /// @dev Allows an owner to confirm a transaction.
    /// @param transactionId Transaction ID.
    function confirmTransaction(uint transactionId)
    public
    ownerExists(msg.sender)
    transactionExists(transactionId)
    notConfirmed(transactionId, msg.sender)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',17);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',215);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',48);
confirmations[transactionId][msg.sender] = true;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',216);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',49);
Confirmation(msg.sender, transactionId);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',217);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',50);
executeTransaction(transactionId);
    }

    /// @dev Allows an owner to revoke a confirmation for a transaction.
    /// @param transactionId Transaction ID.
    function revokeConfirmation(uint transactionId)
    public
    ownerExists(msg.sender)
    confirmed(transactionId, msg.sender)
    notExecuted(transactionId)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',18);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',228);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',51);
confirmations[transactionId][msg.sender] = false;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',229);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',52);
Revocation(msg.sender, transactionId);
    }

    /// @dev Allows anyone to execute a confirmed transaction.
    /// @param transactionId Transaction ID.
    function executeTransaction(uint transactionId)
    public
    ownerExists(msg.sender)
    confirmed(transactionId, msg.sender)
    notExecuted(transactionId)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',19);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',240);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',53);
if (isConfirmed(transactionId)) {__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',15,0);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',241);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',54);
Transaction tx = transactions[transactionId];
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',242);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',55);
tx.executed = true;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',243);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',56);
if (tx.destination.call.value(tx.value)(tx.data))
            { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',57);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',16,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',244);
Execution(transactionId);}
            else {__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',16,1);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',246);
                 __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',58);
ExecutionFailure(transactionId);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',247);
                 __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',59);
tx.executed = false;
            }
        }else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',15,1);}

    }

    /// @dev Returns the confirmation status of a transaction.
    /// @param transactionId Transaction ID.
    /// @return Confirmation status.
    function isConfirmed(uint transactionId)
    public
    constant
    returns (bool)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',20);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',260);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',60);
uint count = 0;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',261);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',61);
for (uint i=0; i<owners.length; i++) {
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',262);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',62);
if (confirmations[transactionId][owners[i]])
            { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',63);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',17,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',263);
count += 1;}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',17,1);}

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',264);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',64);
if (count == required)
            { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',65);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',18,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',265);
return true;}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',18,1);}

        }
    }

    /*
     * Internal functions
     */
    /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
    /// @param destination Transaction target address.
    /// @param value Transaction ether value.
    /// @param data Transaction data payload.
    /// @return Returns transaction ID.
    function addTransaction(address destination, uint value, bytes data)
    internal
    notNull(destination)
    returns (uint transactionId)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',21);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',282);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',66);
transactionId = transactionCount;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',283);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',67);
transactions[transactionId] = Transaction({
        destination: destination,
        value: value,
        data: data,
        executed: false
        });
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',289);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',68);
transactionCount += 1;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',290);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',69);
Submission(transactionId);
    }

    /*
     * Web3 call functions
     */
    /// @dev Returns number of confirmations of a transaction.
    /// @param transactionId Transaction ID.
    /// @return Number of confirmations.
    function getConfirmationCount(uint transactionId)
    public
    constant
    returns (uint count)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',22);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',304);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',70);
for (uint i=0; i<owners.length; i++)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',71);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',305);
if (confirmations[transactionId][owners[i]])
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',72);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',19,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',306);
count += 1;}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',19,1);}
}
    }

    /// @dev Returns total number of transactions after filers are applied.
    /// @param pending Include pending transactions.
    /// @param executed Include executed transactions.
    /// @return Total number of transactions after filters are applied.
    function getTransactionCount(bool pending, bool executed)
    public
    constant
    returns (uint count)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',23);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',318);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',73);
for (uint i=0; i<transactionCount; i++)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',74);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',319);
if (   pending && !transactions[i].executed
        || executed && transactions[i].executed)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',75);
__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',20,0);__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',321);
count += 1;}else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',20,1);}
}
    }

    /// @dev Returns list of owners.
    /// @return List of owner addresses.
    function getOwners()
    public
    constant
    returns (address[])
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',24);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',331);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',76);
return owners;
    }

    /// @dev Returns array with owner addresses, which confirmed transaction.
    /// @param transactionId Transaction ID.
    /// @return Returns array of owner addresses.
    function getConfirmations(uint transactionId)
    public
    constant
    returns (address[] _confirmations)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',25);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',342);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',77);
address[] memory confirmationsTemp = new address[](owners.length);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',343);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',78);
uint count = 0;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',344);
        uint i;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',345);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',79);
for (i=0; i<owners.length; i++)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',80);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',346);
if (confirmations[transactionId][owners[i]]) {__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',21,0);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',347);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',81);
confirmationsTemp[count] = owners[i];
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',348);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',82);
count += 1;
        }else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',21,1);}
}
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',350);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',83);
_confirmations = new address[](count);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',351);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',84);
for (i=0; i<count; i++)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',85);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',352);
_confirmations[i] = confirmationsTemp[i];}
    }

    /// @dev Returns list of transaction IDs in defined range.
    /// @param from Index start position of transaction array.
    /// @param to Index end position of transaction array.
    /// @param pending Include pending transactions.
    /// @param executed Include executed transactions.
    /// @return Returns array of transaction IDs.
    function getTransactionIds(uint from, uint to, bool pending, bool executed)
    public
    constant
    returns (uint[] _transactionIds)
    {__FunctionCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',26);

__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',366);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',86);
uint[] memory transactionIdsTemp = new uint[](transactionCount);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',367);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',87);
uint count = 0;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',368);
        uint i;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',369);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',88);
for (i=0; i<transactionCount; i++)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',89);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',370);
if (   pending && !transactions[i].executed
        || executed && transactions[i].executed)
        {__BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',22,0);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',373);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',90);
transactionIdsTemp[count] = i;
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',374);
             __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',91);
count += 1;
        }else { __BranchCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',22,1);}
}
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',376);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',92);
_transactionIds = new uint[](to - from);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',377);
         __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',93);
for (i=from; i<to; i++)
        { __StatementCoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',94);
__CoverageMultiSigWallet('/Users/marcin/dev/mgordel/ethereum/algory-ico/contracts/wallet/MultiSigWallet.sol',378);
_transactionIds[i - from] = transactionIdsTemp[i];}
    }
}