# Thesis project
#### Verifiable Computation over Historical Ethereum Data Using zk-SNARKs

### Software Library requirements:
- Noir (version 0.30.0)
- Foundry (version 1.0+)

### To run solidity storage proof verifiers
$ cd contracts \
$ forge test

### To compute noir proofs locally
1. run an instance of the oracle server in one terminal:
   1. Navigate to `./oracles`
   2. Install the packages: `yarn install`
   3. Run the oracle server: `yarn oracle-server:watch`
2. In a separate terminal session, navigate to a circuit's directory.
  And, run: `nargo prove --oracle-resolver http://localhost:5555`

### Aknowledgments
- We leverage vlayer's [ethereum monorepo noir library](https://github.com/vlayer-xyz/monorepo) for handling storage proof
