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
BLOCK_NO_1 = 20366847
BLOCK_NO_2 = 20366850
ETHEREUM_ADDRESS = "0x9DDC763dF398f9B4eA92d040a00723E08808579C"


noir_representation = ethereum_to_noir(ETHEREUM_ADDRESS)


output = f"""chain_id = "{CHAIN_ID}"
block_no_1 = "{BLOCK_NO_1}"
block_no_2 = "{BLOCK_NO_2}"
address = [{', '.join(noir_representation)}]
"""

with open("Prover.toml", "w") as text_file:
    text_file.write(output)