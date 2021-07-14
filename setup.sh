#!/bin/sh
set -e -u

AUTH_TOKEN="$1"

# ToDo: Skip if identity already exists
identity create \
	--config-dir "config" \
	--identity-dir "." \
	identity
# ToDo: Skip if identity already authorized
identity authorize \
	--config-dir "config" \
	--identity-dir "." \
	identity \
	"$AUTH_TOKEN"
# ToDo: Assert successful signing
#grep -c BEGIN identity/ca.cert
#grep -c BEGIN identity/identity.cert
storagenode setup \
	--config-dir "config" \
	--identity-dir "identity" \
	--storage.path "storage" \
	--console.address "0.0.0.0:14002"
