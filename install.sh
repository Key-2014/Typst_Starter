#!/bin/sh
set -e

# Typst Starter macOS / Linux Installer Script
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Key-2014/Typst_Starter/main/install.sh | sh

REPO_OWNER="Key-2014"
REPO_NAME="Typst_Starter"

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin)
    TARGET_OS="darwin"
    ;;
  Linux)
    TARGET_OS="linux"
    ;;
  *)
    echo "[ERROR] Unsupported operating system: $OS"
    exit 1
    ;;
esac

case "$ARCH" in
  x86_64|amd64)
    TARGET_ARCH="amd64"
    ;;
  arm64|aarch64)
    TARGET_ARCH="arm64"
    ;;
  *)
    echo "[ERROR] Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

ASSET_NAME="Typst-Starter-Setup-${TARGET_OS}-${TARGET_ARCH}"
DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/latest/download/${ASSET_NAME}"

BIN_DIR="${HOME}/.local/bin"
BIN_PATH="${BIN_DIR}/typst-starter"

echo "=================================================="
echo "         Typst Starter Quick Installer            "
echo "=================================================="
echo ""

mkdir -p "$BIN_DIR"

echo "[1/2] Downloading latest Typst Starter (${TARGET_OS}/${TARGET_ARCH})..."
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$DOWNLOAD_URL" -o "$BIN_PATH"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$BIN_PATH" "$DOWNLOAD_URL"
else
  echo "[ERROR] Neither curl nor wget was found."
  exit 1
fi

chmod +x "$BIN_PATH"

if [ "$TARGET_OS" = "darwin" ]; then
  xattr -d com.apple.quarantine "$BIN_PATH" 2>/dev/null || true
fi

echo "      [OK] Downloaded to: $BIN_PATH"
echo ""

echo "[2/2] Running setup..."
"$BIN_PATH" --silent

echo ""
echo "=================================================="
echo " Installation Complete!"
echo "=================================================="
echo ""
echo "Commands available:"
echo "  typst-starter update            Update package to latest"
echo "  typst-starter init              Create a report project"
echo "  typst-starter init thesis       Create a thesis project"
echo "  typst-starter init slide        Create a slide project"
echo ""

case ":$PATH:" in
  *:"$BIN_DIR":*) ;;
  *)
    echo "[NOTE] $BIN_DIR is not currently in your PATH."
    echo "       Add the following line to your ~/.zshrc or ~/.bashrc:"
    echo "         export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    ;;
esac
