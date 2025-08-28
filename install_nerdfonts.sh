#!/usr/bin/env bash
"""
install_and_prove_nerdfont.sh
- Install a Nerd Font into ~/.local/share/fonts (user scope).
- Show exact family names registered with fontconfig.
- Emit glyph probes (codepoints) you can paste into terminal/Neovim.
- Render nerdfont-proof.png (if pango-view or hb-view present) so you can
  visually confirm icons immediately after install.

Usage:
chmod +x install_and_prove_nerdfont.sh

# Default (Hack Nerd Font)
./install_and_prove_nerdfont.sh

# Another family
./install_and_prove_nerdfont.sh "FiraCode Nerd Font"

# Pin a different Nerd Fonts release
NERDFONTS_VERSION=v3.2.2 ./install_and_prove_nerdfont.sh
"""




set -euo pipefail

FONT_NAME="${1:-Hack Nerd Font}"           # Display family, e.g., "Hack Nerd Font"
NERDFONTS_VERSION="${NERDFONTS_VERSION:-v3.2.1}"

archive_name_for_font() {
  case "$1" in
    "Hack Nerd Font")           echo "Hack" ;;
    "FiraCode Nerd Font")       echo "FiraCode" ;;
    "CaskaydiaCove Nerd Font")  echo "CascadiaCode" ;;
    "JetBrainsMono Nerd Font")  echo "JetBrainsMono" ;;
    "Iosevka Nerd Font")        echo "Iosevka" ;;
    "Mononoki Nerd Font")       echo "Mononoki" ;;
    "MesloLG Nerd Font")        echo "Meslo" ;;
    "RobotoMono Nerd Font")     echo "RobotoMono" ;;
    *)                          echo "$(echo "$1" | sed 's/ Nerd Font$//' | tr -d ' ')" ;;
  esac
}

have_font() {
  fc-list -q ":family=${FONT_NAME}" && return 0
  fc-list | grep -qi -- "$FONT_NAME"
}

show_matches_and_families() {
  echo "==> Fontconfig primary match (fc-match):"
  fc-match "${FONT_NAME}" || true
  echo "==> Font file for primary match:"
  fc-match -v "${FONT_NAME}" | awk -F\" '/file: /{print $2; exit}'
  echo "==> Registered family names containing 'Nerd' (unique):"
  fc-list | grep -i "nerd" | sed 's/:.*//g' | sort -u
  echo "==> Registered *Mono* variants (if any):"
  fc-list | grep -i "nerd" | grep -i "mono" | sed 's/:.*//g' | sort -u || true
}

install_font_user() {
  local base archive tmp outdir
  base="$(archive_name_for_font "$FONT_NAME")"
  archive="${base}.zip"
  tmp="$(mktemp -d)"
  outdir="${HOME}/.local/share/fonts/NerdFonts/${base}"

  echo "==> Downloading ${FONT_NAME} (${archive})"
  (
    cd "$tmp"
    curl -fL \
      "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERDFONTS_VERSION}/${archive}" \
      -o "${archive}"
    unzip -q "${archive}"
    mkdir -p "${outdir}"
    # copy only TTF/OTF faces
    find . -type f \( -iname '*.ttf' -o -iname '*.otf' \) -print -exec cp '{}' "${outdir}/" \;
  )
  echo "==> Refreshing font cache"
  fc-cache -f "${HOME}/.local/share/fonts" >/dev/null
  rm -rf "$tmp"
}

print_glyph_probe() {
  cat <<'EOF'
==> Terminal/Neovim glyph probe (copy/paste the next lines):
printf 'U+F09B github: \U0000F09B\nU+E0B0 : \U0000E0B0\nU+E0B2 : \U0000E0B2\nU+E612 devicon: \U0000E612\n'
# If your terminal profile is set to a Nerd Font family, you should see icons.

EOF
}

render_png_proof() {
  local proof="nerdfont-proof.png"
  local codepoints=$'\UF09B  \UE0B0  \UE0B2  \UE612  file:\UE612  git:\UF09B  pwrl:\UE0B0 \UE0B2'

  # Try to pick a monospace-ish variant if present
  local pick_family
  pick_family="$(fc-list | grep -i "nerd" | grep -i -m1 "mono" | sed 's/:.*//')"
  if [[ -z "${pick_family:-}" ]]; then
    # fall back to requested name
    pick_family="${FONT_NAME}"
  fi

  echo "==> Attempting to render PNG proof with: ${pick_family}"

  if command -v pango-view >/dev/null 2>&1; then
    pango-view --font="${pick_family} 18" \
      --text "${codepoints}" \
      --output "${proof}"
    echo "==> Wrote ${proof} using pango-view"
    return 0
  fi

  if command -v hb-view >/dev/null 2>&1; then
    local file
    file="$(fc-match -v "${pick_family}" | awk -F\" '/file: /{print $2; exit}')"
    if [[ -n "${file}" && -r "${file}" ]]; then
      hb-view "${file}" --size 18 --text "${codepoints}" --output "${proof}"
      echo "==> Wrote ${proof} using hb-view"
      return 0
    fi
  fi

  echo "==> Neither pango-view nor hb-view found; skipping PNG proof."
  echo "    Install:  sudo apt install pango-view  (Debian/Ubuntu: package 'pango-tools')"
  echo "           or sudo apt install harfbuzz-tools"
}

next_steps_note() {
  cat <<'EOF'

Next steps to make Neovim show icons:
  1) In your terminal emulator preferences, set the font to one of the
     *registered family names* printed above (prefer a “Mono” variant, e.g.,
     "Hack Nerd Font Mono").
  2) Restart the terminal and run the glyph probe again.
  3) For Neovim, ensure an icon plugin (e.g., nvim-web-devicons) is enabled.

EOF
}

main() {
  echo "Requested Nerd Font family: ${FONT_NAME}"
  if have_font; then
    echo "==> Font already installed and visible to fontconfig."
    show_matches_and_families
  else
    echo "==> Not found by fontconfig; installing…"
    install_font_user
    if have_font; then
      echo "==> Install OK."
      show_matches_and_families
    else
      echo "!! Still not visible to fontconfig. Troubleshoot:"
      echo "   - fc-cache -f ~/.local/share/fonts"
      echo "   - check files in ~/.local/share/fonts/NerdFonts/"
      exit 1
    fi
  fi

  print_glyph_probe
  render_png_proof
  next_steps_note
}

main "$@"

