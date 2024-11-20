import web3
from web3 import Web3
from eth_utils import keccak, to_bytes, to_checksum_address
from eth_account import Account
import rlp
from rlp.sedes import big_endian_int, binary, CountableList, List

w3 = Web3(Web3.HTTPProvider(ALCHEMY_MAINNET_ENDPOINT))

def getSignature(tx):
  if tx['type'] == 0:
    recovery_id = tx.v - 27 if tx.v in (27, 28) else (tx.v - 35) % 2
  else:
    recovery_id = tx.v
  s = w3.eth.account._keys.Signature(vrs=(
    recovery_id,
    w3.to_int(tx.r),
    w3.to_int(tx.s)
  ))
  return s

def getHashedMessage(tx):
  # Access fields manually
  chain_id = tx['chainId'] if 'chainId' in tx else 1
  nonce = tx['nonce']
  max_priority_fee_per_gas = tx['maxPriorityFeePerGas'] if 'maxPriorityFeePerGas' in tx else -1
  max_fee_per_gas = tx['maxFeePerGas'] if 'maxFeePerGas' in tx else -1
  gasPrice = tx['gasPrice'] if 'gasPrice' in tx else -1
  gasLimit = tx['gas']
  to = to_bytes(hexstr=tx['to']) if tx['to'] else b''
  value = tx['value']
  data = to_bytes(hexstr=tx['input'].hex())
  access_list = tx['accessList'] if 'accessList' in tx else []

  tx_type = to_bytes(tx['type'])

  if tx['type'] == 0:
    if tx.v in [27, 28]:
      fields_values = [
        nonce,
        gasPrice,
        gasLimit,
        to,
        value,
        data
      ]

      fields_sedes = [
        big_endian_int,  # nonce
        big_endian_int,  # gasPrice
        big_endian_int,  # gasLimit
        binary,          # to
        big_endian_int,  # value
        binary,          # input
      ]

      encoded_transaction = rlp.encode(fields_values, sedes=List(fields_sedes))

    else:
      chain_id = int((tx.v - 35)/2)

      fields_values = [
        nonce,
        gasPrice,
        gasLimit,
        to,
        value,
        data,
        chain_id, 0, 0
      ]

      fields_sedes = [
        big_endian_int,  # nonce
        big_endian_int,  # gasPrice
        big_endian_int,  # gasLimit
        binary,          # to
        big_endian_int,  # value
        binary,          # input
        big_endian_int, big_endian_int, big_endian_int, # chainid, 0, 0
      ]

      encoded_transaction = rlp.encode(fields_values, sedes=List(fields_sedes))

  if tx['type'] == 1:
    fields_values = [
      chain_id,
      nonce,
      gasPrice,
      gasLimit,
      to if to else b'',  # Address (as bytes) or empty
      value,
      data if data else b'',  # Data (as bytes) or empty
      access_list
    ]

    fields_sedes = [
      big_endian_int,  # chainId
      big_endian_int,  # nonce
      big_endian_int,  # gasPrice
      big_endian_int,  # gasLimit
      binary,          # to
      big_endian_int,  # value
      binary,          # input
      CountableList(List([binary, CountableList(List([binary, big_endian_int]))]))  # accessList
    ]

    encoded_transaction = rlp.encode(fields_values, sedes=List(fields_sedes))

  elif tx['type'] == 2:
    # Convert fields to appropriate types
    fields_values = [
      chain_id,
      nonce,
      max_priority_fee_per_gas,
      max_fee_per_gas,
      gasLimit,
      to if to else b'',  # Address (as bytes) or empty
      value,
      data if data else b'',  # Data (as bytes) or empty
      access_list
    ]

    # Define sedes for encoding
    fields_sedes = [
      big_endian_int,  # chainId
      big_endian_int,  # nonce
      big_endian_int,  # maxPriorityFeePerGas
      big_endian_int,  # maxFeePerGas
      big_endian_int,  # gas
      binary,          # to
      big_endian_int,  # value
      binary,          # input
      CountableList(List([binary, CountableList(List([binary, big_endian_int]))]))  # accessList
    ]

    # RLP encode the transaction fields
    encoded_transaction = rlp.encode(fields_values, sedes=List(fields_sedes))

  # Prepend the transaction type for post EIP-2718 transactions
  if tx['type'] != 0: # TODO: Check if this is correct for EIP-2718 transactions
    message_hash = keccak(tx_type + encoded_transaction)
  else:
    message_hash = keccak(encoded_transaction)

  return message_hash


def test():
  for tx_hash in ['0xbce377a6224d4033ee72c1daa0073fd5c4ce16dac18b8d93439a725c2d7cad37',
             '0xe306e27a540b08da849442942033ed7b6feb2844eee625169615acccf5f6c318',
             '0x7d24901b513b0693911f272dc73e3f2f6627b7289428de0b64e89939b6b01175',
             '0xb385a7dec7ce9f02fa57c07f7ed88f44864dfc8449e5a4f768f96a32e606ae74'
             ]:
    
    # tx_hash = '0xbce377a6224d4033ee72c1daa0073fd5c4ce16dac18b8d93439a725c2d7cad37'
    
    tx = w3.eth.get_transaction(tx_hash)

    # encoded_with_type = getHashedMessage(tx)
    
    sig = getSignature(tx)

    message_hash = getHashedMessage(tx)
    print(f"Message Hash: {message_hash.hex()}")

    public_key = sig.recover_public_key_from_msg_hash(message_hash)

    if sig.verify_msg_hash(message_hash, public_key):
      print("Signature is valid")
    else:
      print("Signature is invalid")

    print(f"Public Key: {public_key}")
    print(f"Address: {public_key.to_checksum_address()}")


def ethereum_to_noir(address):
  # Remove the "0x" prefix
  if address.startswith("0x"):
      address = address[2:]
  # Split the address into pairs of hexadecimal digits
  bytes_list = [address[i:i+2] for i in range(0, len(address), 2)]
  # Prefix each byte with "0x"
  noir_address = [f"'0x{byte}'" for byte in bytes_list]
  return noir_address


def __main__():

  # test()

  tx_hash = '0xb385a7dec7ce9f02fa57c07f7ed88f44864dfc8449e5a4f768f96a32e606ae74'
  tx = w3.eth.get_transaction(tx_hash)
  message_hash = getHashedMessage(tx)

  sig = getSignature(tx)
  public_key = sig.recover_public_key_from_msg_hash(message_hash)
  if sig.verify_msg_hash(message_hash, public_key):
      print("Signature is valid")
  else:
      print("Signature is invalid")


  CHAIN_ID = 1
  BLOCK_NO = 19421720
  TX_IDX = 291

  FROM_ADDRESS = "0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB"
  TO_ADDRESS = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
  TX_HASH = "0xb385a7dec7ce9f02fa57c07f7ed88f44864dfc8449e5a4f768f96a32e606ae74"

  noir_repr_pub_key = ethereum_to_noir(public_key.to_hex())
  pub_key_x = noir_repr_pub_key[:32]
  pub_key_y = noir_repr_pub_key[32:]
  print(pub_key_x)
  print(pub_key_y)

  noir_repr_hashed_message = ethereum_to_noir(message_hash.hex())
  print(noir_repr_hashed_message)
  
  noir_repr_signature = ethereum_to_noir(sig.to_non_recoverable_signature().to_hex())
  print(noir_repr_signature)

  output = f"""chain_id = "{CHAIN_ID}"
block_number = "{BLOCK_NO}"
tx_idx = "{TX_IDX}"
from_address = "{FROM_ADDRESS}"
to_address = "{TO_ADDRESS}"
pub_key_x = [{', '.join(pub_key_x)}]
pub_key_y = [{', '.join(pub_key_y)}]
hashed_message = [{', '.join(noir_repr_hashed_message)}]
signature = [{', '.join(noir_repr_signature)}]
"""

  with open("Prover.toml", "w") as text_file:
      text_file.write(output)


if __name__ == "__main__":
  __main__()
