#!/bin/sh

# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`

# get the 4 public keys
TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"
TX=$(bitcoin-cli getrawtransaction $TXID 1)

PUBKEY_0=$(echo $TX | jq .vin[0].txinwitness[1])
PUBKEY_1=$(echo $TX | jq .vin[1].txinwitness[1])
PUBKEY_2=$(echo $TX | jq .vin[2].txinwitness[1])
PUBKEY_3=$(echo $TX | jq .vin[3].txinwitness[1])

# make a 1-of-4 p2sh multisig address from these keys
P2SH_ADDRESS=$(bitcoin-cli createmultisig 1 "[$PUBKEY_0, $PUBKEY_1, $PUBKEY_2, $PUBKEY_3]" "legacy" | jq -r .address)

echo $P2SH_ADDRESS

