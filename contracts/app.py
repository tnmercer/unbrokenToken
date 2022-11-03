#Required libraries and depencencies 
import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st
import time
from PIL import Image
load_dotenv()

#Define and connect a WEB3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))

################################################################################
# Contract Helper function:
# 1. Loads the contract once using cache
# 2. Connects to the contract using the contract address and ABI
################################################################################

st.cache(allow_output_mutation=True)
def load_contract():

    # Load the contract ABI
    with open(Path("C:\\Users\\steve\\Desktop\\unbrokenToken\\unbrokenToken\\contracts\\compiled\\ubtoken_abi.json")) as f:
        ubtoken_abi = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("SMART_CONTRACT_ADDRESS")

    # Get the contract
    contract = w3.eth.contract(
        address=contract_address,
        abi= ubtoken_abi
    )

    return contract

# Load the contract
contract = load_contract()

################################################################################
# Register New Artwork
################################################################################

#Tried uploading introductry video to streamlit.
#st.video("https:\\www.canva.com\\design/DAFQpjffewI\\kocMw1yT_vCC98hKxFOUng/watch?utm_content=DAFQpjffewI&utm_campaign=designshare&utm_medium=link&utm_source=publishsharelink")

#Tried uploading unbroken image.
#unbroken_logo= Image.open('images\\ubtlogo.png')

st.sidebar.selectbox("UBT Crowdsale", ["Learn more", "Buy Tokens"])


video_file = open('ubtkenvid(2).mp4', 'rb')
video_bytes = video_file.read()

st.video(video_bytes)

font="monospace"

st.title("Unbroken Token")
accounts = w3.eth.accounts

address = st.selectbox("Select Owner Address", options=accounts)
token_uri= st.text_input("Token URI")

# Fucntions
if st.button("Register Account"):

    tx_hash = contract.functions.registerAddress(address, token_uri).transact({'from': address, 'gas': 1000000})

    receipt = w3.eth.waitForTransactionReceipt(tx_hash)

    st.write("Transaction receipt mined:")

    st.write(dict(receipt))

st.markdown("---")

token_id = int(st.text_input("Token ID (uint256)",value=0))

if st.button("Approve"):

    tx_hash = contract.functions.approve(address, token_id).transact({'from': address, 'gas': 1000000})
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))

st.markdown("---")

boolean = bool(st.text_input("Boolean",value=True))

if st.button("Set Approval for All"):

    tx_hash = contract.functions.setApprovalForAll(address, boolean).transact({'from': address, 'gas': 1000000})
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))

st.markdown("---")

address1 = st.selectbox("Select Owner Address 1", options=accounts)
address2 = st.selectbox("Select Owner Address 2 ", options=accounts)
token_id = int(st.text_input("Token ID (uint256) ",value=0))

if st.button("Safe Transfer From"):

    tx_hash = contract.functions.safeTransferFrom(address1,address2,token_id).transact({'from': address, 'gas': 1000000})
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))

st.markdown("---")

#boolean = bool(st.text_input("Boolean",value=True))

##address2 = st.selectbox("Select Owner Address 2", options=accounts)

#if st.button("Approval For All"):

    #tx_hash = contract.functions.setApprovalForAll(address,boolean).transact({'from': address, 'gas': 1000000})
    #receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    #st.write("Transaction receipt mined:")
    #st.write(dict(receipt))

#st.markdown("---")
