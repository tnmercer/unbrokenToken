pragma solidity ^0.5.0;

import "./unbrokenToken.sol";
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
    uint256 private _initialRate; // the initial rate of tokens per TKNbit
    uint256 private _finalRate; // the final rate of tokens per TKNbit

    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        // uint256 rate, // rate in TKNbits - commented out to test increasing rate
        address payable wallet, // sale beneficiary
        UnbrokenToken token, // the UnbrokenToken itself that the UnbrokenTokenCrowdsale will work with
        uint goal, // the crowdsale goal
        uint open, // the crowdsale opening time
        uint close, // the crowdsale closing time
        uint256 initialRate, // the initial rate of tokens per TKNbit
        uint256 finalRate // the final rate of tokens per TKNbit
    ) public
        Crowdsale(initialRate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
    {
        // constructor can stay empty
        require(initialRate >= finalRate);
        require(finalRate > 0);
        _initialRate = initialRate; 
        _finalRate = finalRate;
    }
    /**
     * The base rate function is overridden to revert, since this crowdsale doesn't use it, and
     * all calls to it are a mistake.
     */
    function rate() public view returns (uint256) {
        revert("IncreasingPriceCrowdsale: rate() called");
    }

    /**
     * @return the initial rate of the crowdsale.
     */
    function initialRate() public view returns (uint256) {
        return _initialRate;
    }

    /**
     * @return the final rate of the crowdsale.
     */
    function finalRate() public view returns (uint256) {
        return _finalRate;
    }

    /**
     * @dev Returns the rate of tokens per wei at the present time.
     * Note that, as price _increases_ with time, the rate _decreases_.
     * @return The number of tokens a buyer gets per wei at a given time
     */
    function getCurrentRate() public view returns (uint256) {
        if (!isOpen()) {
            return 0;
        }
        if (weiRaised() = 0){
            return _initialRate;
        }

        // solhint-disable-next-line not-rely-on-time
        uint256 elapsedTime = block.timestamp.sub(openingTime());
        uint256 timeRange = closingTime().sub(openingTime());
        uint256 rateRange = _initialRate.sub(_finalRate);
        return _initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
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
        UnbrokenTokenCrowdsale unbrokenCrowdsale = new UnbrokenTokenCrowdsale(wallet, token, goal, now, now + 120 minutes, 10, 1);
            
        // Aassign the `UnbrokenTokenCrowdsale` contract’s address to the `unbrokenCrowdsaleAddress` variable.
        unbrokenCrowdsaleAddress = address(unbrokenCrowdsale);

        // Set the `UnbrokenTokenCrowdsale` contract as a minter
        token.addMinter(unbrokenCrowdsaleAddress);
        
        // Have the `UnbrokenTokenCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }
}