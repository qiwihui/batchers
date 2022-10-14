#!/usr/bin/env bash

# To load the variables in the .env file
source .env

# To deploy and verify our contract
forge script script/Batcher.s.sol:BatcherScript --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv
