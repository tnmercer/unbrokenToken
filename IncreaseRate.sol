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

        else {
            midrate = _rate - ((_weiRaised * range) / _goal);
            return midrate;
            }
    } 
    
    
    /// returns current rate
    
}

