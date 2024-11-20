// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";

import "./StorageProofVerifier.sol";
import "./BlockHeaderVerifier.sol";
import "./HistoricBlockAxiomVerifier.sol";
import "./RLPReader.sol";

contract ProofOfPUNKOwnership {
    using RLPReader for bytes;
    using RLPReader for RLPReader.RLPItem;

    StorageProofVerifier storageProofVerifier;
    BlockHeaderVerifier blockHeaderVerifier;
    HistoricBlockAxiomVerifier historicBlockAxiomVerifier;

    constructor(
        address _storageProofVerifier,
        address _blockHeaderVerifier,
        address _historicBlockAxiomVerifier
    ) {
        storageProofVerifier = StorageProofVerifier(_storageProofVerifier);
        blockHeaderVerifier = BlockHeaderVerifier(_blockHeaderVerifier);
        historicBlockAxiomVerifier = HistoricBlockAxiomVerifier(
            _historicBlockAxiomVerifier
        );
    }

    function ownsPUNK(
        address nft_address,
        uint32 blockNumber,
        bytes memory blockHeader,
        bytes32 blockHash,
        bytes[] memory accountProof,
        bytes32 storageSlot,
        bytes[] memory storageProof,
        IAxiomV2Verifier.BlockHashWitness calldata blockWitness
    ) public view returns (bool) {
        // Verify block header
        verifyBlockHeader(blockHeader, blockHash, blockWitness);

        // Verify storage proof
        (bool valid, bytes memory value) = storageProofVerifier
            .verifyStorageProof(
                getStateRoot(blockHeader),
                nft_address,
                storageSlot,
                accountProof,
                storageProof
            );

        require(valid, "Storage proof verification failed");

        // Check if the value is non-zero (indicating ownership of at least one PUNK)
        uint256 decodedValue = toUint256(value);
        return decodedValue > 0;
    }

    function verifyBlockHeader(
        bytes memory blockHeader,
        bytes32 blockHash,
        IAxiomV2Verifier.BlockHashWitness calldata blockWitness
    ) internal view {
        require(
            blockHeaderVerifier.verifyBlockHeader(
                blockHeader,
                blockHash,
                getStateRoot(blockHeader)
            ),
            "Block header verification failed"
        );
        require(
            historicBlockAxiomVerifier.testIsBlockHashValid(blockWitness),
            "Block hash verification failed"
        );
    }

    function getStateRoot(
        bytes memory rlpHeader
    ) internal pure returns (bytes32) {
        RLPReader.RLPItem[] memory items = rlpHeader.toRlpItem().toList();
        require(items.length > 3, "Invalid block header structure");
        return bytes32(items[3].toBytes());
    }

    function toUint256(bytes memory _bytes) internal pure returns (uint256) {
        require(_bytes.length <= 32, "Invalid bytes length");
        uint256 result;
        assembly {
            result := mload(add(_bytes, 0x20))
        }
        return result;
    }
}
