// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {Proof} from "src/ZKToken.sol";

contract Constants {
    Proof internal TransferProof;
    uint256 internal hashValue = 0x2778f900758cc46e051040641348de3dacc6d2a31e2963f22cbbfb8f65464241;
    uint256 internal hashSenderBalanceBefore = 0x21f6c93b8b701f3c96744fcc5e4d99d95fdbaffe3068c0f1dbfdf753df34a56c;
    uint256 internal hashSenderBalanceAfter = 0x22d0ae462961c4cc15b7a368970afc115a29563a262963d28bf52035f73f2f7f;
    uint256 internal hashReceiverBalanceBefore = 0x22d0ae462961c4cc15b7a368970afc115a29563a262963d28bf52035f73f2f7f;
    uint256 internal hashReceiverBalanceAfter = 0x21f6c93b8b701f3c96744fcc5e4d99d95fdbaffe3068c0f1dbfdf753df34a56c;

    constructor () {
        TransferProof.a[0] = 0x16c9f57f974b8dfa791b6baaac0df1e864a691951c2d63d64c0857ac6ffb8e22;
        TransferProof.a[1] = 0x11aba5c6c1b9067db01f0ae4070b5a331010ff98245513445743dd71c4137417;
        TransferProof.b[0][0] = 0x2192762988ed1eb5824ee7bc66259a7763ed45560520e3caebab9c83bfad0335;
        TransferProof.b[0][1] = 0x2e72256cfd4ef3e1a17365e386d979e5b240a66d70588d0857e77b12f543596e;
        TransferProof.b[1][0] = 0x18507809ee6fd23fe1206f819c2223902f7a220246dfef87d0ef61a8dc6581a6;
        TransferProof.b[1][1] = 0x06f3d0e089c3565b56e37804c5ceb38a40dbd4ce9b2571c32551a94bf0f8291b;
        TransferProof.c[0] = 0x1a2436143837b6bd5ea5bb48e8620ecc5c7b1766d05d7272c4f577a713c1391d;
        TransferProof.c[1] = 0x2f872a8e8c949ab9799af7d7d47135d64a3f54c0801c31820d87848a531cda46;
    }
}
