# 🐧 Linux Package Finder & Installer

A simple terminal-based Bash script that helps you:

- Search for a Linux package by name using multiple AUR helpers and `pacman`
- Get quick package summaries (via `tldr`)
- View how many results are found with each tool
- Choose how to install it with a numbered prompt
- Handle `sudo` permissions for `pacman` installations

---

## 📦 Supported Package Managers

- [`yay`](https://github.com/Jguer/yay)
- [`paru`](https://github.com/Morganamilo/paru)
- `pacman` (with sudo prompt)

---

## 🧰 Prerequisites

Make sure you have the following installed:

- One or more of: `yay`, `paru`, `pacman` (pre-installed on Arch-based systems)
- Optional: [`tldr`](https://tldr.sh/) (for brief package explanations)

Install `tldr` via:

```bash
sudo pacman -S tldr
tldr --update

## Review

Watch a demo and review of the Package Manager tool here:

[![Package Manager Review Video](https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg)](https://github.com/greedoftheendless/Package-manager/blob/main/package-manager%20review.mkv)

Or simply click the link below to view the video file:

[Package Manager Review Video](https://github.com/greedoftheendless/Package-manager/blob/main/package-manager%20review.mkv)

