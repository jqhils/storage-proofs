# Thesis project
#### Verifiable Computation over Historical Ethereum Data Using zk-SNARKs

### To run solidity storage proof verifiers
$ cd contracts \
$ forge test


### To compute noir proofs
1. run an instance of the oracle server in one terminal.
2. navigate to a circuit directory. And, run `nargo prove`


### Aknowledgments
- We leverage vlayer's [ethereum monorepo noir library](https://github.com/vlayer-xyz/monorepo) for handling storage proof
