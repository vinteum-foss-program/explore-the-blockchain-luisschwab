#!/bin/sh

# How many new outputs were created by block 123,456?

# simple way:
# bitcoin-cli getblockstats 123456 | jq .outs

# less simple way
# get hash of block 123,456
hash=$(bitcoin-cli getblockhash 123456)

# get block's txid array
txs=$(bitcoin-cli getblock $hash | jq -r .tx[])

# for each txid, get the raw transaction, decode it, and get the vout lenght
block_outputs=0
for tx in $txs
do
    tx_hex=$(bitcoin-cli getrawtransaction $tx)

    tx_outputs=$(bitcoin-cli decoderawtransaction $tx_hex | jq '.vout | length')

    block_outputs=$((block_outputs + tx_outputs))
done

echo $block_outputs

