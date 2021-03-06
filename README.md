# zktoken

A token which hide balance using zk. Based on [circom-starter](https://github.com/0xPARC/circom-starter) and [foundry](https://github.com/foundry-rs/foundry)

## Install

`yarn` to install dependencies

## Development builds

### circom

`yarn circom:dev` to build deterministic development circuits.

Further, for debugging purposes, you may wish to inspect the intermediate files. This is possible with the `--debug` flag which the `circom:dev` task enables by default. You'll find them (by default) in `artifacts/circom/`

To build a single circuit during development, you can use the `--circuit` CLI parameter. For example, if you make a change to `hash.circom` and you want to _only_ rebuild that, you can run `yarn circom:dev --circuit hash`.

```bash
# calculate witness
npx snarkjs wtns calculate circuits/transfer.wasm circuits/transfer.json circuits/transfer.wtns

# generate proof
npx snarkjs groth16 prove circuits/transfer.zkey circuits/transfer.wtns circuits/proof.json circuits/public.json

# verify proof
npx snarkjs groth16 verify circuits/transfer.vkey.json circuits/public.json circuits/proof.json
```


## Production builds

### circom

`yarn circom:prod` for production builds (using `Date.now()` as entropy)
