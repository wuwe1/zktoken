pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

template Main() {
  signal input hashValue;
  signal input hashSenderBalanceBefore;
  signal input hashSenderBalanceAfter;
  signal input hashReceiverBalanceBefore;
  signal input hashReceiverBalanceAfter;

  signal input senderBalanceBefore;
  signal input receiverBalanceBefore;
  signal input value;

  signal senderBalanceAfter;
  signal receiverBalanceAfter;

  senderBalanceAfter <== senderBalanceBefore - value;
  receiverBalanceAfter <== receiverBalanceBefore + value;

  component senderBalanceGreaterThan = GreaterThan(252);
  senderBalanceGreaterThan.in[0] <== senderBalanceBefore;
  senderBalanceGreaterThan.in[1] <== value;

  component valueHasher = Poseidon(1);
  valueHasher.inputs[0] <== value;
  valueHasher.out === hashValue;

  component senderBalanceBeforeHasher = Poseidon(1);
  senderBalanceBeforeHasher.inputs[0] <== senderBalanceBefore;
  senderBalanceBeforeHasher.out === hashSenderBalanceBefore;

  component senderBalanceAfterHasher = Poseidon(1);
  senderBalanceAfterHasher.inputs[0] <== senderBalanceAfter;
  senderBalanceAfterHasher.out === hashSenderBalanceAfter;

  component receiverBalanceBeforeHasher = Poseidon(1);
  receiverBalanceBeforeHasher.inputs[0] <== receiverBalanceBefore;
  receiverBalanceBeforeHasher.out === hashReceiverBalanceBefore;

  component receiverBalanceAfterHasher = Poseidon(1);
  receiverBalanceAfterHasher.inputs[0] <== receiverBalanceAfter;
  receiverBalanceAfterHasher.out === hashReceiverBalanceAfter;
}

component main {public [hashValue, hashSenderBalanceBefore, hashSenderBalanceAfter, hashReceiverBalanceBefore, hashReceiverBalanceAfter]} = Main();