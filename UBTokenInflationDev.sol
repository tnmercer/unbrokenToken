pragma solidity ^0.5.0;



//  Import the following contracts from the OpenZeppelin library:
//    * `ERC20`
//    * `ERC20Detailed`
//    * `ERC20Mintable`
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";

// Create a constructor for the UnbrokenToken contract and have the contract inherit the libraries that you imported from OpenZeppelin.
contract UnbrokenToken is ERC20, ERC20Detailed, ERC20Mintable {
    /// Defines the owner address that is allowed to mint new tokens
    address payable owner;
    /// Defines how frequently inflation can be triggered: Once every 10 minutes
    uint256 public constant TIME_BETWEEN_MINTINGS = 10 minutes;
    /// Defines the maximal inflation per period
    uint256 public constant MAX_INFLATION = 10;
    /// Stores the timestamp of the last inflation event
    uint256 public timestampLastMinting = 0;

    /// Error caused by an attempt to mint too many tokens.
    error ExceedingMintCap();
    /// Error caused by calling the mint function more than once within minting period.
    error AlreadyInflated();
    /// Error caused by calling the mint function from a non-cowDao account.
    error OnlyOwner();

    modifier onlyOwner {
        require(msg.sender == owner, "You do not have permission to mint these tokens!");
        _;
    }

    constructor(
        string memory name,
        string memory symbol,
        uint initialSupply
    )
        ERC20Detailed(name, symbol, 18)
        public
    {
        // Left Empty
        // hint-disable-next-line not-rely-on-time
        timestampLastMinting = block.timestamp;
    }

    /// This function allows to mint new tokens
    /// target The address that should receive the new tokens
    /// amount The amount of tokens to be minted.
    function mint(address target, uint256 amount) external onlyOwner {
        if (amount > (totalSupply() * MAX_INFLATION) / 100) {
            revert ExceedingMintCap();
        }
        // hint-disable-next-line not-rely-on-time
        if (timestampLastMinting + TIME_BETWEEN_MINTINGS > block.timestamp) {
            revert AlreadyInflated();
        }
        timestampLastMinting = block.timestamp; // hint-disable-line not-rely-on-time
        _mint(target, amount);
    }
}