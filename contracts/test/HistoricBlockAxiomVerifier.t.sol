// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/HistoricBlockAxiomVerifier.sol";

contract HistoricBlockAxiomVerifierTest is Test {
    HistoricBlockAxiomVerifier verifierContract;
    address constant verifierAddress =
        0x69963768F8407dE501029680dE46945F838Fc98B; // replace with IAxiomV2Verifier contract address on mainnet

    function setUp() public {
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL")); // Use your Infura or Alchemy RPC URL
        verifierContract = new HistoricBlockAxiomVerifier(verifierAddress);
    }

    function testIsBlockHashValid() public view {
        uint32 blockNumber = 21092500; // Example block number
        bytes32 claimedBlockHash = 0xefe48020f9c69cae771aa0b4f29069a32d58a9824f304cb06527716faefee6b2; // Example claimed hash
        bytes32 prevHash = 0x5c4bd7b960f1ac34fbc03cfbf864ef1becefc56fdca02cb35c56e96ad60334b3; // Example parent hash
        uint32 numFinal = 1024; // Number of blocks verified in this batch

        // Example Merkle proof (filled with dummy values)
        bytes32[] memory merkleProof = new bytes32[](10);
        merkleProof[
            0
        ] = 0x31ab2e4e3d6179fc2c295b4056eb89ff574650e9e065ff095fbadcf02cf2da6f;
        merkleProof[
            1
        ] = 0xc10a1bae17ab32d3acc97074f42490a098c818f84de34e2583611b4572612fbc;
        merkleProof[
            2
        ] = 0x69a1fad07cdfc6fbb0509b7f54301b6100665d84205c6789b98414ee86511456;
        merkleProof[
            3
        ] = 0x0b0bde5d673edc3a7c7f19ad198aaf28be329a8ac48c25e789e48963f58f96fa;
        merkleProof[
            4
        ] = 0xa2db74edf6e966414e2113e90028e8a525d7cb253fced1ffa7ca592f06cf5237;
        merkleProof[
            5
        ] = 0x394b3d06981eb3b1b311d0a22dee8caf39b3656eebad04c69fc87434a75f0d63;
        merkleProof[
            6
        ] = 0x5a47ce1b0883ca62655c0c67646afb85d038a7e82b0241b1189e5e655e6d2f81;
        merkleProof[
            7
        ] = 0x587743759ce0b4dfb9c616ba738b7f5e81132714306f69a9b58e9bafcbaab7d7;
        merkleProof[
            8
        ] = 0x071f81b78da76b6347bd4523a1e382fa6b3ac8336cb24ed92319844404bc4c13;
        merkleProof[
            9
        ] = 0xbcd43625ddca75f7601a849698dfa4ec8076671c5450e2cf9cee7ddd5488f7f4;

        IAxiomV2Verifier.BlockHashWitness memory witness = IAxiomV2Verifier
            .BlockHashWitness({
                blockNumber: blockNumber,
                claimedBlockHash: claimedBlockHash,
                prevHash: prevHash,
                numFinal: numFinal,
                merkleProof: merkleProof
            });

        bool result = verifierContract.testIsBlockHashValid(witness);
        assertTrue(result, "Block hash validation failed");
    }
}
