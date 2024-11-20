pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/HelloWorld.sol";
// import "../circuits/target/contract.sol";
import "../src/verifiers/HelloWorldVerifier.sol";
import "forge-std/console.sol";

contract HelloWorldTest is Test {
    HelloWorld public hello_world;
    HelloWorldVerifier public verifier;

    bytes32[] public dynamicCorrect = new bytes32[](2);
    bytes32[] public correct = new bytes32[](2);
    bytes32[] public wrong = new bytes32[](1);

    function setUp() public {
        verifier = new HelloWorldVerifier();
        hello_world = new HelloWorld();
    }

    function testVerifyProof() public {
        bytes memory proof_w_inputs = vm.readFileBinary(
            "./test/hello_world2.proof"
        );
        bytes memory last = sliceAfter64Bytes(proof_w_inputs);
        hello_world.hello(last);
    }

    // Utility function, because the proof file includes the public inputs at the beginning
    function sliceAfter64Bytes(
        bytes memory data
    ) internal pure returns (bytes memory) {
        uint256 length = data.length - 64;
        bytes memory result = new bytes(data.length - 64);
        for (uint i = 0; i < length; i++) {
            result[i] = data[i + 64];
        }
        return result;
    }

    function sliceAfter32Bytes(
        bytes memory data
    ) internal pure returns (bytes memory) {
        uint256 length = data.length - 32;
        bytes memory result = new bytes(data.length - 32);
        for (uint i = 0; i < length; i++) {
            result[i] = data[i + 32];
        }
        return result;
    }
}
