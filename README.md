# Abiotic Factor Dedicated Server

Docker-based Abiotic Factor dedicated server running on Linux with Wine. Simple, reliable setup based on proven open-source solutions.

## Quick Start

1. **Start the server**:
   ```bash
   docker-compose up -d
   ```

2. **Monitor setup** (first run downloads ~3GB):
   ```bash
   docker-compose logs -f
   ```

3. **Connect to your server**:
   - IP: Your server's IP address
   - Port: 7777 (default)

## Configuration

Copy and edit the environment file:
```bash
cp .env.example .env
```

Available settings:
- `SERVER_NAME`: Your server name (default: "Abiotic Factor Server")
- `SERVER_PASSWORD`: Password for joining (optional)
- `WORLD_SAVE_NAME`: Save file name (default: "Cascade")
- `AUTO_UPDATE`: Auto-update on restart (default: false)

## Server Management

```bash
# Start server
docker-compose up -d

# Stop server
docker-compose down

# View logs
docker-compose logs -f

# Restart server
docker-compose restart

# Update server
docker-compose pull && docker-compose up -d

# Backup saves
make backup
```

## Development

For VS Code development:
1. Install "Dev Containers" extension
2. Open project in VS Code
3. Click "Reopen in Container"

## Network Configuration

Default ports:
- **7777/udp**: Game port (players connect here)
- **27015/udp**: Query port (for server browsers)

For public servers, ensure these ports are open in your firewall and router.

## Data Persistence

- `./gamefiles/`: Game server files (~3GB)
- `./data/`: Save files and server configuration

Both directories are automatically created and persist between container restarts.

## Troubleshooting

**Server not starting?**
- Check logs: `docker-compose logs -f`
- Verify ports are available: `netstat -tulpn | grep 7777`
- Ensure enough disk space (5GB+ recommended)

**Can't connect to server?**
- Verify server is running: `docker-compose ps`
- Check firewall settings
- Confirm correct IP and port

**Game files not downloading?**
- Check internet connection
- Verify Docker has internet access
- Try restarting: `docker-compose restart`

## System Requirements

- Docker and Docker Compose
- 4GB+ RAM recommended
- 5GB+ disk space
- Linux host (or WSL2 on Windows)

## Credits

Based on [Pleut/abiotic-factor-linux-docker](https://github.com/Pleut/abiotic-factor-linux-docker)
