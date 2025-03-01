# Thesis project
#### Verifiable Computation over Historical Ethereum Data Using zk-SNARKs

### Software Library & API requirements:
- Noir (version 0.30.0)
- Foundry (version 1.0+)
- [Alchemy](https://alchemy.com/)

### To run solidity storage proof verifiers
  1. `cd contracts`
  2. Add `MAINNET_RPC_URL` to `contracts/.env`
  3. `forge test`

### To compute noir proofs locally
1. run an instance of the oracle server in one terminal:
  1. Navigate to `./oracles`
  2. Add `ETHEREUM_JSON_RPC_API_URL` to `contracts/.env`
  3. Install the packages: `yarn install`
  4. Run the oracle server: `yarn oracle-server:watch`
2. In a separate terminal session, navigate to a circuit's directory.
  And, run: `nargo prove --oracle-resolver http://localhost:5555`

### Aknowledgments
- We leverage vlayer's [ethereum monorepo noir library](https://github.com/vlayer-xyz/monorepo) for handling storage proof
