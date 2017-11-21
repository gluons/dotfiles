# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
	fi
fi

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

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
