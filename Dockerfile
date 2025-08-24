# Abiotic Factor Server Docker Container
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV WINEARCH=win64
ENV WINEPREFIX=/wine
ENV DISPLAY=:0

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    software-properties-common \
    gnupg2 \
    ca-certificates \
    curl \
    unzip \
    xvfb \
    x11vnc \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install Wine from Ubuntu repositories
RUN apt-get update \
    && apt-get install -y --install-recommends wine \
    && rm -rf /var/lib/apt/lists/*

# Install SteamCMD dependencies
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y \
    lib32gcc-s1 \
    lib32stdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Create wine user and set up Wine environment
RUN useradd -m -s /bin/bash wine \
    && mkdir -p /wine \
    && chown wine:wine /wine

# Switch to wine user
USER wine
WORKDIR /home/wine

# Initialize Wine
RUN wine --version \
    && wineboot --init

# Create directories for server files (SteamCMD will be downloaded at runtime if needed)
RUN mkdir -p /home/wine/abfactor-server \
    && mkdir -p /home/wine/steamcmd

# Switch back to root for final setup
USER root

# Create supervisor configuration for managing processes
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/

# Create startup script
COPY start-server.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-server.sh

# Expose common game server ports (these may need adjustment for Abiotic Factor)
EXPOSE 7777/udp 7778/udp 27015/udp

# Create data volume for persistent server data
VOLUME ["/home/wine/abfactor-server", "/home/wine/.wine"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep -f "AbioticFactor" || exit 1

# Start supervisor to manage all processes
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]