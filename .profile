# Git Ignore
function gi() {
	curl -L -s https://www.gitignore.io/api/$@ > .gitignore
}

# Packages updater.
function u {
	clear

	# Global Update
	if [ -x "$(command -v npm)" ]; then
		npm update -g
	fi
	if [ -x "$(command -v yarn)" ]; then
		yarn global upgrade
	fi
	if [ -x "$(command -v apm)" ]; then
		apm upgrade --verbose --no-confirm
	fi
	if [ -x "$(command -v gem)" ]; then
		gem update --system
		gem update
		gem clean
	fi
}
# Ubuntu packages updater.
function uu {
	clear

	sudo apt-get update && sudo apt-get dist-upgrade
}
# Update Ubuntu packages & global programming packages.
function uuu {
	clear

	uu && u
}

# NODE_ENV
export NODE_ENV="development"
