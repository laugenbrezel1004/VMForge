# 🌐 Proxmox-Automatisierung: Tech-Stack Übersicht
### 🐳 Containerisierte Architektur mit Docker

Alle Komponenten – **Frontend**, **Backend**, und die **4 Automatisierungstools** – laufen in isolierten Docker-Containern.  
Die Architektur ermöglicht modulare Entwicklung, einfache Skalierung, Reproduzierbarkeit und einfache Deployment-Workflows.

---

## 📦 Container-Übersicht

| Komponente       | Container-Name             | Docker-Image | Laufzeit |  
|------------------|----------------------------|--------------|----------|  
| 🌐 Frontend       | `proxmox-frontend`         | `sveltekit:latest` | Web-UI |  
| 🔧 Backend        | `proxmox-backend`          | `rust:latest` (mit `cargo`) | API-Service |  
| 🛠️ Terraform      | `proxmox-terraform`        | `hashicorp/terraform:latest` | Infrastruktur |  
| 🛠️ Packer         | `proxmox-packer`           | `hashicorp/packer:latest` | Template-Build |  
| 🛠️ Cloud-Init     | `proxmox-cloud-init`       | `alpine:latest` (einfach, minimal) | VM-Konfig |  
| 🛠️ Ansible        | `proxmox-ansible`          | `ansible/ansible:latest` | Post-Provisioning |  

> ✅ **Tipp**: Alle Tools können in einem einzigen `docker-compose.yml`-File verwaltet werden – ideal für lokale Entwicklung und CI/CD.

---

## 🛠️ Tech-Stack für Proxmox-Automatisierung

| Tool         | Rolle | Container | Reihenfolge |
|--------------|-------|-----------|-------------|
| **Terraform**   | Infrastruktur als Code (VMs, Netzwerke, Storage) | `proxmox-terraform` | 1. |
| **Packer**      | Erstellt VM-Templates (mit Cloud-Init, Docker-Vorinstallation) | `proxmox-packer` | 2. |
| **Cloud-Init**  | Konfiguriert VMs nach Deployment (User, SSH, Docker, etc.) | `proxmox-cloud-init` | 3. |
| **Ansible**     | Post-Provisioning (Software, Docker-Container, Feinjustierung) | `proxmox-ansible` | 4. |

> 💡 **Hinweis**: Die Reihenfolge zeigt den typischen Ablauf in der Automatisierungskette – von der Infrastruktur bis zur Anwendungsschicht.  
> 🔁 Alle Tools laufen **im Container**, können aber auch über `docker exec` oder `docker-compose run` interaktiv aufgerufen werden.
