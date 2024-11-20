pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/EOAActivity.sol";
// import "../circuits/target/contract.sol";
import "../src/verifiers/EOAActivityVerifier.sol";
import "forge-std/console.sol";

contract EOAActivityTest is Test {
    EOAActivity public eoa_activity;
    EOAActivityVerifier public verifier;

    bytes32[] public dynamicCorrect = new bytes32[](2);
    bytes32[] public correct = new bytes32[](2);
    bytes32[] public wrong = new bytes32[](1);

    function setUp() public {
        verifier = new EOAActivityVerifier();
        eoa_activity = new EOAActivity();

        // correct[0] = bytes32(
        //     0x0000000000000000000000000000000000000000000000000000000000000003
        // );
        // correct[1] = correct[0];
        // wrong[0] = bytes32(
        //     0x0000000000000000000000000000000000000000000000000000000000000004
        // );
    }

    function testVerifyProof() public {
        bytes memory proof = vm.readFileBinary("./test/eoa.proof");
        // bytes memory last = sliceAfter64Bytes(proof_w_inputs);
        eoa_activity.register_active_eoa(proof);
    }

    // function test_wrongProof() public {
    //     vm.expectRevert();
    //     bytes memory proof_w_inputs = vm.readFileBinary(
    //         "./circuits/target/eoa.proof"
    //     );
    //     bytes memory proof = sliceAfter64Bytes(proof_w_inputs);
    //     eoa_activity.verifyEqual(proof, wrong);
    // }

    // Utility function, because the proof file includes the public inputs at the beginning
    function sliceAfter64Bytes(
        bytes memory data
    ) internal pure returns (bytes memory) {
        uint256 length = data.length - 736;
        bytes memory result = new bytes(data.length - 736);
        for (uint i = 0; i < length; i++) {
            result[i] = data[i + 736];
        }
        return result;
    }
}
