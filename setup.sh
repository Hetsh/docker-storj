#!/bin/sh
set -e -u

AUTH_TOKEN="$1"
ERC20_ADDRESS="$2"
CONFIG_DIR="config"
IDENTITY_DIR="identity"

if [ ! -f "$IDENTITY_DIR/identity.key" ]; then
	identity create \
		--identity-dir . \
		"$IDENTITY_DIR"
fi

if [ ! -f "$IDENTITY_DIR"/identity.*.cert ]; then
	identity authorize \
		--config-dir "$CONFIG_DIR" \
		--identity-dir . \
		"$IDENTITY_DIR" \
		"$AUTH_TOKEN"
fi

RESULT_CA=$(grep -c BEGIN "$IDENTITY_DIR/ca.cert")
RESULT_ID=$(grep -c BEGIN "$IDENTITY_DIR/identity.cert")
if [ "$RESULT_CA" != "2" ] || [ "$RESULT_ID" != "3" ]; then
	echo "Something went wrong while authenticating identity!"
	exit -1
fi

if [ ! -f "$CONFIG_DIR/config.yaml" ]; then
	storagenode setup \
		--config-dir "$CONFIG_DIR" \
		--identity-dir "$IDENTITY_DIR" \
		--storage.path "storage" \
		--console.address "0.0.0.0:14002" \
		--operator.wallet "$ERC20_ADDRESS"
fi