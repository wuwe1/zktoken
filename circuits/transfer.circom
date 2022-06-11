pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/mimcsponge.circom";
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

  component mimcValue = MiMCSponge(1,220,1);
  mimcValue.ins[0] <== value;
  mimcValue.k <== 0;
  MiMChashValue <== mimcValue.outs[0];
  component valueIsEqual = IsEqual();
  valueIsEqual.in[0] <== MiMChashValue;
  valueIsEqual.in[1] <== hashValue;

  component mimcSenderBalanceBefore = MiMCSponge(1,220,1);
  mimcSenderBalanceBefore.ins[0] <== senderBalanceBefore;
  mimcSenderBalanceBefore.k <== 0;
  MiMChashSenderBalanceBefore <== mimcSenderBalanceBefore.outs[0];
  component senderBalanceBeforeIsEqual = IsEqual();
  senderBalanceBeforeIsEqual.in[0] <== MiMChashSenderBalanceBefore;
  senderBalanceBeforeIsEqual.in[1] <== hashSenderBalanceBefore;

  component mimcSenderBalanceAfter = MiMCSponge(1,220,1);
  mimcSenderBalanceAfter.ins[0] <== senderBalanceAfter;
  mimcSenderBalanceAfter.k <== 0;
  MiMChashSenderBalanceAfter <== mimcSenderBalanceAfter.outs[0];
  component senderBalanceAfterIsEqual = IsEqual();
  senderBalanceAfterIsEqual.in[0] <== MiMChashSenderBalanceAfter;
  senderBalanceAfterIsEqual.in[1] <== hashSenderBalanceAfter; 

  component mimcReceiverBalanceBefore = MiMCSponge(1,220,1);
  mimcReceiverBalanceBefore.ins[0] <== receiverBalanceBefore;
  mimcReceiverBalanceBefore.k <== 0;
  MiMChashReceiverBalanceBefore <== mimcReceiverBalanceBefore.outs[0];
  component receiverBalanceBeforeIsEqual = IsEqual();
  receiverBalanceBeforeIsEqual.in[0] <== MiMChashReceiverBalanceBefore;
  receiverBalanceBeforeIsEqual.in[1] <== hashReceiverBalanceBefore;

  component mimcReceiverBalanceAfter = MiMCSponge(1,220,1);
  mimcReceiverBalanceAfter.ins[0] <== receiverBalanceAfter;
  mimcReceiverBalanceAfter.k <== 0;
  MiMChashReceiverBalanceAfter <== mimcReceiverBalanceAfter.outs[0];
  component receiverBalanceAfterIsEqual = IsEqual();
  receiverBalanceAfterIsEqual.in[0] <== MiMChashReceiverBalanceAfter;
  receiverBalanceAfterIsEqual.in[1] <== hashReceiverBalanceAfter;
}

component main {public [hashValue, hashSenderBalanceBefore, hashSenderBalanceAfter, hashReceiverBalanceBefore, hashReceiverBalanceAfter]} = Main();