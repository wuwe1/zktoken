// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./interfaces/IVerifier.sol";

contract ZKToken {
    IVerifier verifier;

    string public name;
    string public symbol;
    uint8 public immutable decimals;

    mapping(address => uint256) public balanceHashes;

    constructor(
        address _verifier,
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 initialSupplyHash
    ) {
        verifier = IVerifier(_verifier);
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        balanceHashes[msg.sender] = initialSupplyHash;
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
