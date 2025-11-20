# 🚀 Uptime Kuma + Caddy Telepítő Script

Ez a Bash script automatizálja az **Uptime Kuma** és **Caddy** telepítését Docker környezetben.  
A telepítés során a script gondoskodik a domain beállításáról, HTTPS tanúsítványról (Let's Encrypt), valamint az IP‑alapú hozzáférés tiltásáról.

---

## ✨ Funkciók

- ✔ Interaktívan bekéri a domaint (pl. `uptime.domain.hu`)  
- ✔ Telepíti a Docker CE + Compose V2‑t a hivatalos Docker repóból  
- ✔ Létrehozza az **Uptime Kuma + Caddy** Docker stack‑et  
- ✔ Let's Encrypt automatikus HTTPS tanúsítvány  
- ✔ HTTP → HTTPS átirányítás  
- ✔ Az Uptime Kuma **csak a megadott domainen** érhető el  
- ✔ IP címen való elérés **tiltva (403 Forbidden)**  
- ✔ Automatikusan létrehozza a `docker-compose.yml` és `Caddyfile` konfigurációkat  
- ✔ Azonnal futtatja a stack‑et `docker compose up -d` paranccsal  

---

## 🖥️ Tesztelt környezet

- **OS:** Debian 13 (VPS környezet)  
- **Script készítője:** Doky  
- **Dátum:** 2025.11.20.  

---

## 📦 Telepítés

1. **Script letöltése és futtatása:**
   ```bash
   wget https://github.com/<repo>/install.sh
   chmod +x install.sh
   sudo ./install.sh
