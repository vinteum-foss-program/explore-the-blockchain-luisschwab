#!/bin/sh

# Using descriptors, compute the taproot address at index 100 derived from this extended public key:
#   `xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2`

# derivation path primer:
# master_key/purpose’/coin_type’/account’/change/address_index

# taproot uses this derviation path: m/86h/0h/0h
# the 101st (index starts from 0) taproot address will have this path: m/86h/0h/0h/0/100

XPUB="xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2"

DESCRIPTOR=$(bitcoin-cli getdescriptorinfo "tr($XPUB/100)" | jq -r .descriptor)

TAPROOT_100=$(bitcoin-cli deriveaddresses $DESCRIPTOR | jq -r .[0])

echo $TAPROOT_100

