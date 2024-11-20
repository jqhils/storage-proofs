use dep::ethereum::{account_with_storage::{get_account_with_storage, StorageWithinBlock}, misc::types::{Address, Bytes32}};
use dep::ethereum::uint256::U256;
use dep::std::hash::keccak256;

fn calculate_storage_key (
    hash_1: [u8; 32],
    hash_2: [u8; 32],
) -> [u8; 32] {
    let mut result: [u8; 64] = [0; 64];
    for i in 0..32 {
        result[i] = hash_1[i];
    }
    for i in 0..32 {
        result[32+i] = hash_2[i];
    }

    keccak256(result, 64)
}

fn main(
    chain_id: pub Field,
    block_number: pub u64,
    punk_address: pub Address,
    owner_address: pub Address,
    storage_key: pub Bytes32
) -> pub U256 {
    let mut BALANCE_OF_MAPPING_SLOT: [u8; 32] = [0x00; 32];
    BALANCE_OF_MAPPING_SLOT[31] = 0x0b;

    let mut padded_owner_address: [u8; 32] = [0x00; 32];
    for i in 0..20 {
        padded_owner_address[12+i] = owner_address[i];
    }

    let calculated_storage_key = calculate_storage_key(padded_owner_address, BALANCE_OF_MAPPING_SLOT);

    assert(calculated_storage_key == storage_key, "Storage key does not match the expected value");

    let account_with_storage: StorageWithinBlock<1> = get_account_with_storage(chain_id, block_number, punk_address, storage_key);
    let punk_balance: U256 = U256::from(account_with_storage.values[0]);

    assert(punk_balance != U256::zero(), "Expected balance value to be non-zero");
    punk_balance
}