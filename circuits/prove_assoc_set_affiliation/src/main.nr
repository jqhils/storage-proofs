use dep::ethereum::receipt::{get_receipt, TxReceiptWithinBlock};
use dep::ethereum::transaction::{
    get_transaction, get_transaction_oracle, get_transaction_unconstrained_M, TxPartial, TxType,
    TransactionWithinBlock, ForeignCallTransaction, MAX_PREFIXED_KEY_NIBBLE_LEN, MAX_DEPTH_NO_LEAF
};

use dep::ethereum::verifiers::{
    transaction::rlp::assert_tx_rlp_equals,
    tx_helpers::{idx::assert_tx_idx_equals, split::split_into_tx_type_and_rlp}
};

use dep::ethereum::misc::{types::HASH_LEN, bytes::right_pad, fragment::Fragment};
use dep::ethereum::header::get_header;
use dep::ethereum::verifiers::transaction::verify_tx;
use dep::ethereum::merkle_patricia_proofs::proof::{ProofInput, verify_merkle_proof, Proof, Node, MAX_NODE_LEN};

use dep::ethereum::rlp::decode::decode_list;
use dep::ethereum::rlp::types::{RlpList, RlpFragment};

use dep::std::ecdsa_secp256k1::verify_signature;
use dep::std::hash::keccak256;

global MAX_DATA_LEN = 1000;
global MAX_VALUE_LEN_M = 1000; // Values taken from txProofConfigM in tx.ts. (same as receipt.ts.)
global MAX_LEAF_LEN_M = 1011;

fn form_signature(r: [u8; 32], s: [u8; 32]) -> [u8; 64] {
    let mut result: [u8; 64] = [0; 64];
    for i in 0..32 {
        result[i] = r[i];
    }
    for i in 0..32 {
        result[32+i] = s[i];
    }
    result
}

fn main(
    chain_id: pub Field,
    block_number: pub u64,
    tx_idx: pub Field,
    pub_key_x: [u8; 32],
    pub_key_y: [u8; 32],
    hashed_message: [u8; 32],
    signature: [u8; 64] // transaction_with_block: TransactionWithinBlock<MAX_DATA_LEN>
) -> pub [u8; 20] {
    // Normally would fetch the transaction via oracle
    let transaction_with_block: TransactionWithinBlock<MAX_DATA_LEN> = get_transaction(chain_id, block_number, tx_idx);
    let transaction_partial = transaction_with_block.transaction;

    // Verify the signature
    assert(
        verify_signature(
            pub_key_x,
            pub_key_y,
            form_signature(transaction_partial.r, transaction_partial.s),
            hashed_message
        )
    );

    // Derive the sender address from the public key
    let pub_key = form_signature(pub_key_x, pub_key_y);
    let hashed_pub_key = keccak256(pub_key, 64);
    let mut sender_address: [u8; 20] = [0; 20];
    for i in 0..20 {
        sender_address[i] = hashed_pub_key[12+i];
    }

    sender_address
}
