#!/bin/bash
# shellcheck disable=SC2034

# This file will be sourced by scripts/update.sh to customize the update process


GIT_VERSION="$(git describe --tags --first-parent --abbrev=0)"
MAIN_ITEM="APP_VERSION"
function check_for_updates {
	update_base_image "\\d{8}-\\d+"
	update_packages "hetsh/storj"
	update_github "storj/storj" "APP_VERSION" "(\d+\.)*\d+" "Storj Node"
}