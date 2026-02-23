FROM hetsh/alpine:20260127-2
ARG LAST_UPGRADE="2026-02-23T08:35:07+01:00"
RUN apk upgrade --no-cache && \
	apk add --no-cache \
		ca-certificates=20251003-r0

# Installation
ARG APP_VERSION=1.147.5
# ToDo: switch to ADD once .zip archives are supported
# ADD --unpack=true "https://github.com/storj/storj/releases/download/v$APP_VERSION/storagenode_linux_amd64.zip" "/usr/bin/"
ARG BASE_URL="https://github.com/storj/storj/releases/download/v$APP_VERSION"
ARG ARCHIVE="storagenode_linux_amd64.zip"
RUN apk add --no-cache unzip && \
	wget --quiet "$BASE_URL/$ARCHIVE" && \
	unzip -d "/usr/bin" "$ARCHIVE" && \
	rm "$ARCHIVE" && \
	apk del unzip

# App user
ARG APP_UID=1377
ARG APP_USER="storj"
ARG DATA_DIR="/storj"
RUN adduser \
		--disabled-password \
		--uid "$APP_UID" \
		--home "$DATA_DIR" \
		--gecos "$APP_USER" \
		--shell /sbin/nologin \
		"$APP_USER"
WORKDIR "$DATA_DIR"

USER "$APP_USER"
ENTRYPOINT ["storagenode"]
CMD ["run", "--config-dir", "/config"]
