# Vaultwarden Setup Guide: DuckDNS, Nginx, acme.sh & Rsync Backup

This guide walks through setting up Vaultwarden using Podman Quadlets on Fedora, securing it with an SSL certificate using DuckDNS and `acme.sh`, proxying through Nginx over a NetBird mesh network, migrating from LastPass, and automating backups to a secondary server (`server-b`).

---

## Prerequisites
* **Server:** Fedora Linux with Podman and Nginx installed.
* **Network:** NetBird mesh network running.
* **Domain:** `vaultwarden-leckmesh.duckdns.org` on DuckDNS (signed in via GitHub).
* **DuckDNS Setup:** Target IP set to your server's NetBird IP (`100.x.x.x`).

---

## Step 1: Install Vaultwarden via Podman Quadlet

1. Create the Quadlet directory and file in your systemd user configuration:
   ```bash
   mkdir -p ~/.config/containers/systemd
   nano ~/.config/containers/systemd/vaultwarden.container
   ```

2. Paste the following configuration:
   ```ini
   [Unit]
   Description=Vaultwarden Password Manager

   [Container]
   Image=docker.io/vaultwarden/server:latest
   ContainerName=vaultwarden-app
   PublishPort=8095:80
   Volume=vaultwarden-data:/data:Z
   Environment=SIGNUPS_ALLOWED=true

   [Install]
   WantedBy=default.target
   ```

3. Enable user lingering so systemd services boot and stay running across reboots without requiring an active session:
   ```bash
   sudo loginctl enable-linger $USER
   ```

4. Reload systemd and start Vaultwarden:
   ```bash
   systemctl --user daemon-reload
   systemctl --user start vaultwarden.service
   ```

---

## Step 2: Install acme.sh and Request Certificate

1. Install `acme.sh`:
   ```bash
   curl [https://get.acme.sh](https://get.acme.sh) | sh
   source ~/.bashrc
   ```

2. Change default CA to Let's Encrypt:
   ```bash
   ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
   ```

3. Export your DuckDNS token (found at the top of the DuckDNS dashboard):
   ```bash
   export DuckDNS_Token="YOUR_DUCKDNS_TOKEN_HERE"
   ```

4. Issue the wildcard/subdomain certificate:
   > **Note:** We include `--dnssleep 60` to prevent timeouts caused by AdGuard Home filtering DoH queries.
   ```bash
   ~/.acme.sh/acme.sh --issue --dns dns_duckdns -d vaultwarden-leckmesh.duckdns.org --dnssleep 60
   ```

---

## Step 3: Configure Folder Permissions for SSL Certificates

Create the target directory for Nginx SSL files and assign ownership to your standard user account so `acme.sh` can write to it without needing `sudo`:

```bash
sudo mkdir -p /etc/nginx/ssl
sudo chown -R $USER:$USER /etc/nginx/ssl
```

---

## Step 4: Install Certificates for Nginx

Run `acme.sh` without `sudo` to place the active certificate files in `/etc/nginx/ssl`:

```bash
~/.acme.sh/acme.sh --install-cert -d vaultwarden-leckmesh.duckdns.org \
  --key-file       /etc/nginx/ssl/privkey.pem  \
  --fullchain-file /etc/nginx/ssl/fullchain.pem \
  --reloadcmd     "sudo systemctl reload nginx"
```

---

## Step 5: Configure Nginx Reverse Proxy

1. Create the Nginx configuration file:
   ```bash
   sudo nano /etc/nginx/conf.d/vaultwarden.conf
   ```

2. Paste the following configuration:
   ```nginx
   server {
       listen 80;
       server_name vaultwarden-leckmesh.duckdns.org;
       return 301 https://$host$request_uri;
   }

   server {
       listen 443 ssl;
       server_name vaultwarden-leckmesh.duckdns.org;

       ssl_certificate /etc/nginx/ssl/fullchain.pem;
       ssl_certificate_key /etc/nginx/ssl/privkey.pem;

       location / {
           proxy_pass [http://127.0.0.1:8095](http://127.0.0.1:8095);
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

3. Test and reload Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```

---

## Step 6: Import Data & Disable Signups

1. Open `https://vaultwarden-leckmesh.duckdns.org` in your browser.
2. Create your main account.
3. **Import from LastPass:**
   * Export vault from LastPass (**Extension -> Account -> Fix a problem yourself -> Export vault items**).
   * In Vaultwarden Web UI, navigate to **Tools -> Import Data**, select **LastPass (csv)**, and upload your file.
   * Securely delete the `.csv` file from your device.
4. **Disable Future Registrations:**
   * Edit `~/.config/containers/systemd/vaultwarden.container` and change:
     ```ini
     Environment=SIGNUPS_ALLOWED=false
     ```
   * Apply changes:
     ```bash
     systemctl --user daemon-reload
     systemctl --user restart vaultwarden.service
     ```

---

## Step 7: Backup Vaultwarden Data to Server-B via Rsync

Podman rootless named volumes store application data inside your local home folder:
`~/.local/share/containers/storage/volumes/vaultwarden-data/_data`

### One-Line Rsync Backup
```bash
rsync -avz --delete \
  ~/.local/share/containers/storage/volumes/vaultwarden-data/_data/ \
  user@server-b:/path/to/backups/vaultwarden/
```

### Automated Script (`backup-vaultwarden.sh`)
```bash
#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$HOME/.local/share/containers/storage/volumes/vaultwarden-data/_data/"
REMOTE_USER="user"
REMOTE_HOST="server-b"
REMOTE_DIR="/path/to/backups/vaultwarden/"

echo "Starting Vaultwarden sync to ${REMOTE_HOST}..."
rsync -avz --delete "$SOURCE_DIR" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}"
echo "Backup finished successfully."
```

Make the script executable:
```bash
chmod +x backup-vaultwarden.sh
```
