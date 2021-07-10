**This Project is still work in progress.**

# Storj Node
Simple to set up Storj node.

## Running the server
```bash
docker run --detach --name storj --publish 14002:14002/tcp --publish 28967:28967/tcp --publish 28967:28967/udp hetsh/storj
```

## Stopping the container
```bash
docker stop storj
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
The user must have RW access to the storage directory.
Start the server with the additional mount flags:
```bash
docker run \
    --mount type=bind,source=/path/to/config,target=/storj/config
    --mount type=bind,source=/path/to/storage,target=/storj/storage
    --mount type=bind,source=/path/to/identity,target=/storj/identity ...
```

## Time
Synchronizing the timezones will display the correct time in the logs.
The timezone can be shared with this mount flag:
```bash
docker run --mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly ...
```

## Automate startup and shutdown via systemd
The systemd unit can be found in my GitHub [repository](https://github.com/Hetsh/docker-storj).
```bash
systemctl enable storj --now
```
By default, the systemd service assumes `/apps/storj/config` for config, `/apps/storj/storage` for storage, `/apps/storj/identity` for identity and `/etc/localtime` for timezone.
Since this is a personal systemd unit file, you might need to adjust some parameters to suit your setup.

## Fork Me!
This is an open project hosted on [GitHub](https://github.com/Hetsh/docker-storj).
Please feel free to ask questions, file an issue or contribute to it.
