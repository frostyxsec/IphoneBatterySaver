#!/bin/bash

# ============================================================
#   BATTERY TWEAK - macOS Service Manager
#   Author  : Gede
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
# Format: "bundle_id|Label|Deskripsi singkat"
SERVICES=(
  "com.apple.siriinferenced|Siri Inference|Siri machine learning inference"
  "com.apple.siriknowledged|Siri Knowledge|Siri knowledge & ML (cukup boros)"
  "com.apple.assistantd|Assistant|Siri daemon utama"
  "com.apple.relevanced|Relevance Engine|Suggestion & relevance engine"
  "com.apple.wifianalyticsd|WiFi Analytics|Analitik jaringan WiFi"
  "com.apple.duetexpertd|Duet Expert|Prediksi penggunaan aplikasi"
  "com.apple.coreduetd|Core Duet|Smart battery & app usage tracking"
  "com.apple.analyticsd|Analytics|Mengirim data analytics ke Apple"
  "com.apple.nanobackupd|Nano Backup|Backup data nano/wearable"
  "com.apple.tipsd|Tips|Daemon notifikasi Tips macOS"
  "com.apple.ReportCrash|Report Crash|Mengumpulkan data crash di background"
  "com.apple.crashreportcopymobile|Crash Copy Mobile|Menyalin log crash ke Apple"
  "com.apple.DumpPanic|Dump Panic|Dump panic log (jarang dipakai)"
  "com.apple.DumpBasebandCrash|Baseband Crash|Log crash modem/baseband"
  "com.apple.mobile.softwareupdated|Software Update|Update OTA daemon"
  "com.apple.OTATaskingAgent|OTA Tasking Agent|Tugas pembaruan OTA"
  "com.apple.healthd|Health Daemon|Health app daemon (jika jarang dipakai)"
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
  sudo launchctl list "$service" 2>/dev/null
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
  printf "  ${BOLD}%-4s %-30s %-20s %-40s %-6s${RESET}\n" "No." "Bundle ID" "Label" "Deskripsi" "Status"
  print_divider

  local i=0
  for entry in "${SERVICES[@]}"; do
    local svc   label desc status
    IFS='|' read -r svc label desc <<< "$entry"
    status=$(get_service_status "$svc")

    local desc_short="${desc:0:38}"

    if [ "$status" = "ON" ]; then
      printf "  ${DIM}%02d.${RESET}  %-30s %-20s %-40s " "$((i+1))" "$svc" "$label" "$desc_short"
      echo -e "${BOLD}${GREEN}[ ON  ]${RESET}"
    else
      printf "  ${DIM}%02d.${RESET}  %-30s %-20s %-40s " "$((i+1))" "$svc" "$label" "$desc_short"
      echo -e "${DIM}${RED}[ OFF ]${RESET}"
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
  for entry in "${SERVICES[@]}"; do
    local svc label desc
    IFS='|' read -r svc label desc <<< "$entry"

    printf "  ${DIM}%02d.${RESET} %-20s ${DIM}%s${RESET}\n" "$((i+1))" "$label" "$desc"
    printf "      ${DIM}↳ ${CYAN}%s${RESET} → " "$svc"

    sudo launchctl bootout system/"$svc" 2>/dev/null
    sudo launchctl disable system/"$svc" 2>/dev/null

    echo -e "${BOLD}${RED}DISABLED${RESET}"
    i=$((i+1))
  done

  print_divider
  echo ""
  echo -e "  ${BOLD}${GREEN}✔  Semua service berhasil di-disable! (${#SERVICES[@]} service)${RESET}"
  echo -e "  ${DIM}${YELLOW}⚠  Lakukan respring/restart manual untuk efek penuh.${RESET}"
  echo ""
}

# ── Enable all services (ON) ──────────────────────────────────
enable_services() {
  echo ""
  echo -e "  ${BOLD}${GREEN}✅  ENABLING SERVICES...${RESET}"
  print_divider

  local i=0
  for entry in "${SERVICES[@]}"; do
    local svc label desc
    IFS='|' read -r svc label desc <<< "$entry"

    printf "  ${DIM}%02d.${RESET} %-20s ${DIM}%s${RESET}\n" "$((i+1))" "$label" "$desc"
    printf "      ${DIM}↳ ${CYAN}%s${RESET} → " "$svc"

    sudo launchctl enable system/"$svc" 2>/dev/null
    sudo launchctl bootstrap system /System/Library/LaunchDaemons/"$svc".plist 2>/dev/null

    echo -e "${BOLD}${GREEN}ENABLED${RESET}"
    i=$((i+1))
  done

  print_divider
  echo ""
  echo -e "  ${BOLD}${GREEN}✔  Semua service berhasil di-enable! (${#SERVICES[@]} service)${RESET}"
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
