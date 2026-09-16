# General-purpose Selkies virtual desktop
# Base ships: LXQt desktop, Firefox, Chrome, qterminal, PipeWire audio, s6 supervision
FROM ghcr.io/selkies-project/selkies/desktop:main-ubuntu26.04

USER root
ENV DEBIAN_FRONTEND=noninteractive

# cloudflared — connector for named tunnels (TUNNEL_TOKEN) or quick tunnels
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && curl -fsSL -o /usr/local/bin/cloudflared \
       https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
    && chmod +x /usr/local/bin/cloudflared \
    && rm -rf /var/lib/apt/lists/*

# Session autostart entries (user app + tunnel)
COPY desktop-autostart.desktop /etc/xdg/autostart/desktop-autostart.desktop
COPY tunnel-autostart.desktop /etc/xdg/autostart/tunnel-autostart.desktop
RUN chmod 644 /etc/xdg/autostart/*.desktop

# Helper scripts
COPY start-tunnel.sh /usr/local/bin/start-tunnel.sh
COPY autostart.sh /usr/local/bin/autostart.sh
RUN chmod +x /usr/local/bin/start-tunnel.sh /usr/local/bin/autostart.sh

# HTTPS on: browser requires a secure context; use No TLS Verify in Cloudflare
ENV SELKIES_ENABLE_HTTPS=true
ENV PASSWD=changeme

EXPOSE 8080
