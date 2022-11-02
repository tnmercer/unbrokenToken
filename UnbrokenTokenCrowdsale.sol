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
    
    uint256 private _rate; // rate in TKNbits
    uint256 private _initialRate; // initial rate in TKNbits
    uint256 private _finalRate; // final rate in TKNbits
    uint256 private _goal; // the crowdsale goal
    
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint256 rate, // rate in TKNbits
        uint256 initialRate, // initial rate in TKNbits
        uint256 finalRate, // final rate in TKNbits
        address payable wallet, // sale beneficiary
        UnbrokenToken token, // the UnbrokenToken itself that the UnbrokenTokenCrowdsale will work with
        //address movingRateAddress, // the movingRate contract that the crowdsale will work with
        uint256 goal, // the crowdsale goal
        uint open, // the crowdsale opening time
        uint close // the crowdsale closing time
    ) public
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
    {
        // constructor can stay empty
        _rate = rate;
        _initialRate = initialRate;
        _finalRate = finalRate;
        _goal = goal;
    }

    // override for buy function
    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
        uint256 currentRate = getCurrentRate(_initialRate, _finalRate, weiRaised(), _goal);
        return currentRate.mul(weiAmount);
    }

    function getCurrentRate(uint256 initialRate, uint256 finalRate, uint256 weiRaised, uint256 goal) internal pure returns (uint256) {
        uint256 range;
        uint256 midrate;

        /// rate range
        range = initialRate - finalRate;

        /// if goal has been met, the rate is the final rate
        // if (goalReached) {
        //     return finalRate;
        // }
        
        /// if weiRaised = 0, the initial rate should be used
        if (weiRaised == 0) {
            return initialRate;
        }

        /// otherwise calculate rate based on amount of goal raised
        else {
            midrate = initialRate - ((weiRaised * range) / goal);
            return midrate;
            }
    } 
    
}

contract UnbrokenTokenCrowdsaleDeployer {
    // Create an `address public` variable called `unbrokenTokenAddress`.
    address public unbrokenTokenAddress;
    // Create an `address public` variable called `unbrokenCrowdsaleAddress`.
    address public unbrokenCrowdsaleAddress;
    //Create an 'address public' variable called 'movingRateAddress'
    // address public movingRateAddress;

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

        //Create a new instance of the MovingRate contract.
        //MovingRate movingRate = new MovingRate(10, 1, 0, goal);

        //Assign 'MovingRate' contract address to variable.
        //movingRateAddress = address(movingRate);

        // Create a new instance of the `UnbrokenTokenCrowdsale` contract
        UnbrokenTokenCrowdsale unbrokenCrowdsale = new UnbrokenTokenCrowdsale(10, 10, 1, wallet, token, goal, now, now + 120 minutes);
            
        // Aassign the `UnbrokenTokenCrowdsale` contract’s address to the `unbrokenCrowdsaleAddress` variable.
        unbrokenCrowdsaleAddress = address(unbrokenCrowdsale);

        // Set the `UnbrokenTokenCrowdsale` contract as a minter
        token.addMinter(unbrokenCrowdsaleAddress);
        
        // Have the `UnbrokenTokenCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }
}