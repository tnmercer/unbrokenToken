pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/c4bb7b7bb9f09534bf010f6bf6f0d85bf2bf1caa/contracts/math/SafeMath.sol";


contract CurrentRate {
    uint256 _rate; /// initial rate
    uint256 _finalRate; /// final rate
    //address _crowdsale; // address of the Unbroken Token crowdsale
    address _token; // address of the Unbroken Token token
    uint256 _totalSupply; // current total supply of token
    uint256 _weiRaised; // wei raised so far in crowdsale
    uint256 _goal; //goal of crowdsale

    constructor(uint256 rate, uint256 finalRate, uint256 weiRaised, uint256 goal) public {
        _rate = rate;
        _finalRate = finalRate;
        _weiRaised = weiRaised;
        _goal = goal;
    }

    /// token rate range
    /// instructions to change over time
    function currentRate() public view returns (uint256) {
        uint256 range;
        uint256 midrate;

        /// rate range
        range = _rate - _finalRate;

        /// if goal has been met, the fate is the final rate
        if (_weiRaised == _goal) {
            return _finalRate;
        }
        
        /// if weiRaised = 0, the rate should be used
        if (_weiRaised == 0) {
            return _rate;
        }

        /// This needs to be adjusted because of integer handling

        // else {
        //     midrate = uint(1) - (_weiRaised / _goal) * range + uint(1);
        //     return midrate;
        //     }
    } 
    
    /// returns current rate
    
}


// require(initialRate >= finalRate);
//         require(finalRate > 0);
//         _initialRate = initialRate; 
//         _finalRate = finalRate;

//         /**
//      * The base rate function is overridden to revert, since this crowdsale doesn't use it, and
//      * all calls to it are a mistake.
//      */
//     function rate() public view returns (uint256) {
//         revert("IncreasingPriceCrowdsale: rate() called");
//     }

//     /**
//      * @return the initial rate of the crowdsale.
//      */
//     function initialRate() public view returns (uint256) {
//         return _initialRate;
//     }

//     /**
//      * @return the final rate of the crowdsale.
//      */
//     function finalRate() public view returns (uint256) {
//         return _finalRate;
//     }

//     /**
//      * @dev Returns the rate of tokens per wei at the present time.
//      * Note that, as price _increases_ with time, the rate _decreases_.
//      * @return The number of tokens a buyer gets per wei at a given time
//      */
//     function getCurrentRate() public view returns (uint256) {
//         if (!isOpen()) {
//             return 0;
//         }
//         // if (weiRaised() = 0){
//         //     return _initialRate;
//         // }

//         // solhint-disable-next-line not-rely-on-time
//         uint256 elapsedTime = block.timestamp.sub(openingTime());
//         uint256 timeRange = closingTime().sub(openingTime());
//         uint256 rateRange = _initialRate.sub(_finalRate);
//         return _initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
//     }