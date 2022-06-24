FROM amd64/alpine:20220328
RUN apk add --no-cache \
        ca-certificates=20211220-r0

# App user
ARG APP_UID=1377
ARG APP_USER="storj"
ARG DATA_DIR="/storj"
RUN adduser --disabled-password --uid "$APP_UID" --home "$DATA_DIR" --gecos "$APP_USER" "$APP_USER"
COPY --chown="$APP_USER":"$APP_USER" setup.sh "$DATA_DIR"

# Installation
ARG APP_VERSION=1.57.2
ARG BASE_URL="https://github.com/storj/storj/releases/download/v$APP_VERSION"
RUN apk add --no-cache unzip && \
    wget --quiet \
        "$BASE_URL/identity_linux_amd64.zip" \
        "$BASE_URL/storagenode_linux_amd64.zip" \
        "$BASE_URL/uplink_linux_amd64.zip" && \
    unzip -d "/usr/bin" "*.zip" && \
    rm *.zip && \
    apk del unzip

# Volumes
ARG CONFIG_DIR="$DATA_DIR/config"
ARG STORAGE_DIR="$DATA_DIR/storage"
ARG IDENTITY_DIR="$DATA_DIR/identity"
RUN mkdir "$CONFIG_DIR" "$STORAGE_DIR" "$IDENTITY_DIR" && \
    chmod 750 "$CONFIG_DIR" "$STORAGE_DIR" "$IDENTITY_DIR" && \
    chown "$APP_USER":"$APP_USER" "$CONFIG_DIR" "$STORAGE_DIR" "$IDENTITY_DIR"
VOLUME ["$CONFIG_DIR", "$STORAGE_DIR", "$IDENTITY_DIR"]

#      DASHBOARD CORE/TCP  CORE/UDP
EXPOSE 14002/tcp 28967/tcp 28967/udp

USER "$APP_USER"
WORKDIR "$DATA_DIR"
ENV CONFIG_DIR="$CONFIG_DIR" \
    NODE_OPTS=""
ENTRYPOINT exec storagenode run \
    --config-dir "$CONFIG_DIR" \
    $NODE_OPTS
