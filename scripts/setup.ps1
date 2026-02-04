Clear-Host

$BASE_URL = "https://raw.githubusercontent.com/Noktomezo/CrampackForStarship/refs/heads/main"
$CONFIG_DIR = "$HOME\.config"

$RED = "[31m"
$GREEN = "[32m"
$YELLOW = "[33m"
$BLUE = "[34m"
$BOLD = "[1m"
$DIM = "[2m"
$RESET = "[0m"
$INVERSE = "[7m"

if (Get-Command starship -ErrorAction SilentlyContinue) {
  Write-Host "[${GREEN}+${RESET}] ${GREEN}Starship is installed. Proceeding with preset installation...${RESET}"
  Start-Sleep -Seconds 1
  Clear-Host
}
else {
  Write-Host "[${RED}x${RESET}] ${RED}Starship is NOT installed.${RESET}"
  Write-Host "[${RED}x${RESET}] ${RED}Please install Starship first from https://starship.rs/ and add it to your PATH.${RESET}"
  Write-Host "[${RED}x${RESET}] ${RED}Installation will continue, but the preset won't take effect until Starship is installed.${RESET}`n"
  Start-Sleep -Seconds 3
}

if (-not (Test-Path $CONFIG_DIR)) {
  Write-Host "[${YELLOW}!${RESET}] ${YELLOW}Starship config directory does not exist.${RESET}"
  Write-Host "[${YELLOW}~${RESET}] ${YELLOW}Creating directory...${RESET}`n"
  New-Item -Path $CONFIG_DIR -ItemType Directory -Force | Out-Null
}

$valid = $false
while (-not $valid) {
  Write-Host "[${BLUE}`#${RESET}] Select preset to install:`n"
  Write-Host "[${BLUE}1${RESET}] Standard preset ${DIM}[${YELLOW}Requires Nerd Font${RESET}${DIM}]${RESET}"
  Write-Host "[${BLUE}2${RESET}] Plain text preset"
  $choice = Read-Host "`n[${BLUE}`#${RESET}] Enter your choice (${BLUE}1${RESET}-${BLUE}2${RESET})"

  $choice = $choice.Trim()

  if ([string]::IsNullOrEmpty($choice)) {
    Clear-Host
    Write-Host "[${RED}x${RESET}] ${RED}No input provided. Please enter 1 or 2.${RESET}`n"
    continue
  }

  switch ($choice) {
    "1" {
      $url = "$BASE_URL/themes/crampack.toml"
      $valid = $true
      Clear-Host
      Write-Host "[${BLUE}`#${RESET}] ${BLUE}Selected ${INVERSE}Standard${RESET} ${BLUE}preset${RESET}"
    }
    "2" {
      $url = "$BASE_URL/themes/crampack-plain-text.toml"
      $valid = $true
      Clear-Host
      Write-Host "[${BLUE}`#${RESET}] ${BLUE}Selected ${INVERSE}Plain text${RESET} ${BLUE}preset${RESET}"
    }
    default {
      Clear-Host
      Write-Host "[${RED}x${RESET}] ${RED}Invalid choice ${INVERSE}${choice}${RESET}${RED}. Please enter 1 or 2.${RESET}`n"
    }
  }
}

Write-Host "[${YELLOW}~${RESET}] ${YELLOW}Downloading and installing ${INVERSE}$([System.IO.Path]::GetFileName($url))${RESET}${YELLOW}...${RESET}"
try {
  Invoke-WebRequest -Uri $url -OutFile "${CONFIG_DIR}\starship.toml" -UseBasicParsing
  Write-Host "[${GREEN}+${RESET}] ${GREEN}Installation complete!${RESET}"
}
catch {
  Write-Host "[${RED}x${RESET}] ${RED}Error downloading preset: $($_.Exception.Message)${RESET}"
  Write-Host "[${RED}x${RESET}] ${RED}Check your internet connection or repo URL.${RESET}"
  exit 1
}

if (-not (Get-Command starship -ErrorAction SilentlyContinue)) {
  Write-Host "`n[${YELLOW}!${RESET}] ${YELLOW}Reminder: Install Starship to activate the preset!${RESET}"
}
