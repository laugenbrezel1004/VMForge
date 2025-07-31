---

# 🖥️ Frontend Form: User-Configurable VM Provisioning Interface

This form allows users to define and provision virtual machines via Terraform + Proxmox + Ansible. The frontend interface should be intuitive, responsive, and secure.

---

## 1. 📌 Grundlegende VM-Einstellungen

| Feld | Typ & Optionen | Hinweise & Technische Umsetzung |
|------|----------------|----------------------------------|
| **VM-Name** | `Textfeld` (max. 64 Zeichen, nur Buchstaben, Zahlen, Bindestriche) | - Validierung: `^[a-z0-9-]+$`<br>→ Übergeben an `proxmox_vm_qemu.name` in Terraform |
| **Betriebssystem** | `Dropdown`<br>• Ubuntu 22.04 LTS<br>• Debian 12<br>• Rocky Linux 9<br>• CentOS Stream 9<br>• Alpine Linux 3.19 | - Backend: Packer-Template auswählen (`"ubuntu-template"`, `"debian-template"` etc.)<br>→ `os_type` & `template` in Terraform |
| **VM-Größe** | `Dropdown`<br>• **Small**: 2 CPU / 4 GB RAM<br>• **Medium**: 4 CPU / 8 GB RAM<br>• **Large**: 8 CPU / 16 GB RAM<br>• **Custom**: (benutzerdefiniertes Eingabefeld) | - Für „Custom“: `CPU` (Slider 1–16) & `RAM` (Slider 1–64 GB)<br>→ `cores` & `memory` in Terraform |
| **Speicher (Disk)** | `Slider` (20 GB – 100 GB, Schritt 5 GB)<br>→ Anzeige: `20 GB` bis `100 GB`<br>• *Hinweis:* Standard-Format: `qcow2`<br>• Option: `SSD` (Checkbox) | - `disk.size` in Terraform<br>→ `disk_type = "ssd"` (wenn aktiviert)<br>→ Unterstützt `thin` oder `full` provisioning |
| **Disk-Format** | `Dropdown`<br>• `qcow2` (Standard, komprimiert)<br>• `raw` (für maximalen I/O)<br>• `lvm` (für lokale Speicherverwaltung) | → `disk.format` in Terraform |

---

## 2. 🌐 Netzwerk & Zugriff

| Feld | Typ & Optionen | Hinweise & Technische Umsetzung |
|------|----------------|----------------------------------|
| **Netzwerk-Bridge** | `Dropdown`<br>• `vmbr0` (Public)<br>• `vmbr1` (Private VLAN)<br>• `vmbr2` (Management)<br>• `Custom` (Textfeld) | → `network.bridge` in Terraform<br>→ Validierung: Nur gültige Brücken |
| **Öffentliche IP** | `Checkbox`<br>• `Ja` (öffentlich über NAT)<br>• `Nein` (nur intern) | - Wenn `Ja`:<br>→ Ansible playbook fügt Cloud-Init-Konfig hinzu (`network: eth0: dhcp4: true`)<br>→ Optional: `public_ip` als Variable (z. B. `192.168.1.100`) |
| **Public IP-Adresse (Optional)** | `Textfeld` (IPv4-Format, z. B. `192.168.1.100`) | - Nur sichtbar, wenn „Öffentliche IP“ aktiviert ist<br>→ Wird in `cloud-init` als `static` IP gesetzt |
| **Firewall-Regeln** | `Mehrfachauswahl`<br>• SSH (Port 22)<br>• HTTP (Port 80)<br>• HTTPS (Port 443)<br>• Custom (Textfeld für Port/Protokoll) | → Ansible-Rolle `geerlingguy.firewall` oder Proxmox-ACLs<br>→ Speichert Regeln als `firewall.rules` in Terraform |
| **SSH-Key hochladen** | `File-Upload` (`.pub`-Datei) oder `Textfeld` (Kopieren der SSH-Key-Zeile) | - Validierung: Gültige öffentliche SSH-Key-Struktur<br>→ Wird in `cloud-init` unter `ssh_authorized_keys` gespeichert<br>→ Optional: `key_name` als Label |

---

## 3. 💻 Software & Services

| Feld | Typ & Optionen | Hinweise & Technische Umsetzung |
|------|----------------|----------------------------------|
| **Docker installieren?** | `Checkbox`<br>• `Ja`<br>• `Nein` | - Wenn `Ja`:<br>→ Nutze bereits vorbereitetes Packer-Image mit Docker<br>→ Oder: Ansible-Rolle `geerlingguy.docker`<br>→ `docker_installed: true` in Terraform |
| **Zusätzliche Pakete** | `Mehrfachauswahl`<br>• Nginx<br>• Apache HTTP Server<br>• MySQL (8.0)<br>• PostgreSQL (15)<br>• Python3<br>• Git<br>• Node.js (LTS)<br>• Custom (Textfeld für Paketname) | → Ansible-Playbook installiert via `apt`/`yum`<br>→ `packages: [...]` in `ansible_playbook.yml` |
| **Benutzerdefinierte Skripte** | `Textarea` (Bash/Python/Shell)<br>• Max. 10.000 Zeichen<br>• Syntax-Highlighting (optional) | - Wird als `user_data` in Cloud-Init ausgeführt<br>→ Oder: `ansible shell`-Modul nach Deployment<br>→ Sicherheit: Kein `sudo`-Zugriff ohne explizite Erlaubnis |
| **Start-Skript nach Erstellung** | `Checkbox`<br>• `Ja` (Skript automatisch ausführen)<br>• `Nein` | → Skript wird als `post-deploy`-Job ausgeführt<br>→ Nutzbar für Initialisierung, Migration, etc. |

---

## 4. 🔐 Erweiterte Optionen

| Feld | Typ & Optionen | Hinweise & Technische Umsetzung |
|------|----------------|----------------------------------|
| **Backup aktivieren** | `Checkbox`<br>• `Ja`<br>• `Nein` | - Wenn `Ja`:<br>→ Proxmox-API setzt Backup-Job über `pvesh` oder Ansible<br>→ `backup_interval: daily` / `weekly`<br>→ `retention: 7` Tage |
| **Backup-Ziel** | `Dropdown`<br>• `local`<br>• `nfs:/backup`<br>• `s3:bucket-name` (mit AWS-S3-Integration)<br>• `custom` (Textfeld) | → `backup_storage` in Terraform<br>→ S3: Credentials über Vault/Secrets Manager |
| **Start nach Erstellung** | `Checkbox`<br>• `Ja` (automatisch starten)<br>• `Nein` (manuell starten) | → `onboot = true` in Terraform<br>→ Optional: `start_delay` (Sekunden) |
| **Tags / Labels** | `Freitextfeld` (z. B. `web`, `dev`, `prod`, `api`) | - Mehrfach: `tags: [dev, web, staging]`<br>→ Wird in Terraform und Ansible als Variable gespeichert<br>→ Für Filterung, Monitoring, Billing |
| **VM-Description** | `Textarea` (max. 256 Zeichen) | - Für Dokumentation, Owner, Projektzweck<br>→ `description` in Proxmox und Terraform |
| **Owner / Team** | `Textfeld` oder `Dropdown` (mit Benutzerliste aus IAM) | - Für Auditing, Zugriffssteuerung<br>→ `owner: dev-team-1` |
| **Auto-Update aktivieren** | `Checkbox`<br>• `Ja` (automatische Updates via `unattended-upgrades`)<br>• `Nein` | - Wenn `Ja`:<br>→ Ansible-Rolle `geerlingguy.unattended-upgrades`<br>→ `update_schedule: daily` |

---

## ✅ Bonus: UI/UX & Sicherheitsempfehlungen

- 🎨 **Responsive Design**: Formular sollte auf Desktop und Tablet funktionieren.
- 🔐 **Validierung**: Alle Eingaben müssen serverseitig validiert werden.
- 📦 **Preview-Modus**: „Vorschau“-Button, der eine JSON- oder Terraform-Code-Preview zeigt.
- 📝 **Hilfetexte (Tooltips)**: Jedes Feld sollte einen `?`-Button haben mit kurzer Erklärung.
- 🛡️ **Sicherheit**:
    - Keine direkten `exec`-Befehle im Skriptfeld
    - Limitierte Skriptlänge (z. B. 10 KB)
    - Keine `rm -rf /`-Befehle erlaubt
    - Log-Dateien für alle Skriptausführungen
- 📤 **Export-Option**: Nach Erstellung: „Terraform-Code herunterladen“ oder „Ansible Playbook exportieren“

---

## 📦 Backend Integration (Zusammenfassung)

| Komponente | Nutzung |
|-----------|--------|
| **Terraform** | `proxmox_vm_qemu`, `template`, `disk`, `network`, `tags`, `onboot` |
| **Proxmox API** | `pvesh` für Backup, VM-Start, Netzwerk |
| **Ansible** | `cloud-init`, `roles`, `playbooks` für Software, Firewalls, Skripte |
| **Packer** | Vorab-Image-Builds mit vorkonfigurierten OS & Docker |
| **Vault/Secrets** | SSH-Keys, S3-Credentials, API-Tokens |

---

## 📎 Beispiel: Ausgabe (Terraform-Code-Preview)

```hcl
resource "proxmox_vm_qemu" "web_server" {
  name        = "dev-web-01"
  vmid        = 100
  template    = true
  os_type     = "l26"
  cores       = 4
  memory      = 8192
  disk {
    size = "50G"
    type = "ssd"
  }
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }
  cloud_init {
    user_data = "#cloud-config\nruncmd:\n  - echo 'Hello World'"
  }
  tags = ["dev", "web"]
  onboot = true
}
```

---

> ✅ **Zusammenfassung**: Dieses Formular ist perfekt für DevOps-Teams, CI/CD-Pipelines oder internen Self-Service-Portalen. Es kombiniert Flexibilität, Sicherheit und Skalierbarkeit.

---
