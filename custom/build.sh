#!/bin/bash
# shellcheck disable=SC2034

# This file will be sourced by scripts/build.sh to customize the build process


IMG_NAME="hetsh/storj"
function test_image {
	docker run \
		--rm \
		--tty \
		--interactive \
		--entrypoint sh \
		--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
		"$IMG_ID"
}
