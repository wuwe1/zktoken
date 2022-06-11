// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./interfaces/IVerifier.sol";

contract ZKToken {
    IVerifier verifier;
    mapping(address => uint256) balanceHashes;

    constructor(address _verifier) {
        verifier = IVerifier(_verifier);
    }

    function transfer(
        uint256 hashValue,
        uint256 hashSenderBalanceAfter,
        uint256 hashReceiverBalanceAfter,
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        address to
    ) external {
        uint256 hashSenderBalanceBefore = balanceHashes[msg.sender];
        uint256 hashReceiverBalanceBefore = balanceHashes[to];
        uint256[5] memory input;
        input[0] = hashValue;
        input[1] = hashSenderBalanceBefore;
        input[2] = hashSenderBalanceAfter;
        input[3] = hashReceiverBalanceBefore;
        input[4] = hashReceiverBalanceAfter;

        require(verifier.verifyProof(a, b, c, input));

        balanceHashes[msg.sender] = hashSenderBalanceAfter;
        balanceHashes[to] = hashReceiverBalanceAfter;
    }
}
