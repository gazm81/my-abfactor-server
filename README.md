# Abiotic Factor Server Docker Container

A Docker container setup for running an Abiotic Factor dedicated server on Linux using Wine. This setup is designed to work with Docker Desktop on Windows.

## Features

- Ubuntu 22.04 based container
- Wine for running Windows game server binaries
- Supervisor for process management
- Development container support
- Automatic server restart on crash
- Persistent data volumes
- Health monitoring

## Quick Start

### Prerequisites

- Docker Desktop installed and running
- At least 4GB RAM available for the container
- Abiotic Factor server files (obtained via SteamCMD)

### 1. Clone the Repository

```bash
git clone https://github.com/gazm81/my-abfactor-server.git
cd my-abfactor-server
```

### 2. Create Server Data Directory

```bash
mkdir server-data
```

### 3. Build the Docker Image

```bash
docker build -t abfactor-server .
```

### 4. Download Server Files

Run the container to get SteamCMD and download server files:

```bash
docker run -it --rm -v $(pwd)/server-data:/home/wine/abfactor-server abfactor-server bash
```

Inside the container, run:

```bash
/home/wine/steamcmd/steamcmd.sh +force_install_dir /home/wine/abfactor-server +login anonymous +app_update 2857710 +quit
```

### 5. Run the Server

```bash
docker run -d \
  --name abfactor-server \
  -p 7777:7777/udp \
  -p 7778:7778/udp \
  -p 27015:27015/udp \
  -v $(pwd)/server-data:/home/wine/abfactor-server \
  abfactor-server
```

## Development Container

This repository includes a development container configuration for VS Code.

1. Open the repository in VS Code
2. Install the "Dev Containers" extension
3. Press `Ctrl+Shift+P` and select "Dev Containers: Reopen in Container"

## Docker Compose (Alternative)

Create a `docker-compose.yml` file:

```yaml
services:
  abfactor-server:
    build: .
    ports:
      - "7777:7777/udp"
      - "7778:7778/udp"
      - "27015:27015/udp"
    volumes:
      - ./server-data:/home/wine/abfactor-server
      - wine-data:/home/wine/.wine
    restart: unless-stopped
    environment:
      - WINEARCH=win64
      - WINEPREFIX=/home/wine/.wine

volumes:
  wine-data:
```

Then run:

```bash
docker compose up -d
```

## Server Configuration

Server configuration files will be located in the `server-data` directory after first run:

- `ServerSettings.ini` - Main server configuration
- `save/` - World save data
- `logs/` - Server log files

### Example ServerSettings.ini

```ini
[ServerSettings]
ServerName=My Abiotic Factor Server
MaxPlayers=8
ServerPassword=
bIsPublic=true
Port=7777
QueryPort=7778
```

## Monitoring

### View Logs

```bash
docker logs -f abfactor-server
```

### Check Server Status

```bash
docker exec abfactor-server supervisorctl status
```

### Access Container Shell

```bash
docker exec -it abfactor-server bash
```

## Troubleshooting

### Server Won't Start

1. Check if server files are properly downloaded
2. Verify port availability
3. Check container logs for Wine errors

### Performance Issues

- Increase container memory limit
- Use SSD storage for volumes
- Monitor CPU usage

### Network Issues

- Ensure UDP ports are properly forwarded
- Check firewall settings on host
- Verify Docker network configuration

## Security Considerations

- Change default server passwords
- Use non-root user inside container
- Regularly update base image and Wine
- Monitor resource usage

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.

## Support

For issues related to:
- Docker setup: Open an issue in this repository
- Abiotic Factor game: Check the official game forums
- Wine compatibility: Consult Wine documentation
