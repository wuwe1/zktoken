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
  signal MiMChashValue;
  signal MiMChashSenderBalanceBefore;
  signal MiMChashSenderBalanceAfter;
  signal MiMChashReceiverBalanceBefore;
  signal MiMChashReceiverBalanceAfter;

  senderBalanceAfter <== senderBalanceBefore - value;
  receiverBalanceAfter <== receiverBalanceBefore + value;

  component senderBalanceGreaterThan = GreaterThan(252);
  senderBalanceGreaterThan.in[0] <== senderBalanceBefore;
  senderBalanceGreaterThan.in[1] <== value;

  component valueHasher = Poseidon(1);
  valueHasher.inputs[0] <== value;
  MiMChashValue <== valueHasher.out;
  component valueIsEqual = IsEqual();
  valueIsEqual.in[0] <== MiMChashValue;
  valueIsEqual.in[1] <== hashValue;

  component senderBalanceBeforeHasher = Poseidon(1);
  senderBalanceBeforeHasher.inputs[0] <== senderBalanceBefore;
  MiMChashSenderBalanceBefore <== senderBalanceBeforeHasher.out;
  component senderBalanceBeforeIsEqual = IsEqual();
  senderBalanceBeforeIsEqual.in[0] <== MiMChashSenderBalanceBefore;
  senderBalanceBeforeIsEqual.in[1] <== hashSenderBalanceBefore;

  component senderBalanceAfterHasher = Poseidon(1);
  senderBalanceAfterHasher.inputs[0] <== senderBalanceAfter;
  MiMChashSenderBalanceAfter <== senderBalanceAfterHasher.out;
  component senderBalanceAfterIsEqual = IsEqual();
  senderBalanceAfterIsEqual.in[0] <== MiMChashSenderBalanceAfter;
  senderBalanceAfterIsEqual.in[1] <== hashSenderBalanceAfter; 

  component mimcReceiverBalanceBefore = Poseidon(1);
  mimcReceiverBalanceBefore.inputs[0] <== receiverBalanceBefore;
  MiMChashReceiverBalanceBefore <== mimcReceiverBalanceBefore.out;
  component receiverBalanceBeforeIsEqual = IsEqual();
  receiverBalanceBeforeIsEqual.in[0] <== MiMChashReceiverBalanceBefore;
  receiverBalanceBeforeIsEqual.in[1] <== hashReceiverBalanceBefore;

  component mimcReceiverBalanceAfter = Poseidon(1);
  mimcReceiverBalanceAfter.inputs[0] <== receiverBalanceAfter;
  MiMChashReceiverBalanceAfter <== mimcReceiverBalanceAfter.out;
  component receiverBalanceAfterIsEqual = IsEqual();
  receiverBalanceAfterIsEqual.in[0] <== MiMChashReceiverBalanceAfter;
  receiverBalanceAfterIsEqual.in[1] <== hashReceiverBalanceAfter;
}

component main {public [hashValue, hashSenderBalanceBefore, hashSenderBalanceAfter, hashReceiverBalanceBefore, hashReceiverBalanceAfter]} = Main();