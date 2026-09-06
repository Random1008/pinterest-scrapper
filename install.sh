#!/bin/sh
# pin — installation Linux / macOS / BSD.
# Dépose la commande `pin` dans le premier dossier exécutable du PATH
# (~/.local/bin en priorité, sinon /usr/local/bin).
set -e

if ! command -v python3 >/dev/null 2>&1; then
    echo "Erreur : python3 est requis mais introuvable dans le PATH." >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/pin"
if [ ! -r "$SRC" ]; then
    echo "Erreur : fichier '$SRC' introuvable (placez install.sh à côté de pin)." >&2
    exit 1
fi

# Choisir le dossier d'installation
BIN_DIR=""
for d in "$HOME/.local/bin" "/usr/local/bin" "/usr/bin"; do
    case ":$PATH:" in
        *":$d:"*) BIN_DIR="$d"; break ;;
    esac
done
[ -n "$BIN_DIR" ] || BIN_DIR="$HOME/.local/bin"

mkdir -p "$BIN_DIR" 2>/dev/null || true

if [ -w "$BIN_DIR" ]; then
    cp "$SRC" "$BIN_DIR/pin"
else
    echo "$BIN_DIR n'est pas accessible en écriture → tentative avec sudo…"
    sudo cp "$SRC" "$BIN_DIR/pin"
fi
chmod +x "$BIN_DIR/pin"

echo
echo "Installé : $BIN_DIR/pin"
echo
echo "Utilisation :"
echo "  pin -s <lien tableau>"
echo "  pin -d <lien tableau> <dossier>"
echo "  pin -h"
echo
if ! command -v pin >/dev/null 2>&1; then
    echo "La commande n'est pas encore dans le PATH de ce terminal :"
    echo "  - ouvrez un nouveau terminal, ou"
    echo "  - lancez directement : python3 $SRC -s <lien tableau>"
fi
