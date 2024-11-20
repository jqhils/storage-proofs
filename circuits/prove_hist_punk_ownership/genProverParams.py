from web3 import Web3
import os
from dotenv import load_dotenv

env_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), '.env')

# Load the .env file
load_dotenv(dotenv_path=env_path)

ALCHEMY_MAINNET_ENDPOINT = os.getenv("ETHEREUM_JSON_RPC_API_URL")
w3 = Web3(Web3.HTTPProvider(ALCHEMY_MAINNET_ENDPOINT))

# Account address and the slot number for the balanceOf mapping
account_address = '0x0000000000000000000000000000000000000000'
account_address_padded = w3.to_checksum_address(account_address)
account_address_padded = account_address_padded.lower().replace('0x', '').rjust(64, '0')  # Pad to 32 bytes

balance_of_mapping_slot = 11
slot_hex = hex(balance_of_mapping_slot).replace('0x', '').rjust(64, '0')

# Calculate the storage key using keccak
storage_key = w3.solidity_keccak(
    ['bytes32', 'bytes32'],
    [bytes.fromhex(account_address_padded), bytes.fromhex(slot_hex)]
)

print(f"Calculated storage slot: {storage_key.hex()}")

def ethereum_to_noir(address):
    # Remove the "0x" prefix
    if address.startswith("0x"):
        address = address[2:]

    # Split the address into pairs of hexadecimal digits
    bytes_list = [address[i:i+2] for i in range(0, len(address), 2)]
    
    # Prefix each byte with "0x"
    noir_address = [f"'0x{byte}'" for byte in bytes_list]
    
    return noir_address

CHAIN_ID = 1
BLOCK_NO = 20366847
STORAGE_KEY = storage_key.hex()
ETHEREUM_ADDRESS = "0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB"
OWNER_ADDRESS = account_address

output = f"""chain_id = "{CHAIN_ID}"
block_number = "{BLOCK_NO}"
punk_address = [{', '.join(ethereum_to_noir(ETHEREUM_ADDRESS))}]
owner_address = [{', '.join(ethereum_to_noir(OWNER_ADDRESS))}]
storage_key = [{', '.join(ethereum_to_noir(STORAGE_KEY))}]
"""

with open("Prover.toml", "w") as text_file:
    text_file.write(output)