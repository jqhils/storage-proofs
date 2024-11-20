use dep::ethereum::account::{get_account, AccountWithinBlock};
use dep::ethereum::misc::types::Address;

fn main(
    chain_id: pub Field,
    block_no_1: pub u64,
    block_no_2: pub u64,
    address: pub Address // [u8; 20]
// ) -> pub (u64, u64) {
) {
    let block_1_result: AccountWithinBlock = get_account(chain_id, block_no_1, address);
    let block_2_result: AccountWithinBlock = get_account(chain_id, block_no_2, address);

    assert(
        block_1_result.account.nonce != block_2_result.account.nonce, "Nonce should be different in two blocks"
    );
    // (block_1_result.account.nonce, block_2_result.account.nonce)
}
