# Unbroken Token (UBT)

Unbroken Token (UBT) is an ERC-20 token created with Solidity and Remix and tested using Ganache. The purpose of this project is to allow users to purchase a bond-like token that pays out on a monthly basis. The funds raised from the crowdsale are collected into a single wallet and staked with the earnings paid out to UBT holders.

New token creation 
* Solidity & remix
* Hardcode initial supply, name and code

ICO
* Explore different launch strategies
    * Launch price graduates by batch
    * Launch price graduates by time

Streamlit App
* Countdown? 
* Pool size display? 
* Purchase and sale functions
* Details of ICO and strategy status, e.g. "50,000 coins left at X eth, the next price will be Y" (or whichever strategy is used)

Basis of Token - The gambling game
* Strategy similar to UK premium bonds (but much riskier!)
    * purchase a token (acts like an ticket) with eth
    * receive a token of UBT
    * eth collected in a central account and staked 
    * earnings from staking paid into central account
    * each month (day/week?) the earnings in central account are paid out to random 5% (+-) of UBT token holders

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

3. Populate the example.env file with the relevant project info. The RPC server can be found in Ganache and the deployed contract address can be found in Remix after deployment.

```
    WEB3_PROVIDER_URI = "GANACHE RPC SERVER ADDRESS"
    SMART_CONTRACT_ADDRESS = "DEPLOYED UNBROKENTOKEN ADDRESS"
    SMART_CONTRACT_ADDRESS2 = "DEPLOYED UNBROKENTOKENCROWDSALE ADDRESS"
```

4. Delete the "example" from the example.env file to create a .env file for usage with the program.

5. Navigate to the directory containing "app.py" and run the following command:

    `streamlit run app.py`

6. 

---

## Contributors

Brought to you by:
* [Dan](https://github.com/dandmcqueen)
* [Jason](https://github.com/jasonbucks)
* [Majid](https://github.com/MajidKouki)
* [Ragini](https://github.com/ragininegi)
* [Steven](https://github.com/steviej00)
* [Toni](https://github.com/tnmercer)
