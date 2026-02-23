# Storj Node
Simple to set up Storj node.

## Running the server
Storj needs to be configured first.
Use their [Guide](https://storj.dev/node/get-started/setup) to get started.

This image starts `storagenode` with parameters `run --config-dir /config`.
However, you can override them:
```bash
docker run ... hetsh/storj <command> <parameters>
```

## Creating persistent storage
```bash
CONFIG="/path/to/config"
STORAGE="/path/to/storage"
IDENTITY="/path/to/identity"
mkdir -p "$CONFIG" "$STORAGE" "$IDENTITY"
chown 1377:1377 "$CONFIG" "$STORAGE" "$IDENTITY"
```
`1377` is the numerical id of the user running the server (see Dockerfile).
The user must have RW access to these directories.
Start the server with additional mount parameters:
```bash
docker run \
	--mount type=bind,source=/path/to/config,target=/config \
	--mount type=bind,source=/path/to/storage,target=/storage \
	--mount type=bind,source=/path/to/identity,target=/identity \
	...
```

## Time
Synchronizing the timezones will display the correct time in the logs.
The timezone can be shared with this mount flag:
```bash
docker run \
	--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
	...
```
