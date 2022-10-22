pragma solidity ^0.5.0;

import "./UnbrokenToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";


// Have the UnbrokenTokenCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
// UPDATED THE CONTRACT SIGNATURE TO ADD THE ABOVE INHERITANCE
contract UnbrokenTokenCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale { 
    
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint256 rate, // rate in TKNbits
        address payable wallet, // sale beneficiary
        UnbrokenToken token, // the UnbrokenToken itself that the UnbrokenTokenCrowdsale will work with
        uint goal, // the crowdsale goal
        uint open, // the crowdsale opening time
        uint close // the crowdsale closing time
    ) public
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
    {
        // constructor can stay empty
    }
}


contract UnbrokenTokenCrowdsaleDeployer {
    // Create an `address public` variable called `unbrokenTokenAddress`.
    address public unbrokenTokenAddress;
    // Create an `address public` variable called `unbrokenCrowdsaleAddress`.
    address public unbrokenCrowdsaleAddress;

    // Add the constructor.
    constructor(
       string memory name,
       string memory symbol,
       address payable wallet,
       uint initialSupply,
       uint goal
    ) public {
        // Create a new instance of the UnbrokenToken contract.
        UnbrokenToken token = new UnbrokenToken(name, symbol, initialSupply);
        
        // Assign the token contract’s address to the `unbrokenTokenAddress` variable.
        unbrokenTokenAddress = address(token);

        // Create a new instance of the `UnbrokenTokenCrowdsale` contract
        UnbrokenTokenCrowdsale unbrokenCrowdsale = new UnbrokenTokenCrowdsale(1, wallet, token, goal, now, now + 10 minutes);
            
        // Aassign the `UnbrokenTokenCrowdsale` contract’s address to the `unbrokenCrowdsaleAddress` variable.
        unbrokenCrowdsaleAddress = address(unbrokenCrowdsale);

        // Set the `UnbrokenTokenCrowdsale` contract as a minter
        token.addMinter(unbrokenCrowdsaleAddress);
        
        // Have the `UnbrokenTokenCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }
}