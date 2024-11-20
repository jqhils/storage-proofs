// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "./verifiers/HelloWorldVerifier.sol";
import "forge-std/console.sol";

contract HelloWorld {
    HelloWorldVerifier public hello_verifier = new HelloWorldVerifier();
    uint256 public test = 0;

    function hello(bytes calldata _proof) public {
        bytes32 zeroLeading = 0x0000000000000000000000000000000000000000000000000000000000000000;

        bytes32 test_0 = 0x0000000000000000000000000000000000000000000000000000000000000003;
        bytes32 test_1 = 0x0000000000000000000000000000000000000000000000000000000000000003;

        bytes32[] memory public_inputs = new bytes32[](2);
        public_inputs[0] = test_0;
        public_inputs[1] = test_1;

        hello_verifier.verify(_proof, public_inputs);
        // try eoa_verifier.verify(_proof, public_inputs) returns (
        //     bool resultOfVerification
        // ) {
        //     isRegistered[eoa_address] = true;
        // } catch {
        //     revert("INVALID_PROOF");
        // }
    }
}
