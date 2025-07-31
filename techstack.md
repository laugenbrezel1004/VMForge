# Proxmox-Automatisierung: Tech-Stack Übersicht

## 🌐 Frontend
- **Framework**: [SvelteKit](https://kit.svelte.dev/)

## 🔧 Backend
- **Language**: [Rust](https://www.rust-lang.org/)

## 🛠️ Tech-Stack für Proxmox-Automatisierung

| Tool         | Rolle                                                                 | Reihenfolge |
|--------------|-----------------------------------------------------------------------|-------------|
| **Terraform**   | Infrastruktur als Code (VMs, Netzwerke, Storage)                     | 1.          |
| **Packer**      | Erstellt VM-Templates (mit Cloud-Init, Docker-Vorinstallation)       | 2.          |
| **Cloud-Init**  | Konfiguriert VMs nach Deployment (User, SSH, Docker, etc.)           | 3.          |
| **Ansible**     | Post-Provisioning (Software, Docker-Container, Feinjustierung)       | 4.          |
| **Docker**      | Container-Runtime (läuft in den VMs für App-Isolation)               | 5.          |

> 💡 **Hinweis**: Die Reihenfolge zeigt den typischen Ablauf in der Automatisierungskette – von der Infrastruktur bis zur Anwendungsschicht.
