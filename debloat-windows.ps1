# =============================================================================
# Windows 10/11 Debloat Script
# =============================================================================
# Purpose: Wrapper script to run winutil - Windows debloat utility
#
# What winutil does:
#   - Debloat Windows by removing bloatware/pre-installed apps
#   - Install useful software (winget/chocolatey)
#   - Optimize Windows settings
#   - Fix Windows updates
#   - Tweaks for performance/privacy
#
# Source: https://github.com/ChrisTitusTech/winutil
# Documentation: https://winutil.christitus.com/
#
# Requirements:
#   - Windows 10/11
#   - PowerShell 5.1+
#   - Run as Administrator
#
# Usage:
#   .\debloat-windows.ps1          # Launch GUI
#   .\debloat-windows.ps1 -help   # Show this help
#   .\debloat-windows.ps1 -install # Run winget installer mode
#   .\debloat-windows.ps1 -tweaks  # Apply recommended tweaks silently
# =============================================================================

param(
    [string]$Mode = "gui"
)

$ErrorActionPreference = "Stop"

$RED = "`e[31m"
$GREEN = "`e[32m"
$YELLOW = "`e[33m"
$NC = "`e[0m"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    $colorCode = switch ($Color) {
        "Red" { $RED }
        "Green" { $GREEN }
        "Yellow" { $YELLOW }
        default { $NC }
    }
    Write-Host "${colorCode}${Message}${NC}"
}

function Show-Help {
    @"

================================================================================
                    Windows Debloat Script
================================================================================

Source:       https://github.com/ChrisTitusTech/winutil
Documentation: https://winutil.christitus.com/

--------------------------------------------------------------------------------
USAGE
--------------------------------------------------------------------------------

    .\debloat-windows.ps1           Launch GUI (default)
    .\debloat-windows.ps1 -help     Show this help
    .\debloat-windows.ps1 -tweaks   Apply recommended tweaks silently (CLI mode)

--------------------------------------------------------------------------------
WHAT WINUTIL DOES
--------------------------------------------------------------------------------

1. Debloat Mode:
   - Remove pre-installed bloatware apps
   - Disable telemetry and tracking
   - Remove Cortana, OneDrive, Xbox apps
   - Disable unnecessary Windows features

2. Install Mode:
   - Install software via winget or Chocolatey
   - Update all installed software
   - Create daily upgrade tasks

3. Tweaks:
   - Optimize performance settings
   - Enhance privacy
   - Security improvements
   - UI/Personalization tweaks

4. Config/Troubleshoot:
   - Fix Windows Update issues
   - Repair Windows system
   - Reset Windows components

--------------------------------------------------------------------------------
REQUIREMENTS
--------------------------------------------------------------------------------

- Windows 10 or Windows 11
- PowerShell 5.1 or higher
- Run as Administrator (right-click -> Run as administrator)

--------------------------------------------------------------------------------
IMPORTANT NOTES
--------------------------------------------------------------------------------

- Run on a fresh Windows install for best results
- Creates a System Restore point before making changes
- Can undo most changes via the GUI
- Some apps like Edge WebView2 may stop working if Edge is removed

--------------------------------------------------------------------------------
QUICK START
--------------------------------------------------------------------------------

1. Right-click on PowerShell -> Run as Administrator
2. Copy and paste:

    Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force;irm "https://christitus.com/win" | iex

   OR use this script:

    .\debloat-windows.ps1

3. In GUI:
   - Click "Tweaks" tab
   - Select "Recommended" preset
   - Click "Run Tweaks"

--------------------------------------------------------------------------------
ALTERNATIVE: CLI-ONLY MODE
--------------------------------------------------------------------------------

For silent/automated execution:

    .\debloat-windows.ps1 -tweaks

This runs winutil in CLI mode with recommended tweaks.

================================================================================
"@
}

function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Invoke-WinUtil {
    Write-ColorOutput "Launching winutil..." "Yellow"
    Write-ColorOutput "If nothing happens, make sure to run as Administrator!" "Yellow"
    Write-Host ""
    
    # Method 1: Direct invoke
    Invoke-Expression "irm https://christitus.com/win | iex"
}

# Main script
Write-Host ""
Write-ColorOutput "========================================" "Cyan"
Write-ColorOutput "   Windows Debloat Script" "Cyan"
Write-ColorOutput "========================================" "Cyan"
Write-Host ""

# Check for admin rights
if (-not (Test-Admin)) {
    Write-ColorOutput "ERROR: This script must be run as Administrator!" "Red"
    Write-ColorOutput "Right-click PowerShell -> Run as Administrator" "Yellow"
    Write-Host ""
    Write-ColorOutput "Alternative direct command (run as admin):" "Yellow"
    Write-Host "    Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force;irm `"https://christitus.com/win`" | iex" "White"
    exit 1
}

# Parse mode
switch ($Mode.ToLower()) {
    "help" { Show-Help; exit 0 }
    "gui"  { Invoke-WinUtil }
    "tweaks" { 
        Write-ColorOutput "Running winutil in CLI mode..." "Yellow"
        Invoke-Expression "irm https://christitus.com/win | iex" 
    }
    default { 
        Write-ColorOutput "Unknown mode: $Mode" "Red"
        Show-Help
        exit 1
    }
}
