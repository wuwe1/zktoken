const ethers = require('ethers')
const { BigNumber } = ethers
const { poseidonContract, buildPoseidon } = require("circomlibjs");

function poseidonHash(poseidon, inputs) {
    const hash = poseidon(inputs.map((x) => BigNumber.from(x).toBigInt()));
    // Make the number within the field size
    const hashStr = poseidon.F.toString(hash);
    // Make it a valid hex string
    const hashHex = BigNumber.from(hashStr).toHexString();
    // pad zero to make it 32 bytes, so that the output can be taken as a bytes32 contract argument
    const bytes32 = ethers.utils.hexZeroPad(hashHex, 32);
    return bytes32;
}

async function main() {
    inputs = process.argv.slice(2)
    if (inputs.length != 3) {
        console.log(`Usage: node ${process.argv[1]} <senderBalanceBefore> <receiverBalanceBefore> <value>`)
        return
    }
    const [senderBalanceBefore, receiverBalanceBefore, value] = inputs
    const poseidon = await buildPoseidon();
    const senderBalanceAfter = Number(senderBalanceBefore) - Number(value)
    const receiverBalanceAfter = Number(receiverBalanceBefore) + Number(value)
    hashValue = poseidonHash(poseidon, [value])
    hashSenderBalanceBefore = poseidonHash(poseidon, [senderBalanceBefore])
    hashSenderBalanceAfter = poseidonHash(poseidon, [senderBalanceAfter])
    hashReceiverBalanceBefore = poseidonHash(poseidon, [receiverBalanceBefore])
    hashReceiverBalanceAfter = poseidonHash(poseidon, [receiverBalanceAfter])
    console.log(JSON.stringify({
        hashValue,
        hashSenderBalanceBefore,
        hashSenderBalanceAfter,
        hashReceiverBalanceBefore,
        hashReceiverBalanceAfter,
        senderBalanceBefore,
        receiverBalanceBefore,
        value
    }, null, 2))
}

main().then().catch()