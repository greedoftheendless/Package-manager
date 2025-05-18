# pkgmanager — A Terminal UI Package Manager Helper

`pkgmanager` is a simple **Bash-based terminal UI (TUI) tool** to help you search, compare, and install packages from Arch Linux package managers (`pacman`, `yay`, `paru`). It also tracks your history and lets you explore featured tools by tags.

---

## Features

- 🔍 **Search packages** across `pacman`, `yay`, and `paru` with concise results.
- 📂 **View history** of searched packages with interactive search.
- 🌟 **Featured tools** browsing by tags using official `pacman` groups.
- ✅ Install selected packages directly through your chosen package manager.
- 🧭 Easy navigation with commands:
  - Type `:m` anytime in inputs to **go back to the main menu**.
  - Type `:q` (in search) or press `Ctrl+C` to **quit the tool** gracefully.

---

## Requirements

- Bash shell
- [gum](https://github.com/charmbracelet/gum) — for interactive UI prompts.
- Arch Linux environment with `pacman` installed.
- Optional but recommended: `yay` and/or `paru` for AUR support.
- Optional: `tldr` command for package summaries.

---

## Installation

1. Clone or download this script.

2. Make it executable:

```bash
chmod +x pkgmanager.sh


Hope you find this tool useful
