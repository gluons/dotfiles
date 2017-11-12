#!/usr/bin/env bash

# Alias
alias firefox-nightly='firefox-trunk'

# Git Ignore
function gi() {
	curl -L -s https://www.gitignore.io/api/$@ > .gitignore
}

# Update helper
function u {
	clear

	# Global Update
	npm update -g
	yarn global upgrade
	apm upgrade --verbose --no-confirm
	gem update --system
	gem update
	gem clean
}
function uu {
	clear

	sudo apt-get update && sudo apt-get dist-upgrade
}
function uuu {
	clear

	uu && u
}

# NODE_ENV
export NODE_ENV="development"

# Firefox
export FIREFOX_DEVELOPER_BIN="$(which firefox-trunk)"
export WEB_EXT_FIREFOX="$(which firefox-trunk)"
