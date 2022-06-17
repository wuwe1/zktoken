// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "src/ZKToken.sol";
import "src/TransferVerifier.sol";

contract ZKTokenTest is Test {
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
        Proof memory proof;
        proof.a[0] = 0x16c9f57f974b8dfa791b6baaac0df1e864a691951c2d63d64c0857ac6ffb8e22;
        proof.a[1] = 0x11aba5c6c1b9067db01f0ae4070b5a331010ff98245513445743dd71c4137417;
        proof.b[0][0] = 0x2192762988ed1eb5824ee7bc66259a7763ed45560520e3caebab9c83bfad0335;
        proof.b[0][1] = 0x2e72256cfd4ef3e1a17365e386d979e5b240a66d70588d0857e77b12f543596e;
        proof.b[1][0] = 0x18507809ee6fd23fe1206f819c2223902f7a220246dfef87d0ef61a8dc6581a6;
        proof.b[1][1] = 0x06f3d0e089c3565b56e37804c5ceb38a40dbd4ce9b2571c32551a94bf0f8291b;
        proof.c[0] = 0x1a2436143837b6bd5ea5bb48e8620ecc5c7b1766d05d7272c4f577a713c1391d;
        proof.c[1] = 0x2f872a8e8c949ab9799af7d7d47135d64a3f54c0801c31820d87848a531cda46;

        uint256[5] memory input;
        uint256 hashValue = 0x2778f900758cc46e051040641348de3dacc6d2a31e2963f22cbbfb8f65464241;
        uint256 hashSenderBalanceBefore = 0x21f6c93b8b701f3c96744fcc5e4d99d95fdbaffe3068c0f1dbfdf753df34a56c;
        uint256 hashSenderBalanceAfter = 0x22d0ae462961c4cc15b7a368970afc115a29563a262963d28bf52035f73f2f7f;
        uint256 hashReceiverBalanceBefore = 0x22d0ae462961c4cc15b7a368970afc115a29563a262963d28bf52035f73f2f7f;
        uint256 hashReceiverBalanceAfter = 0x21f6c93b8b701f3c96744fcc5e4d99d95fdbaffe3068c0f1dbfdf753df34a56c;
        input[0] = hashValue;
        input[1] = hashSenderBalanceBefore;
        input[2] = hashSenderBalanceAfter;
        input[3] = hashReceiverBalanceBefore;
        input[4] = hashReceiverBalanceAfter;

        assertTrue(verifier.verifyProof(proof.a, proof.b, proof.c, input));
    }

    function test_Transfer() public {
        Proof memory proof;
        proof.a[0] = 0x16c9f57f974b8dfa791b6baaac0df1e864a691951c2d63d64c0857ac6ffb8e22;
        proof.a[1] = 0x11aba5c6c1b9067db01f0ae4070b5a331010ff98245513445743dd71c4137417;
        proof.b[0][0] = 0x2192762988ed1eb5824ee7bc66259a7763ed45560520e3caebab9c83bfad0335;
        proof.b[0][1] = 0x2e72256cfd4ef3e1a17365e386d979e5b240a66d70588d0857e77b12f543596e;
        proof.b[1][0] = 0x18507809ee6fd23fe1206f819c2223902f7a220246dfef87d0ef61a8dc6581a6;
        proof.b[1][1] = 0x06f3d0e089c3565b56e37804c5ceb38a40dbd4ce9b2571c32551a94bf0f8291b;
        proof.c[0] = 0x1a2436143837b6bd5ea5bb48e8620ecc5c7b1766d05d7272c4f577a713c1391d;
        proof.c[1] = 0x2f872a8e8c949ab9799af7d7d47135d64a3f54c0801c31820d87848a531cda46;

         uint256 hashValue = 0x2778f900758cc46e051040641348de3dacc6d2a31e2963f22cbbfb8f65464241;
        uint256 hashSenderBalanceBefore = 0x21f6c93b8b701f3c96744fcc5e4d99d95fdbaffe3068c0f1dbfdf753df34a56c;
        uint256 hashSenderBalanceAfter = 0x22d0ae462961c4cc15b7a368970afc115a29563a262963d28bf52035f73f2f7f;
        uint256 hashReceiverBalanceBefore = 0x22d0ae462961c4cc15b7a368970afc115a29563a262963d28bf52035f73f2f7f;
        uint256 hashReceiverBalanceAfter = 0x21f6c93b8b701f3c96744fcc5e4d99d95fdbaffe3068c0f1dbfdf753df34a56c;

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
            bob,
            proof
        );
    }
}
