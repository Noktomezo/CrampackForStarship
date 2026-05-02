#!/usr/bin/env bash

clear

BASE_URL="https://raw.githubusercontent.com/Noktomezo/CrampackForStarship/refs/heads/main"
CONFIG_DIR="$HOME/.config"

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"
INVERSE="\033[7m"

if command -v starship >/dev/null 2>&1; then
    echo -e "[${GREEN}+${RESET}] ${GREEN}Starship is installed. Proceeding with preset installation...${RESET}"
    sleep 1
    clear
else
    echo -e "[${RED}x${RESET}] ${RED}Starship is NOT installed.${RESET}"
    echo -e "[${RED}x${RESET}] ${RED}Please install Starship first from https://starship.rs/ and add it to your PATH.${RESET}"
    echo -e "[${RED}x${RESET}] ${RED}Installation will continue, but the preset won't take effect until Starship is installed.${RESET}\n"
    sleep 3
fi

if [ ! -d "$CONFIG_DIR" ]; then
    echo -e "[${YELLOW}!${RESET}] ${YELLOW}Starship config directory does not exist.${RESET}"
    echo -e "[${YELLOW}~${RESET}] ${YELLOW}Creating directory...${RESET}\n"
    mkdir -p "$CONFIG_DIR"
fi

valid=false
while [ "$valid" = false ]; do
    echo -e "[${CYAN}#${RESET}] Select preset to install:\n"
    echo -e "[${CYAN}1${RESET}] Standard preset ${DIM}[${YELLOW}Requires Nerd Font${RESET}${DIM}]${RESET}"
    echo -e "[${CYAN}2${RESET}] Plain text preset"
    echo -e "[${CYAN}3${RESET}] Emoji preset"
    echo -e "[${CYAN}4${RESET}] Full text preset"
    echo -ne "\n[${CYAN}#${RESET}] Enter your choice (${CYAN}1${RESET}-${CYAN}4${RESET}): "
    read -r choice

    choice=$(echo "$choice" | xargs)

    if [ -z "$choice" ]; then
        clear
        echo -e "[${RED}x${RESET}] ${RED}No input provided. Please enter 1, 2, 3 or 4.${RESET}\n"
        continue
    fi

    case $choice in
        1)
            url="$BASE_URL/themes/crampack.toml"
            valid=true
            clear
            echo -e "[${CYAN}#${RESET}] ${CYAN}Selected ${INVERSE}Standard${RESET} ${CYAN}preset${RESET}"
        ;;
        2)
            url="$BASE_URL/themes/crampack-plain-text.toml"
            valid=true
            clear
            echo -e "[${CYAN}#${RESET}] ${CYAN}Selected ${INVERSE}Plain text${RESET} ${CYAN}preset${RESET}"
        ;;
        3)
            url="$BASE_URL/themes/crampack-emoji.toml"
            valid=true
            clear
            echo -e "[${CYAN}#${RESET}] ${CYAN}Selected ${INVERSE}Emoji${RESET} ${CYAN}preset${RESET}"
        ;;
        4)
            url="$BASE_URL/themes/crampack-full-text.toml"
            valid=true
            clear
            echo -e "[${CYAN}#${RESET}] ${CYAN}Selected ${INVERSE}Full text${RESET} ${CYAN}preset${RESET}"
        ;;
        *)
            clear
            echo -e "[${RED}x${RESET}] ${RED}Invalid choice ${INVERSE}$choice${RESET}${RED}. Please enter 1, 2, 3 or 4.${RESET}\n"
        ;;
    esac
done

echo -e "[${YELLOW}~${RESET}] ${YELLOW}Downloading and installing ${INVERSE}$(basename "$url")${RESET}${YELLOW}...${RESET}"
curl_output=$(curl -fsSL "$url" -o "$CONFIG_DIR/starship.toml" 2>&1)
if [ $? -eq 0 ]; then
    echo -e "[${GREEN}+${RESET}] ${GREEN}Installation complete!${RESET}"
else
    echo -e "[${RED}x${RESET}] ${RED}Error downloading preset: $curl_output${RESET}"
    echo -e "[${RED}x${RESET}] ${RED}Check your internet connection or repo URL.${RESET}"
    exit 1
fi

if ! command -v starship >/dev/null 2>&1; then
    echo -e "\n[${YELLOW}!${RESET}] ${YELLOW}Reminder: Install Starship to activate the preset!${RESET}"
fi
