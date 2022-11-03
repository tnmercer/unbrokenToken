pragma solidity ^0.5.0;

import "./UnbrokenToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";


// Have the UnbrokenTokenCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale - to allow the crowdsale to mint tokens as purchased
// * CappedCrowdsale - to set a limit on the number of tokens issued
// * TimedCrowdsale - to close the crowdsale after set time
// * RefundableCrowdsale - to refund all buyers if goal not met
// * PostDeliveryCrowdsale - to delay delivery of tokens until crowdsale closed

// UPDATED THE CONTRACT SIGNATURE TO ADD THE ABOVE INHERITANCE
contract UnbrokenTokenCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale, PostDeliveryCrowdsale { 
    address payable _wallet; // crowdsale wallet to pass to the transfer deployer
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
        uint256 goal, // the crowdsale goal
        uint open, // the crowdsale opening time
        uint close // the crowdsale closing time
    ) public
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
        PostDeliveryCrowdsale() 
    {
        // assign variables for use in functions
        _rate = rate;
        _initialRate = initialRate;
        _finalRate = finalRate;
        _goal = goal;
        _wallet = wallet;
    }

    // override for buy function to change rate
    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
        uint256 currentRate = getCurrentRate();
        return currentRate.mul(weiAmount);
    }

    // function to calculate current rate based on progress of crowdsale
    function getCurrentRate() public view returns (uint256) {
        //uint256 initialRate, uint256 finalRate, uint256 weiRaised, uint256 goal
        uint256 range;
        uint256 midrate;

        /// rate range
        range = _initialRate - _finalRate;     
        
        /// if weiRaised = 0, the initial rate should be used
        if (weiRaised() == 0) {
            return _initialRate;
        }

        /// otherwise calculate rate based on amount of goal raised
        else {
            midrate = _initialRate - ((weiRaised() * range) / _goal);
            return midrate;
            }
    }      
}


contract UnbrokenTokenCrowdsaleDeployer {
    // Create an `address public` variable called `unbrokenTokenAddress`.
    address public unbrokenTokenAddress;
    // Create an `address public` variable called `unbrokenCrowdsaleAddress`.
    address public unbrokenCrowdsaleAddress;
    //Create an 'address public' variable called 'payoutInterestAddress'
    address public payoutInterestAddress;

    // Add the constructor.
    constructor(
       string memory name,
       string memory symbol,
       address payable wallet,
       uint256 initialSupply,
       uint256 goal
    ) public {
        // Create a new instance of the UnbrokenToken contract.
        UnbrokenToken token = new UnbrokenToken(name, symbol, initialSupply);
        
        // Assign the token contract’s address to the `unbrokenTokenAddress` variable.
        unbrokenTokenAddress = address(token);

        // Create a new instance of the `UnbrokenTokenCrowdsale` contract
        UnbrokenTokenCrowdsale unbrokenCrowdsale = new UnbrokenTokenCrowdsale(10, 10, 1, wallet, token, goal, now, now + 5 minutes);
            
        // Aassign the `UnbrokenTokenCrowdsale` contract’s address to the `unbrokenCrowdsaleAddress` variable.
        unbrokenCrowdsaleAddress = address(unbrokenCrowdsale);

        // Create a new instance of the PayoutInterest contract.
        PayoutInterest _payoutInterest = new PayoutInterest(wallet);

        // Assign 'p' contract address to variable.
        payoutInterestAddress = address(_payoutInterest);
        
        // Set the `UnbrokenTokenCrowdsale` contract as a minter
        token.addMinter(unbrokenCrowdsaleAddress);
        
        // Have the `UnbrokenTokenCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }
}

contract PayoutInterest {
    using SafeMath for uint;
    address payable unbrokenWallet;
    // uint _divideRate = 0;
    address payable[] recipients;

    // on construction assign the wallet address of Unbroken Token business account (collecting and distributing eth)
    constructor (address payable wallet) public {
        unbrokenWallet = wallet;
        }
    // / function setPayoutRate(uint divideRate) public returns (uint) {
    //     require(msg.sender == unbrokenWallet, "Do not pass go, do not collect $200!");
    //     _divideRate = divideRate;
    //     return _divideRate;
    // }

    function addRecipient(address payable recipient) public {
        require(msg.sender == unbrokenWallet, "Do not pass go, do not collect $200!");
        recipients.push(recipient);
    }

    function viewRecipients() public view returns(address payable[] memory) {
        return recipients;
    }

    function getPayoutRate() public view returns(uint) {
        return recipients.length;
    }
    function payOut() public payable {
        // REQUIRE OWNER = MSG.SENDER
        require(msg.sender == unbrokenWallet, "Do not pass go, do not collect $200!");
        // transfer percentage to recipient
        for (uint i = 0; i < recipients.length; i++){
            recipients[i].transfer(msg.value.div(recipients.length));
        }
    }
}