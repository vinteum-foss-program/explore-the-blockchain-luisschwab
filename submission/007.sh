#!/bin/sh

# Only a single output remains unspent from block 123,321. What address was it sent to?

BLOCKHASH=$(bitcoin-cli getblockhash 123321)
readarray -t TRANSACTIONS < <(bitcoin-cli getblock $BLOCKHASH | jq -r .tx[])

# iterate over all outputs on the block, call `gettxout` and return address
for TXID in "${TRANSACTIONS[@]}"
do  
    TX=$(bitcoin-cli getrawtransaction "$TXID" 1 | jq -c .)    # Added -c here to get compact output
    readarray -t OUTPUTS < <(echo "$TX" | jq -c .vout[])

    for OUTPUT in "${OUTPUTS[@]}"
    do
        # check if this output is in the UTXO set
        # null if not so
        VOUT_INDEX=$(echo $OUTPUT | jq -r .n)
        UNSPENT=$(bitcoin-cli gettxout $TXID $VOUT_INDEX)

        if [[ $UNSPENT ]]
        then
            ADDRESS=$(echo $UNSPENT | jq -r .scriptPubKey.address)
            echo $ADDRESS
        fi
    done
done
