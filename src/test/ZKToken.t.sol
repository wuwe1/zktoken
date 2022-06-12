// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "src/ZKToken.sol";
import "src/TransferVerifier.sol";

contract ContractTest is Test {
    using stdStorage for StdStorage;
    ZKToken token;
    Verifier verifier;

    uint256 internal alicePk = 0xa11ce;
    uint256 internal bobPk = 0xb0b;
    address internal alice;
    address internal bob;

    function setUp() public {
        verifier = new Verifier();
        token = new ZKToken(address(verifier), "test", "TST", 18, 0);
        alice = vm.addr(alicePk);
        bob = vm.addr(bobPk);
        vm.label(alice, "alice");
        vm.label(bob, "bob");
        vm.label(address(token), "token");
    }

    function test_VerifierCanVerifyLegitProof() public {
        uint256[2] memory a;
        uint256[2][2] memory b;
        uint256[2] memory c;
        uint256[5] memory input;

        uint256 hashValue = 0x1adc4696203fb500000000000000000000000000000000000000000000000000;
        uint256 hashSenderBalanceBefore = 0x096cb25a7e536280000000000000000000000000000000000000000000000000;
        uint256 hashSenderBalanceAfter = 0x0c72515575a63580000000000000000000000000000000000000000000000000;
        uint256 hashReceiverBalanceBefore = 0x0d20709c52598e00000000000000000000000000000000000000000000000000;
        uint256 hashReceiverBalanceAfter = 0x0c72515575a63580000000000000000000000000000000000000000000000000;

        a[0] = 0x216081e6f823f67707d3cfee84710795284fa8bd05da66f9a562a3642987e89d;
        a[1] = 0x0ac0586aa961324be8ac92c9907ab055e37f4b079e75e649484e3c53511a24ed;
        b[0][0] = 0x143ee3400d44b1909f4680ec438467d44e22dee52ddfcd0b02dc37aed0b626a2;
        b[0][1] = 0x1d1d5bb6d832c87cf01f17a1c6a6aa6025f93f9b50e342ca97225cd1b139c46f;
        b[1][0] = 0x2596c663ec04ffe4639501c577218f94451f6245ad270d2b3a7c007cc682310e;
        b[1][1] = 0x071d87d0e865943425cf4278ef144ba7b7069c92f87c010993e17e2f5b097008;
        c[0] = 0x243d8c275d47da2150baa0c56d45375a79998572af7f2c5af331fa13d2c1d243;
        c[1] = 0x0402d82052a733b0314303be7e2654be27c733d36210ae70f9cf13c01ca849e6;
        input[0] = hashValue;
        input[1] = hashSenderBalanceBefore;
        input[2] = hashSenderBalanceAfter;
        input[3] = hashReceiverBalanceBefore;
        input[4] = hashReceiverBalanceAfter;

        assertTrue(verifier.verifyProof(a, b, c, input));
    }

    function test_Transfer() public {
        uint256[2] memory a;
        uint256[2][2] memory b;
        uint256[2] memory c;

        uint256 hashValue = 0x1adc4696203fb500000000000000000000000000000000000000000000000000;
        uint256 hashSenderBalanceBefore = 0x096cb25a7e536280000000000000000000000000000000000000000000000000;
        uint256 hashSenderBalanceAfter = 0x0c72515575a63580000000000000000000000000000000000000000000000000;
        uint256 hashReceiverBalanceBefore = 0x0d20709c52598e00000000000000000000000000000000000000000000000000;
        uint256 hashReceiverBalanceAfter = 0x0c72515575a63580000000000000000000000000000000000000000000000000;

        a[0] = 0x216081e6f823f67707d3cfee84710795284fa8bd05da66f9a562a3642987e89d;
        a[1] = 0x0ac0586aa961324be8ac92c9907ab055e37f4b079e75e649484e3c53511a24ed;
        b[0][0] = 0x143ee3400d44b1909f4680ec438467d44e22dee52ddfcd0b02dc37aed0b626a2;
        b[0][1] = 0x1d1d5bb6d832c87cf01f17a1c6a6aa6025f93f9b50e342ca97225cd1b139c46f;
        b[1][0] = 0x2596c663ec04ffe4639501c577218f94451f6245ad270d2b3a7c007cc682310e;
        b[1][1] = 0x071d87d0e865943425cf4278ef144ba7b7069c92f87c010993e17e2f5b097008;
        c[0] = 0x243d8c275d47da2150baa0c56d45375a79998572af7f2c5af331fa13d2c1d243;
        c[1] = 0x0402d82052a733b0314303be7e2654be27c733d36210ae70f9cf13c01ca849e6; 

        // keccak256(abi.encode(address(alice), uint(3)));
        uint256 aliceBalanceSlot = stdstore
            .target(address(token))
            .sig(token.balanceHashes.selector)
            .with_key(alice)
            .find();

        vm.store(address(token), bytes32(aliceBalanceSlot), bytes32(hashSenderBalanceBefore));

        // keccak256(abi.encode(address(bob), uint(3)));
        uint256 bobBalanceSlot = stdstore
            .target(address(token))
            .sig(token.balanceHashes.selector)
            .with_key(bob)
            .find();

        vm.store(address(token), bytes32(bobBalanceSlot), bytes32(hashReceiverBalanceBefore));

        vm.prank(alice);
        token.transfer(
            hashValue,
            hashSenderBalanceAfter,
            hashReceiverBalanceAfter,
            a,
            b, 
            c,
            bob
        );
    }
}
