#!/bin/bash

# Abiotic Factor Server Startup Script

set -e

# Set Wine environment
export WINEARCH=win64
export WINEPREFIX=/home/wine/.wine
export DISPLAY=:0

# Change to server directory
cd /home/wine/abfactor-server

# Check if SteamCMD exists, if not download it
if [ ! -f "/home/wine/steamcmd/steamcmd.sh" ]; then
    echo "SteamCMD not found, downloading..."
    cd /home/wine/steamcmd
    if wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz; then
        tar -xzf steamcmd_linux.tar.gz
        rm steamcmd_linux.tar.gz
        chmod +x steamcmd.sh
        echo "SteamCMD downloaded successfully"
    else
        echo "Failed to download SteamCMD. Please mount it manually or download it externally."
    fi
    cd /home/wine/abfactor-server
fi

# Check if server files exist, if not provide instructions
if [ ! -f "AbioticFactorServer.exe" ]; then
    echo "============================================================"
    echo "Abiotic Factor Server files not found!"
    echo "============================================================"
    echo "Please mount the server files to /home/wine/abfactor-server"
    echo "or use the following steps to download them:"
    echo ""
    if [ -f "/home/wine/steamcmd/steamcmd.sh" ]; then
        echo "1. Run SteamCMD to download server files:"
        echo "   /home/wine/steamcmd/steamcmd.sh +force_install_dir /home/wine/abfactor-server +login anonymous +app_update 2857710 +quit"
    else
        echo "1. First download SteamCMD manually and place it in /home/wine/steamcmd/"
        echo "2. Then run SteamCMD to download server files"
    fi
    echo ""
    echo "2. Configure your server settings in ServerSettings.ini"
    echo "============================================================"
    
    # Wait indefinitely so container doesn't exit
    while true; do
        sleep 60
        echo "Waiting for server files... Please check the logs above for instructions."
    done
fi

echo "Starting Abiotic Factor Server..."

# Start the server with Wine
exec wine AbioticFactorServer.exe -log