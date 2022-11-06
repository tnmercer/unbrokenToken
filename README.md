# Unbroken Token (UBT)

Unbroken Token (UBT) is an ERC-20 token created with Solidity on Remix IDE and tested using Ganache and MetaMask. 

Implementation is through Streamlit.

The purpose of this token is to allow users to purchase a bond-like token that maintains value and pays out earnings on a monthly basis. 

The funds raised from the crowdsale (and any future purchases) are collected into a single wallet and staked. The earnings from staking are pooled and paid out to random UBT token holders.

The crowdsale is:
* Mintable
* Capped
* Timed
* Refundable
* Tokens delivered post crowdsale close
* Graduated token rate based on progress of goal reached

The payout contract is manageable only by the UBT business account.

---

## Technologies

This project leverages Python with the following packages:

* [Streamlit](https://github.com/streamlit/streamlit) - For deploying the app.

* [dotenv](https://pypi.org/project/python-dotenv/) - For accessing the .env file.

* [Web3](https://github.com/ethereum/web3.py) - For Web3, HTTPProvider, and contract.

As well as Solidity using the following:

* [OpenZeppelin-Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts) - For Crowdsale & ERC20.

This project also uses the Remix IDE and Ganache for testing and compilation.

---

## Installation Guide

Before first running the application it may be necessary to install the following dependencies:

```python
    pip install web3
    pip install streamlit
    pip install python-dotenv
```

A .env file is also required to run this program. An example .env file is provided and requires the following fields to be populated:

```
    WEB3_PROVIDER_URI = "GANACHE RPC SERVER ADDRESS"
    SMART_CONTRACT_ADDRESS = "DEPLOYED UNBROKENTOKEN ADDRESS"
    SMART_CONTRACT_ADDRESS2 = "DEPLOYED UNBROKENTOKENCROWDSALE ADDRESS"
```

Afterwards, deleting the example from the filename will result in the file becoming a .env and being usable for this project.

Ganache and Remix IDE are necessary for this project as well. Remixe IDE can be accessed from the web while Ganache must be downloaded from [here](https://trufflesuite.com/ganache/).

---

## Usage

The following steps provide detailed instructions to prepare and use the project.

1. Startup Remix IDE in directory containing project files and Ganache workspace.

2. If necessary compile contracts in project directory and deploy the UnbrokenTokenCrowdsaleDeployer smart contract which intakes the following variables:
    * Name - Unbroken Token
    * Symbol - UBT
    * Wallet - Wallet receiving funds from crowdsale
    * Initial Supply - Initial supply of UBT
    * Goal - Crowdsale goal

4. The deployer contract will deploy 3 contracts:
    * UnbrokenToken is the token
    * UnbrokenTokenCrowdsale is the crowdsale
    * PayoutInterest manages the earnings payouts each month

3. Populate the example.env file with the relevant project info. The RPC server can be found in Ganache and the deployed contract address can be found in Remix after deployment. The deployer contract will provide both the addresses needed after being deployed.

```
    WEB3_PROVIDER_URI = "GANACHE RPC SERVER ADDRESS"
    SMART_CONTRACT_ADDRESS = "DEPLOYED UNBROKENTOKEN ADDRESS"
    SMART_CONTRACT_ADDRESS2 = "DEPLOYED UNBROKENTOKENCROWDSALE ADDRESS"
```

4. Delete the "example" from the example.env file to create a .env file for usage with the program.

5. Navigate to the directory containing "app.py" and run the following command:

    `streamlit run app.py`

6.  Once the app has launched, there will be a sidebar and 3 columns. The sidebar is dedicated to contract calls relating to the crowdsale while the body contains all the necessary user functionality. Column 1 allows selecting the owner address as well as purchasing tokens, which will print a receipt in the 3rd column. The 2nd (middle) column contains contract calls for the token itself and will print the results just below the button.

---

## Future Dev

* Create contract to manage the selection of token holders for monthly payout - increased transparency
* Use API to blockchain for token holder accounts
* Further develop streamlit to run all functionality
* Run node to stake eth directly without third party provider

---

## Contributors

Brought to you by:
* [Dan](https://github.com/dandmcqueen)
* [Jason](https://github.com/jasonbucks)
* [Majid](https://github.com/MajidKouki)
* [Ragini](https://github.com/ragininegi)
* [Steven](https://github.com/steviej00)
* [Toni](https://github.com/tnmercer)
