# Homework Counter DApp on Sui

A simple counter smart contract on Sui blockchain with basic access control and error handling.

**Only the owner of a counter can increment it** — anyone else will receive an explicit error (`ENotOwner`).

Deployed on **Sui Testnet**.

## Package ID
0x2510a280afe3a0c850cb5abe17a29bb5133a72447a5e6c98394cbf5e618db0f5

## Counter Object ID
0xa1430b231dce0d476bc3593d22b668e03bf49114447d8767c66c9f6f4b1e7b1e
https://suiexplorer.com/object/0xa1430b231dce0d476bc3593d22b668e03bf49114447d8767c66c9f6f4b1e7b1e?network=testnet

## Publish Transaction
https://suiexplorer.com/txblock/PUZCm5Sj7JvkD8uBb5wyDwwy7o7p7vxkfGL1FxAcE1h?network=testnet
(Transaction Digest: `PUZCm5Sj7JvkD8uBb5wyDwwy7o7p7vxkfGL1FxAcE1h`)

## Features
- Create a personal counter
- Only the owner can increment the counter
- Custom error code `ENotOwner = 1`
- Events emitted on creation and every increment
- View functions: `get_value`, `get_owner`, `get_created_at`

## How to Build & Test Locally
```bash
git clone https://github.com/valentinastan/homework-counter.git
cd homework_counter_dapp

sui move build
sui move test
```
## How to Publish
```bash
sui client publish --gas-budget 500000000
```

## Usage After Deployment
1. Create a counter
Call → homework_counter_dapp::homework_counter_dapp::create_counter
2. Increment (only owner)
Call → homework_counter_dapp::homework_counter_dapp::increment
→ Non-owner → aborts with error code 1

## Implementation Details
Added owner check in increment
Custom error ENotOwner = 1
