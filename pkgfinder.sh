#!/bin/bash

HISTORY_FILE="$HOME/.pkgmanager_history"
mkdir -p ~/.pkgmanager

trap 'echo -e "\nExiting..."; exit 0' SIGINT

main_menu() {
  while true; do
    action=$(gum choose --limit 1 "🔍 Search Package" "📂 View History" "🌟 Featured Tools" "❌ Exit")
    case "$action" in
    "🔍 Search Package") search_package ;;
    "📂 View History") view_history ;;
    "🌟 Featured Tools") featured_tools ;;
    "❌ Exit")
      echo "Goodbye!"
      exit 0
      ;;
    esac
  done
}

normalize_input() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | xargs
}

search_package() {
  while true; do
    pkg=$(gum input --placeholder "Enter package name (:m for main menu, :q to quit)")
    norm_pkg=$(normalize_input "$pkg")

    if [[ "$norm_pkg" == ":m" ]]; then
      return
    elif [[ "$norm_pkg" == ":q" ]]; then
      echo "Exiting..."
      exit 0
    elif [[ -z "$norm_pkg" ]]; then
      continue
    fi

    echo "$pkg" >>"$HISTORY_FILE"
    gum spin --title "Searching $pkg..." -- sleep 1

    for manager in yay paru pacman; do
      if command -v "$manager" &>/dev/null; then
        echo -e "\n🔧 $manager Results:"
        $manager -Ss "$pkg" | head -n 10
      else
        echo "$manager not found."
      fi
    done

    if command -v tldr &>/dev/null; then
      echo -e "\n📄 TLDR for $pkg:"
      tldr "$pkg" || echo "No TLDR entry."
    fi

    gum confirm "Install $pkg?" && install_package "$pkg"
  done
}

install_package() {
  pkg="$1"
  manager=$(gum choose yay paru pacman)
  if [[ "$manager" == "pacman" ]]; then
    gum confirm "Use sudo pacman?" && sudo pacman -S "$pkg"
  else
    $manager -S "$pkg"
  fi
}

view_history() {
  while true; do
    if [ -f "$HISTORY_FILE" ]; then
      selection=$(gum filter --placeholder "Search history (:m for main menu)" <"$HISTORY_FILE")
      norm_sel=$(normalize_input "$selection")

      if [[ "$norm_sel" == ":m" || -z "$selection" ]]; then
        return
      else
        echo "You selected: $selection"
      fi
    else
      echo "No history yet."
      sleep 2
      return
    fi
  done
}

featured_tools() {
  while true; do
    tag=$(gum input --placeholder "Enter tag or keyword (e.g. editor, dev, network) or :m for main menu")
    norm_tag=$(normalize_input "$tag")

    if [[ "$norm_tag" == ":m" ]]; then
      return
    elif [[ -z "$norm_tag" ]]; then
      continue
    fi

    echo -e "\n🔍 Searching for tools matching tag '$norm_tag'...\n"

    if command -v yay &>/dev/null; then
      results=$(yay -Ss "$norm_tag" | grep -E "^[a-z0-9]" | cut -d/ -f2 | awk '{print $1}' | sort -u)
    elif command -v paru &>/dev/null; then
      results=$(paru -Ss "$norm_tag" | grep -E "^[a-z0-9]" | cut -d/ -f2 | awk '{print $1}' | sort -u)
    else
      results=$(pacman -Ss "$norm_tag" | grep -E "^[a-z0-9]" | cut -d/ -f2 | awk '{print $1}' | sort -u)
    fi

    if [ -z "$results" ]; then
      echo "🚫 No packages found for '$norm_tag'."
      sleep 2
      continue
    fi

    selection=$(echo "$results" | gum filter --placeholder "Select a package to install or type :m")
    norm_sel=$(normalize_input "$selection")

    if [[ "$norm_sel" == ":m" || -z "$selection" ]]; then
      continue
    else
      gum confirm "Install $selection?" && install_package "$selection"
    fi
  done
}

main_menu
