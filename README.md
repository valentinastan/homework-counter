# Homework Counter DApp on Sui

A simple counter smart contract on Sui blockchain where users can create their own personal counters and increment them on-chain.

**Only the owner of a counter can increment it** — anyone else will receive an explicit error (`ENotOwner`).

Deployed on **Sui Testnet**.

---

## Package ID
```
0x2510a280afe3a0c850cb5abe17a29bb5133a72447a5e6c98394cbf5e618db0f5
```

## Links

**Package Explorer:**
https://suiexplorer.com/object/0x2510a280afe3a0c850cb5abe17a29bb5133a72447a5e6c98394cbf5e618db0f5?network=testnet

**Publish Transaction:**
https://suiexplorer.com/txblock/PUZCm5Sj7JvkD8uBb5wyDwwy7o7p7vxkfGL1FxAcE1h?network=testnet

**Example Counter Object:**
https://suiexplorer.com/object/0xa1430b231dce0d476bc3593d22b668e03bf49114447d8767c66c9f6f4b1e7b1e?network=testnet

---

## Features

- **Create Personal Counter**: Each user can create their own counter object
- **Owner-Only Increment**: Only the counter owner can increment their counter
- **Access Control**: Custom error code `ENotOwner = 1` prevents unauthorized increments
- **Event Emission**: Events emitted on counter creation and every increment
- **View Functions**: 
  - `get_value()` - Get current counter value
  - `get_owner()` - Get counter owner address
  - `get_created_at()` - Get creation timestamp

---

## How to Build & Test Locally

```bash
git clone https://github.com/valentinastan/homework-counter.git
cd homework_counter_dapp

sui move build

sui move test
```

Expected output:
```
Running Move unit tests
[ PASS    ] homework_counter_dapp::homework_counter_dapp::test_create_counter
[ PASS    ] homework_counter_dapp::homework_counter_dapp::test_increment
Test result: OK. Total tests: 2; passed: 2; failed: 0
```

---

## How to Publish
```bash
sui client publish --gas-budget 100000000
```
---

## Usage After Deployment

### Create a Counter
```bash
sui client call \
  --package 0x2510a280afe3a0c850cb5abe17a29bb5133a72447a5e6c98394cbf5e618db0f5 \
  --module homework_counter_dapp \
  --function create_counter \
  --gas-budget 10000000
```

### Increment Your Counter (Owner Only)
```bash
sui client call \
  --package 0x2510a280afe3a0c850cb5abe17a29bb5133a72447a5e6c98394cbf5e618db0f5 \
  --module homework_counter_dapp \
  --function increment \
  --args 0xa1430b231dce0d476bc3593d22b668e03bf49114447d8767c66c9f6f4b1e7b1e \
  --gas-budget 10000000
```

**Note:** Replace the counter object ID with your own counter's ID. Non-owners attempting to increment will receive error code `1` (ENotOwner).

---

## Implementation Details

### Counter Struct
```move
public struct Counter has key {
    id: UID,
    owner: address,
    value: u64,
    created_at: u64,
}
```

### Access Control
The `increment()` function includes owner verification:
```move
public fun increment(counter: &mut Counter, ctx: &TxContext) {
  let caller = tx_context::sender(ctx);
  
  if (counter.owner != caller) {
    abort ENotOwner
  };
  
  // ... increment logic
}
```

- Custom error constant: `const ENotOwner: u64 = 1;`
- Aborts transaction if non-owner attempts to increment

### Events
- **CounterCreated** - Emitted when a new counter is created, containing:
  - `counter_id`: The ID of the newly created counter
  - `owner`: Address of the counter owner
  - `created_at`: Timestamp of creation

- **CounterIncremented** - Emitted on each successful increment, containing:
  - `counter_id`: The ID of the counter
  - `old_value`: Value before increment
  - `new_value`: Value after increment
  - `incremented_by`: Address of the caller

---

## Testing

The module includes two comprehensive tests:

1. **test_create_counter**: Verifies that a counter is created with:
   - Initial value of 0
   - Correct owner assignment

2. **test_increment**: Verifies that:
   - Counter increments correctly (0 → 1 → 2)
   - Multiple increments work as expected

Run tests with: `sui move test`
