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

## 📦 Telepítés

1.  **Hozz létre egy fájlt, például `uptime_kuma_telepito.sh` néven:**
    ```bash
    nano uptime_kuma_telepito.sh 
    ```
    - Majd illeszd be az itt található script tartalmát, és mentsd el.

2.  **Adj neki futási jogot:**

    ```bash
    chmod +x uptime_kuma_telepito.sh
    ```
    
3. **Most pedig indítsd el:**
    ```bash
    sudo ./uptime_kuma_telepito.sh
    ```

---

## 🖥️ Tesztelt környezet

- **OS:** Debian 13 (VPS környezet)  
- **Script készítője:** Doky  
- **Dátum:** 2025.11.20.  
