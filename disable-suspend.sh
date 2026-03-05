#!/bin/bash

# =============================================================================
# Ubuntu Disable Automatic Suspend Script
# =============================================================================
# Purpose: Disable automatic suspend and screen blanking on Ubuntu desktop
# Usage:   ./disable-suspend.sh [--enable] [--help]
# 
# Options:
#   --enable   Re-enable automatic suspend (restore defaults)
#   --help     Show this help message
#
# What this script does:
#   - Disables suspend when on AC power
#   - Disables suspend when on battery power
#   - Disables screen blanking (optional, set DISABLE_BLANK=false to skip)
#   - Disables GNOME idle delay
#
# Run as: Regular user (no sudo needed for gsettings)
# =============================================================================

set -e

# Configuration - Change these if needed
DISABLE_BLANK=true          # Set to false to keep screen blanking enabled
SCHEMA="org.gnome.settings-daemon.plugins.power"
DESKTOP_SCHEMA="org.gnome.desktop.session"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_msg() {
    local color=$1
    local msg=$2
    echo -e "${color}${msg}${NC}"
}

show_help() {
    head -30 "$0" | tail -20
    exit 0
}

disable_suspend() {
    print_msg "$YELLOW" "=== Disabling Automatic Suspend ==="
    
    # Disable suspend on AC power
    gsettings set "$SCHEMA" sleep-inactive-ac-type 'nothing'
    print_msg "$GREEN" "[OK] Suspend disabled on AC power"
    
    # Disable suspend on battery power
    gsettings set "$SCHEMA" sleep-inactive-battery-type 'nothing'
    print_msg "$GREEN" "[OK] Suspend disabled on battery power"
    
    # Set timeouts to 0 (in case type 'nothing' doesn't work on all versions)
    gsettings set "$SCHEMA" sleep-inactive-ac-timeout 0
    gsettings set "$SCHEMA" sleep-inactive-battery-timeout 0
    
    if [ "$DISABLE_BLANK" = true ]; then
        print_msg "$YELLOW" "=== Disabling Screen Blanking ==="
        
        # Disable screen idle delay (0 = never turn off)
        gsettings set "$DESKTOP_SCHEMA" idle-delay 0
        print_msg "$GREEN" "[OK] Screen blanking disabled"
    fi
    
    print_msg "$GREEN" "=== Done! System will no longer auto-suspend ==="
}

enable_suspend() {
    print_msg "$YELLOW" "=== Re-enabling Automatic Suspend ==="
    
    # Re-enable suspend on AC power (30 minutes)
    gsettings set "$SCHEMA" sleep-inactive-ac-type 'suspend'
    gsettings set "$SCHEMA" sleep-inactive-ac-timeout 1800
    print_msg "$GREEN" "[OK] Suspend enabled on AC power (30 min)"
    
    # Re-enable suspend on battery power (10 minutes)
    gsettings set "$SCHEMA" sleep-inactive-battery-type 'suspend'
    gsettings set "$SCHEMA" sleep-inactive-battery-timeout 600
    print_msg "$GREEN" "[OK] Suspend enabled on battery power (10 min)"
    
    # Re-enable screen blanking (5 minutes)
    if [ "$DISABLE_BLANK" = true ]; then
        gsettings set "$DESKTOP_SCHEMA" idle-delay 300
        print_msg "$GREEN" "[OK] Screen blanking enabled (5 min)"
    fi
    
    print_msg "$GREEN" "=== Done! Automatic suspend restored to defaults ==="
}

show_current_settings() {
    print_msg "$YELLOW" "=== Current Settings ==="
    
    echo "AC Power:"
    echo "  Suspend Type: $(gsettings get $SCHEMA sleep-inactive-ac-type)"
    echo "  Timeout: $(gsettings get $SCHEMA sleep-inactive-ac-timeout)s"
    
    echo "Battery:"
    echo "  Suspend Type: $(gsettings get $SCHEMA sleep-inactive-battery-type)"
    echo "  Timeout: $(gsettings get $SCHEMA sleep-inactive-battery-timeout)s"
    
    echo "Screen:"
    echo "  Idle Delay: $(gsettings get $DESKTOP_SCHEMA idle-delay)s"
}

# Parse command line arguments
case "${1:-}" in
    --help|-h)
        show_help
        ;;
    --enable)
        enable_suspend
        ;;
    --status)
        show_current_settings
        ;;
    "")
        disable_suspend
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        ;;
esac
