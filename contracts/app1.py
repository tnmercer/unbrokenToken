#Required libraries and depencencies 
import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st
import time
from PIL import Image
from multiprocessing import Process
import streamlit as st
import signal

load_dotenv()

#Define and connect a WEB3 provider
w3 = Web3(Web3.HTTPProvider("HTTP://127.0.0.1:7545"))

st.cache(allow_output_mutation=True)

def load_contract():

    # Load the contract ABI
    with open(Path("C:\\Users\\steve\\Desktop\\unbrokenToken\\unbrokenToken\\contracts\\compiled\\ubtoken_abi.json")) as f:
        ubtoken_abi = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("SMART_CONTRACT_ADDRESS") # UNBROKENTOKEN 

    # Get the contract
    contract = w3.eth.contract(
        address=contract_address,
        abi= ubtoken_abi
    )

    return contract

# Load the contract
contract = load_contract()

def load_contract2():

    # Load the contract ABI
    with open(Path("C:\\Users\\steve\\Desktop\\unbrokenToken\\unbrokenToken\\contracts\\compiled\\ubtoken_abi2.json")) as f:
        ubtoken_abi = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("SMART_CONTRACT_ADDRESS2") # UNBROKENTOKENCROWDSALE 

    # Get the contract
    contract = w3.eth.contract(
        address=contract_address,
        abi= ubtoken_abi
    )

    return contract

# Load the contract
contract2 = load_contract2()

##################################################################################################################

#Header
st.title("Unbroken Token")
accounts = w3.eth.accounts

#Home page logo
video_file = open('ubtkenvid(2).mp4', 'rb')
video_bytes = video_file.read()
st.video(video_bytes)
st.markdown("---")

#Input user account address
st.header("Owner Address")
address = st.selectbox("Select Owner Address", options=accounts)
st.markdown("---")


##################################################################################################################

# Contract 2 UNBROKENTOKENCROWDSALE 


st.header("Unbroken Crowdsale Deployer")

st.subheader("Buy Tokens")
address2 = st.selectbox("Select Recepient Address", options=accounts[1:])
amount = int(st.text_input("Input wei amount to buy", value=1))
if st.button("Buy Tokens"):
    tx_hash = contract2.functions.buyTokens(address2).transact({'from': address, 'gas': 1000000, 'value':amount})
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write("Transaction Processed:")
    st.write(dict(receipt))
    st.balloons()
st.markdown("---")

st.sidebar.header("Unbroken Crowdsale Contract")
st.sidebar.subheader("Calls")

if st.sidebar.button("Cap"):
    cap = contract2.functions.cap().call()
    st.sidebar.write(f"{cap}")

if st.sidebar.button("Cap Reached"):
    cap = contract2.functions.capReached().call()
    st.sidebar.write(f"{cap}")

if st.sidebar.button("Closing Time"):
    closingTime = contract2.functions.closingTime().call()
    st.sidebar.write(f"{closingTime}")

if st.sidebar.button("Finalized"):
    finalized = contract2.functions.finalized().call()
    st.sidebar.write(f"{finalized}")

if st.sidebar.button("Goal"):
    goal = contract2.functions.goal().call()
    st.sidebar.write(f"{goal}")

if st.sidebar.button("Goal Reached"):
    goalReached = contract2.functions.goalReached().call()
    st.sidebar.write(f"{goalReached}")

if st.sidebar.button("Has Closed"):
    hasClosed = contract2.functions.hasClosed().call()
    st.sidebar.write(f"{hasClosed}")

if st.sidebar.button("Is Open"):
    isOpen = contract2.functions.isOpen().call()
    st.sidebar.write(f"{isOpen}")

if st.sidebar.button("Opening Time"):
    openingTime = contract2.functions.openingTime().call()
    st.sidebar.write(f"{openingTime}")

if st.sidebar.button("Rate"):
    rate = contract2.functions.rate().call()
    st.sidebar.write(f"{rate}")

if st.sidebar.button("Token"):
    token = contract2.functions.token().call()
    st.sidebar.write(f"{token}")

if st.sidebar.button("Wallet"):
    wallet = contract2.functions.wallet().call()
    st.sidebar.write(f"{wallet}")

if st.sidebar.button("Wei Raised"):
    weiRaised = contract2.functions.weiRaised().call()
    st.sidebar.write(f"{weiRaised}")

##############################################################

# Contract 1
st.header("Unbroken Crowdsale Token Contract")

st.subheader("Calls")

if st.button("Balance Of"):
    balanceOf = contract.functions.balanceOf(address2).call()
    st.write(f"{balanceOf}")
st.markdown("---")

if st.button("Decimals"):
    decimals = contract.functions.decimals().call()
    st.write(f"{decimals}")
st.markdown("---")

if st.button("Name"):
    name = contract.functions.name().call()
    st.write(f"{name}")
st.markdown("---")

if st.button("Is Minter"):
    isMinter = contract.functions.isMinter(address).call()
    st.write(f"{isMinter}")
st.markdown("---")

if st.button("Symbol"):
    symbol = contract.functions.symbol().call()
    st.write(f"{symbol}")
st.markdown("---")

if st.button("Total Supply"):
    total_supply = contract.functions.totalSupply().call()
    st.write(f"{total_supply}")
st.markdown("---")