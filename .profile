# Aliases
alias npmlsg='npm ls -g --depth 0'
alias npmls='npm ls --depth 0'

# Git Ignore
function gi() {
	curl -L -s https://www.gitignore.io/api/$@ > .gitignore
}

# NODE_ENV
export NODE_ENV="development"

# Source update-discord.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)"
source "$SCRIPT_DIR/update-discord.sh"
