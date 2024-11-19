#!/bin/sh

# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`

TXID="e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"
TRANSACTION=$(bitcoin-cli getrawtransaction $TXID 1)

# get the pubkey from witness' TLV
# OF_IF OP_PUSHBYTES_33 <PUBKEY> ...
PUBKEY=$(echo $TRANSACTION | jq -r .vin[0].txinwitness[2][4:70])

echo $PUBKEY
