#!/bin/bash

# Set default values for environment variables
MaxServerPlayers="${MaxServerPlayers:-6}"
Port="${Port:-7777}"
QueryPort="${QueryPort:-27015}"
ServerPassword="${ServerPassword:-}"
SteamServerName="${SteamServerName:-Abiotic Factor Server}"
WorldSaveName="${WorldSaveName:-Cascade}"
AdditionalArgs="${AdditionalArgs:-}"
AutoUpdate="${AutoUpdate:-false}"

# Performance settings
SetUsePerfThreads="-useperfthreads "
if [[ $UsePerfThreads == "false" ]]; then
    SetUsePerfThreads=""
fi

SetNoAsyncLoadingThread="-NoAsyncLoadingThread "
if [[ $NoAsyncLoadingThread == "false" ]]; then
    SetNoAsyncLoadingThread=""
fi

echo "=== Abiotic Factor Server Starting ==="
echo "Server Name: $SteamServerName"
echo "Max Players: $MaxServerPlayers"
echo "Port: $Port"
echo "Query Port: $QueryPort"
echo "World Save: $WorldSaveName"
echo "Auto Update: $AutoUpdate"
echo ""

# Check for updates/perform initial installation
if [ ! -d "/server/AbioticFactor/Binaries/Win64" ] || [[ $AutoUpdate == "true" ]]; then
    echo "Downloading/updating Abiotic Factor server files..."
    echo "This may take several minutes depending on your connection..."
    
    steamcmd \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir /server \
        +login anonymous \
        +app_update 2857200 validate \
        +quit
    
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to download server files"
        exit 1
    fi
    
    echo "Download completed successfully!"
else
    echo "Server files already exist, skipping download"
fi

# Verify server executable exists
if [ ! -f "/server/AbioticFactor/Binaries/Win64/AbioticFactorServer-Win64-Shipping.exe" ]; then
    echo "ERROR: Server executable not found!"
    echo "Expected: /server/AbioticFactor/Binaries/Win64/AbioticFactorServer-Win64-Shipping.exe"
    ls -la /server/AbioticFactor/Binaries/Win64/ || echo "Directory does not exist"
    exit 1
fi

echo "Starting Abiotic Factor server..."
pushd /server/AbioticFactor/Binaries/Win64 > /dev/null

# Construct server arguments
SERVER_ARGS="$SetUsePerfThreads$SetNoAsyncLoadingThread-MaxServerPlayers=$MaxServerPlayers"
SERVER_ARGS="$SERVER_ARGS -PORT=$Port -QueryPort=$QueryPort"

if [[ -n "$ServerPassword" ]]; then
    SERVER_ARGS="$SERVER_ARGS -ServerPassword=$ServerPassword"
fi

SERVER_ARGS="$SERVER_ARGS -SteamServerName=\"$SteamServerName\""
SERVER_ARGS="$SERVER_ARGS -WorldSaveName=\"$WorldSaveName\" -tcp $AdditionalArgs"

echo "Launching server with arguments: $SERVER_ARGS"
echo ""

# Start the server with Wine
wine AbioticFactorServer-Win64-Shipping.exe $SERVER_ARGS

popd > /dev/null
