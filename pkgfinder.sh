#!/bin/bash

read -p "Enter package name to search: " pkg

declare -A results
declare -A cmds
managers=("yay" "paru" "pacman")

for manager in "${managers[@]}"; do
  echo -e "\nSearching with $manager..."
  if ! command -v $manager &>/dev/null; then
    echo "$manager not installed, skipping."
    continue
  fi

  matches=$($manager -Ss "$pkg" 2>/dev/null | wc -l)
  echo "$matches results found with $manager."
  results[$manager]=$matches

  if ((matches > 0)); then
    cmds[$manager]="$manager -S $pkg"
  fi
done

echo -e "\nInstallation commands:"
i=1
declare -A options

for manager in "${managers[@]}"; do
  if [[ ${results[$manager]} -gt 0 ]]; then
    echo "$i) ${cmds[$manager]}"
    options[$i]="${cmds[$manager]}"
    ((i++))
  fi
done

echo -e "\nSummary (from tldr):"
if command -v tldr &>/dev/null; then
  tldr "$pkg" || echo "No tldr entry found."
else
  echo "tldr command not found, install it to see package summaries."
fi

read -p "Enter the number to install (or press Enter to skip): " choice

if [[ -z "$choice" ]]; then
  echo "Install skipped."
  exit 0
fi

if [[ -z "${options[$choice]}" ]]; then
  echo "Invalid choice."
  exit 1
fi

selected_cmd=${options[$choice]}
selected_manager=$(echo "$selected_cmd" | awk '{print $1}')

if [[ "$selected_manager" == "pacman" ]]; then
  echo "⚠️ Running through pacman requires root (sudo) permission."
  read -p "Proceed with sudo? (y/n): " yn
  case $yn in
  [Yy]*)
    sudo $selected_cmd
    ;;
  [Nn]*)
    # Ask if want to try other managers
    echo "Do you want to try installing through other package managers? (y/n): "
    read try_others
    case $try_others in
    [Yy]*)
      echo "Available alternative package managers:"
      alt_i=1
      declare -A alt_options
      for mgr in "yay" "paru"; do
        if [[ $mgr != "pacman" && ${results[$mgr]} -gt 0 ]]; then
          echo "$alt_i) ${cmds[$mgr]}"
          alt_options[$alt_i]="${cmds[$mgr]}"
          ((alt_i++))
        fi
      done
      if [[ ${#alt_options[@]} -eq 0 ]]; then
        echo "No alternative package managers available."
        exit 0
      fi
      read -p "Enter the number to install (or press Enter to skip): " alt_choice
      if [[ -n "${alt_options[$alt_choice]}" ]]; then
        ${alt_options[$alt_choice]}
      else
        echo "No valid choice made. Exiting."
      fi
      ;;
    *)
      echo "User exited."
      ;;
    esac
    ;;
  *)
    echo "Invalid input. Exiting."
    ;;
  esac
else
  $selected_cmd
fi
