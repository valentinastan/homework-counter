module homework_counter_dapp::homework_counter_dapp;

use sui::event;

public struct Counter has key {
  id: UID,
  owner: address,
  value: u64,
  created_at: u64,
}

//Events
public struct CounterCreated has copy, drop {
  counter_id: ID,
  owner: address,
  created_at: u64,
}

public struct CounterIncremented has copy, drop {
  counter_id: ID,
  old_value: u64,
  new_value: u64,
  incremented_by: address,
}

//Functions
public fun create_counter(ctx: &mut TxContext) {
  let sender = ctx.sender();
  let counter_id = object::new(ctx);
  let id_copy = object::uid_to_inner(&counter_id);

  let counter = Counter {
    id: counter_id,
    owner: sender,
    value: 0,
    created_at: ctx.epoch_timestamp_ms(),
  };

  event::emit(CounterCreated {
    counter_id: id_copy,
    owner: sender,
    created_at: counter.created_at,
  });

  transfer::transfer(counter, sender);
}

public fun increment(counter: &mut Counter, ctx: &TxContext) {
  let old_value = counter.value;
  counter.value = counter.value + 1;

  event::emit(CounterIncremented {
    counter_id: object::uid_to_inner(&counter.id),
    old_value,
    new_value: counter.value,
    incremented_by: ctx.sender(),
  });
}

public fun get_value(counter: &Counter): u64 {
  counter.value
}

public fun get_owner(counter: &Counter): address {
  counter.owner
}

public fun get_created_at(counter: &Counter): u64 {
  counter.created_at
}

//Tests
#[test_only]
use sui::test_scenario;

#[test]
fun test_create_counter() {
  let owner = @0x000;
  let mut scenario = test_scenario::begin(owner);

  {
    create_counter(scenario.ctx());
  };

  scenario.next_tx(owner);
  {
    let counter = scenario.take_from_sender<Counter>();
    assert!(get_value(&counter) == 0, 0);
    assert!(get_owner(&counter) == owner, 1);
    scenario.return_to_sender(counter);
  };

  scenario.end();
}

#[test]
fun test_increment() {
  let owner = @0x000;
  let mut scenario = test_scenario::begin(owner);

  {
    create_counter(scenario.ctx());
  };

  scenario.next_tx(owner);
 {
    let mut counter = scenario.take_from_sender<Counter>();
    increment(&mut counter, scenario.ctx());
    assert!(get_value(&counter) == 1, 0);

    increment(&mut counter, scenario.ctx());
    assert!(get_value(&counter) == 2, 1);

    scenario.return_to_sender(counter);
  };

  scenario.end();
}
