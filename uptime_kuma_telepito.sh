#!/usr/bin/env bash
set -euo pipefail

###############################################
# Uptime Kuma + Caddy Telepítő Script
#
# Tesztelve: Debian 13 (VPS környezet)
#
# Mit tud a script?
# -----------------
# ✔ Interaktívan bekéri a domaint (pl. uptime.domain.hu)
# ✔ Telepíti a Docker CE + Compose V2-t (hivatalos Docker repo!)
# ✔ Létrehozza az Uptime Kuma + Caddy Docker stack-et
# ✔ Let's Encrypt automatikus HTTPS
# ✔ HTTP → HTTPS átirányítást beállítja
# ✔ Az Uptime Kuma CSAK a megadott domainen érhető el
# ✔ IP címen semmilyen formában NEM érhető el (403 Forbidden)
# ✔ Létrehozza a docker-compose.yml és Caddyfile konfigurációkat
# ✔ A stack 'docker compose up -d' paranccsal azonnal futásba kerül
#
# A scriptet készítette: Doky
# Dátum: 2025.11.20.
###############################################

echo "=== Uptime Kuma + Caddy telepítő indul (csak domainen elérhető) ==="

# Root check
if [[ "$EUID" -ne 0 ]]; then
  echo "Kérlek rootként futtasd!"
  exit 1
fi

# Domain kérés
read -rp "Add meg a domaint (pl. uptime.domain.hu): " DOMAIN
if [[ -z "${DOMAIN}" ]]; then
  echo "Hiba: a domain nem lehet üres."
  exit 1
fi

INSTALL_DIR="/opt/uptime-kuma"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

########################################
# Docker telepítése (HIVATALOS REPO!)
########################################

if ! command -v docker &>/dev/null; then
  echo "Docker telepítése a hivatalos repóból..."

  apt-get update
  apt-get install -y ca-certificates curl gnupg

  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    > /etc/apt/sources.list.d/docker.list

  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  systemctl enable docker
  systemctl start docker
else
  echo "Docker már telepítve."
fi

echo "Docker Compose verzió:"
docker compose version

########################################
# docker-compose.yml
########################################

cat > docker-compose.yml <<EOF
services:
  uptime-kuma:
    image: louislam/uptime-kuma:1
    container_name: uptime-kuma
    restart: unless-stopped
    volumes:
      - ./data:/app/data
    networks:
      - kuma-net

  caddy:
    image: caddy:latest
    container_name: kuma-caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - ./caddy-data:/data
      - ./caddy-config:/config
    networks:
      - kuma-net

networks:
  kuma-net:
    driver: bridge
EOF

########################################
# Caddyfile (IP tiltás)
########################################

cat > Caddyfile <<EOF
${DOMAIN} {
    encode gzip
    reverse_proxy uptime-kuma:3001
}

:80, :443 {
    respond "Forbidden" 403
}
EOF

########################################
# Stack indítás
########################################

docker compose pull
docker compose up -d

echo
echo "=== KÉSZ! ==="
echo "Uptime Kuma elérhető: https://${DOMAIN}"
echo "IP címen: 403 Forbidden (tiltva)"
echo
echo "Konténerek ellenőrzése:"
echo "  cd ${INSTALL_DIR} && docker compose ps"
echo
