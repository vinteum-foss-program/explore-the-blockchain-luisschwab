# Which tx in block 257,343 spends the coinbase output of block 256,128?

BLOCKHASH_CREATED=$(bitcoin-cli getblockhash 256128)

# coinbase output of 256,128 has the outpoint 611c5a0972d28e421a2308cb2a2adb8f369bb003b96eb04a3ec781bf295b74bc:0
COINBASE_TXID=$(bitcoin-cli getblock $BLOCKHASH_CREATED | jq -r .tx[0])
COINBASE_VOUT=0

# iterate over transaction inputs and check if txid and vout are a match for the coinbase from 256,128
BLOCKHASH_SPENT=$(bitcoin-cli getblockhash 257343)

# get transactions
TRANSACTIONS=$(bitcoin-cli getblock $BLOCKHASH_SPENT | jq -r .tx[])

# check each input on each transaction for a spend of the coinbase from 256,128
for TXID in $TRANSACTIONS
do
    readarray -t INPUTS < <(bitcoin-cli getrawtransaction $TXID 1 | jq -c .vin[])
    
    for INPUT in "${INPUTS[@]}"
    do
        CANDIDATE_PREVOUT=$(echo "$INPUT" | jq -r .txid)
        CANDIDATE_VOUT=$(echo "$INPUT" | jq -r .vout)
        if [[ $COINBASE_TXID == $CANDIDATE_PREVOUT && $COINBASE_VOUT == $CANDIDATE_VOUT ]]
        then
            echo $TXID
            exit 0
        fi
    done
done

