update-discord() (
	set -eu
	(set -o pipefail 2>/dev/null) || true

	DISCORD_URL="https://discord.com/api/download?platform=linux&format=tar.gz"
	INSTALL_DIR="$HOME/Apps"
	TARGET_DIR="$INSTALL_DIR/Discord"

	TMP_DIR="$(mktemp -d)"
	trap 'rm -rf "$TMP_DIR"' EXIT

	echo "📥 Downloading latest Discord..."
	curl -L "$DISCORD_URL" -o "$TMP_DIR/discord.tar.gz"

	echo "📦 Extracting..."
	tar -xzf "$TMP_DIR/discord.tar.gz" -C "$TMP_DIR"

	SRC_DIR="$TMP_DIR/Discord"
	if [[ ! -d "$SRC_DIR" ]]; then
	echo "❌ Extracted Discord directory not found"
	exit 1
	fi

	echo "🔁 Updating Discord files (no deletion)..."
	mkdir -p "$TARGET_DIR"
	cp -aT "$SRC_DIR" "$TARGET_DIR"

	echo "✅ Discord updated successfully at $TARGET_DIR"
)
