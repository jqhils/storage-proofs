// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "./verifiers/EOAActivityVerifier.sol";
import "forge-std/console.sol";

contract EOAActivity {
    EOAActivityVerifier public eoa_verifier = new EOAActivityVerifier();

    mapping(address => bool) public isRegistered;

    function register_active_eoa(bytes calldata _proof) public {
        bytes32 zeroLeading = 0x0000000000000000000000000000000000000000000000000000000000000000;

        uint256 chain_id = 1;
        uint64 block_no_1;
        uint64 block_no_2;
        address eoa_address = 0x9DDC763dF398f9B4eA92d040a00723E08808579C;

        bytes32 test_0 = 0x0000000000000000000000000000000000000000000000000000000000000001;
        bytes32 test_1 = 0x000000000000000000000000000000000000000000000000000000000136C5FF;
        bytes32 test_2 = 0x000000000000000000000000000000000000000000000000000000000136C602;
        bytes20 eoa_address_b = bytes20(eoa_address);
        // bytes32 test_3 = 0x0000000000000000000000009DDC763dF398f9B4eA92d040a00723E08808579C;

        bytes32[] memory public_inputs = new bytes32[](23);
        public_inputs[0] = test_0;
        public_inputs[1] = test_1;
        public_inputs[2] = test_2;

        // Populate remaining public inputs
        for (uint i = 0; i < 20; i++) {
            bytes32 test = bytes1(uint8(eoa_address_b[i]));
            public_inputs[3 + i] = bytes32(
                uint256(zeroLeading) | (uint256(test) >> 248)
            );
        }

        for (uint i = 0; i < 23; i++) {
            console.logBytes32(public_inputs[i]);
        }

        eoa_verifier.verify(_proof, public_inputs);
        // try eoa_verifier.verify(_proof, public_inputs) returns (
        //     bool resultOfVerification
        // ) {
        //     isRegistered[eoa_address] = true;
        // } catch {
        //     revert("INVALID_PROOF");
        // }
    }

    function toBytes(address a) public pure returns (bytes memory) {
        return abi.encodePacked(a);
    }
}
