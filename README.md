#!/bin/bash

# ============================================================
#   BATTERY TWEAK - macOS Service Manager
#   Author  : Frosty
#   Version : 1.0.0
# ============================================================

# ── Colors ──────────────────────────────────────────────────
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

BLACK='\033[30m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'

BG_BLACK='\033[40m'
BG_GREEN='\033[42m'
BG_RED='\033[41m'
BG_YELLOW='\033[43m'
BG_CYAN='\033[46m'
BG_MAGENTA='\033[45m'

# ── Services ─────────────────────────────────────────────────
SERVICES=(
  "com.apple.siriinferenced"
  "com.apple.siriknowledged"
  "com.apple.wifianalyticsd"
  "com.apple.duetexpertd"
  "com.apple.coreduetd"
  "com.apple.analyticsd"
  "com.apple.nanobackupd"
  "com.apple.tipsd"
  "com.apple.assistantd"
)

SERVICE_LABELS=(
  "Siri Inference"
  "Siri Knowledge"
  "WiFi Analytics"
  "Duet Expert"
  "Core Duet"
  "Analytics"
  "Nano Backup"
  "Tips"
  "Assistant"
)

# ── Banner ────────────────────────────────────────────────────
print_banner() {
  clear
  echo ""
  echo -e "${BOLD}${CYAN}"
  echo "  ██████╗  █████╗ ████████╗████████╗███████╗██████╗ ██╗   ██╗"
  echo "  ██╔══██╗██╔══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗╚██╗ ██╔╝"
  echo "  ██████╔╝███████║   ██║      ██║   █████╗  ██████╔╝ ╚████╔╝ "
  echo "  ██╔══██╗██╔══██║   ██║      ██║   ██╔══╝  ██╔══██╗  ╚██╔╝  "
  echo "  ██████╔╝██║  ██║   ██║      ██║   ███████╗██║  ██║   ██║   "
  echo "  ╚═════╝ ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝   "
  echo -e "${RESET}"
  echo -e "  ${DIM}${WHITE}████████╗██╗    ██╗███████╗ █████╗ ██╗  ██╗${RESET}"
  echo -e "  ${DIM}${WHITE}╚══██╔══╝██║    ██║██╔════╝██╔══██╗██║ ██╔╝${RESET}"
  echo -e "  ${DIM}${WHITE}   ██║   ██║ █╗ ██║█████╗  ███████║█████╔╝ ${RESET}"
  echo -e "  ${DIM}${WHITE}   ██║   ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ${RESET}"
  echo -e "  ${DIM}${WHITE}   ██║   ╚███╔███╔╝███████╗██║  ██║██║  ██╗${RESET}"
  echo -e "  ${DIM}${WHITE}   ╚═╝    ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝${RESET}"
  echo ""
  echo -e "  ${DIM}${CYAN}╔══════════════════════════════════════════════════════════╗${RESET}"
  echo -e "  ${DIM}${CYAN}║${RESET}  ${BOLD}${YELLOW}⚡ macOS Battery Optimizer — Service Manager v1.0${RESET}       ${DIM}${CYAN}║${RESET}"
  echo -e "  ${DIM}${CYAN}║${RESET}  ${DIM}${WHITE}Disable/Enable background services to save battery${RESET}      ${DIM}${CYAN}║${RESET}"
  echo -e "  ${DIM}${CYAN}╚══════════════════════════════════════════════════════════╝${RESET}"
  echo ""
}

# ── Divider ───────────────────────────────────────────────────
print_divider() {
  echo -e "  ${DIM}${CYAN}──────────────────────────────────────────────────────────${RESET}"
}

# ── Status check per service ──────────────────────────────────
get_service_status() {
  local service="$1"
  local result
  result=$(sudo launchctl list "$service" 2>/dev/null)
  if [ $? -eq 0 ]; then
    echo "ON"
  else
    echo "OFF"
  fi
}

# ── Show service status table ─────────────────────────────────
show_status() {
  echo -e "  ${BOLD}${WHITE}SERVICE STATUS${RESET}"
  print_divider
  printf "  ${BOLD}%-4s %-24s %-18s %-6s${RESET}\n" "No." "Service" "Label" "Status"
  print_divider

  local i=0
  for service in "${SERVICES[@]}"; do
    local label="${SERVICE_LABELS[$i]}"
    local status
    status=$(get_service_status "$service")

    if [ "$status" = "ON" ]; then
      printf "  ${DIM}%02d.${RESET}  %-24s %-18s " "$((i+1))" "$service" "$label"
      echo -e "${BOLD}${GREEN}[  ON  ]${RESET}"
    else
      printf "  ${DIM}%02d.${RESET}  %-24s %-18s " "$((i+1))" "$service" "$label"
      echo -e "${DIM}${RED}[ OFF  ]${RESET}"
    fi
    i=$((i+1))
  done
  print_divider
}

# ── Disable all services (OFF) ────────────────────────────────
disable_services() {
  echo ""
  echo -e "  ${BOLD}${RED}⛔  DISABLING SERVICES...${RESET}"
  print_divider

  local i=0
  for service in "${SERVICES[@]}"; do
    local label="${SERVICE_LABELS[$i]}"
    printf "  ${DIM}%-28s${RESET} → " "$label"

    sudo launchctl bootout system/"$service" 2>/dev/null
    sudo launchctl disable system/"$service" 2>/dev/null

    echo -e "${BOLD}${RED}DISABLED${RESET}"
    i=$((i+1))
  done

  print_divider
  echo ""
  echo -e "  ${BOLD}${GREEN}✔  Semua service berhasil di-disable!${RESET}"
  echo -e "  ${DIM}${YELLOW}⚠  Lakukan respring/restart manual untuk efek penuh.${RESET}"
  echo ""
}

# ── Enable all services (ON) ──────────────────────────────────
enable_services() {
  echo ""
  echo -e "  ${BOLD}${GREEN}✅  ENABLING SERVICES...${RESET}"
  print_divider

  local i=0
  for service in "${SERVICES[@]}"; do
    local label="${SERVICE_LABELS[$i]}"
    printf "  ${DIM}%-28s${RESET} → " "$label"

    sudo launchctl enable system/"$service" 2>/dev/null
    sudo launchctl bootstrap system /System/Library/LaunchDaemons/"$service".plist 2>/dev/null

    echo -e "${BOLD}${GREEN}ENABLED${RESET}"
    i=$((i+1))
  done

  print_divider
  echo ""
  echo -e "  ${BOLD}${GREEN}✔  Semua service berhasil di-enable!${RESET}"
  echo -e "  ${DIM}${YELLOW}⚠  Lakukan respring/restart manual untuk efek penuh.${RESET}"
  echo ""
}

# ── Menu ──────────────────────────────────────────────────────
show_menu() {
  echo -e "  ${BOLD}${WHITE}MENU UTAMA${RESET}"
  print_divider
  echo -e "  ${BOLD}${RED} [1]${RESET}  🔴  ${BOLD}OFF${RESET}  — Disable semua service (hemat baterai)"
  echo -e "  ${BOLD}${GREEN} [2]${RESET}  🟢  ${BOLD}ON${RESET}   — Enable semua service (kembalikan normal)"
  echo -e "  ${BOLD}${CYAN} [3]${RESET}  🔍  ${BOLD}STATUS${RESET} — Cek status service saat ini"
  echo -e "  ${BOLD}${YELLOW} [4]${RESET}  ❌  ${BOLD}KELUAR${RESET}"
  print_divider
  echo ""
  printf "  ${BOLD}${WHITE}Pilih menu ${CYAN}[1/2/3/4]${WHITE} → ${RESET}"
}

# ── Check root ────────────────────────────────────────────────
check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo ""
    echo -e "  ${BOLD}${RED}⚠  Script ini membutuhkan sudo / root.${RESET}"
    echo -e "  ${DIM}${WHITE}Jalankan dengan: ${CYAN}sudo bash battery_tweak.sh${RESET}"
    echo ""
    exit 1
  fi
}

# ── Main Loop ─────────────────────────────────────────────────
main() {
  check_root

  while true; do
    print_banner
    show_menu

    read -r choice
    echo ""

    case "$choice" in
      1)
        disable_services
        printf "  ${DIM}Tekan Enter untuk kembali ke menu...${RESET}"
        read -r
        ;;
      2)
        enable_services
        printf "  ${DIM}Tekan Enter untuk kembali ke menu...${RESET}"
        read -r
        ;;
      3)
        print_banner
        show_status
        echo ""
        printf "  ${DIM}Tekan Enter untuk kembali ke menu...${RESET}"
        read -r
        ;;
      4)
        echo -e "  ${BOLD}${CYAN}Bye! Jangan lupa respring manual jika perlu. ⚡${RESET}"
        echo ""
        exit 0
        ;;
      *)
        echo -e "  ${RED}Pilihan tidak valid. Coba lagi.${RESET}"
        sleep 1
        ;;
    esac
  done
}

main
