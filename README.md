---

# 🖥️ VMForge: The Ultimate User-Configurable VM Provisioning Interface for Proxmox VE

![VMForge Hero Banner](https://placehold.co/1200x400/180042/fefbf6?text=VMForge%20-%20Proxmox%20Automation%20Made%20Simple)

> **Automate VM provisioning on Proxmox VE with ease.**  
> Build, configure, and deploy virtual machines using Terraform, Packer, Ansible, and Cloud-Init — all through an intuitive web UI.

---

## 🌟 Why VMForge?

In today’s cloud-native world, infrastructure automation is not optional — it’s essential. But managing VMs across Proxmox VE with raw CLI tools can be tedious and error-prone.

**VMForge bridges the gap between simplicity and power**, delivering a **modern, containerized, full-stack automation platform** that lets you:

- 🛠️ **Provision VMs with a few clicks**
- 🔁 **Reproduce environments consistently**
- 🔄 **Automate every stage: build → deploy → configure → secure**
- 🔐 **Enforce security and validation by design**
- 📦 **Scale across multiple OS and use cases**

Built for DevOps engineers, SREs, and system administrators who want **more control, less complexity**.

---

## ✨ Key Features

| Feature | Description |
|-------|-------------|
| 🎨 **Intuitive Web UI** | SvelteKit-powered form interface with real-time validation and guided workflows |
| ⚙️ **Full Automation Stack** | Packer (templates), Terraform (infrastructure), Cloud-Init (initial config), Ansible (post-setup) |
| 🐳 **Containerized Architecture** | All components run in isolated Docker containers — no local tooling required |
| 🌍 **Multi-OS Support** | Ubuntu, Debian, Rocky Linux, CentOS, Alpine — expandable via templates |
| 💡 **Configurable Resources** | Custom CPU, RAM, disk size/type, network bridge, and storage policies |
| 🔐 **Security-First Design** | Input validation, SSH key management, firewall rules, RBAC via Proxmox, audit logging |
| 📊 **Advanced Options** | Auto-start, backup schedules, tags/labels, auto-updates, and custom scripts |
| 📂 **Extensible & Modular** | Easily add new OS templates, roles, or integration hooks |

---

## 🚀 Quick Start (5 Minutes to Your First VM)

### Prerequisites
- ✅ Docker & Docker Compose installed
- ✅ Proxmox VE server with API access (enable `API` and `SSH` access)
- ✅ `curl` or `wget` for setup (optional)

### Installation

```bash
# Clone the repo
git clone https://github.com/your-repo/vmforge.git
cd vmforge

# Copy and edit environment variables
cp .env.example .env
nano .env
```

Update your `.env` file with:

```env
PROXMOX_URL=https://your-proxmox-server:8006
PROXMOX_USER=root@pam
PROXMOX_PASSWORD=your_secure_password
PROXMOX_NODE=your-node-name
```

> 💡 Tip: Use a dedicated service account with limited permissions for security.

```bash
# Start all services
docker-compose up -d

# Check logs to verify everything is running
docker-compose logs -f
```

### Access the Interface

Open your browser and visit:

👉 [http://localhost:3000](http://localhost:3000)

🎉 You’re now ready to create your first VM with full automation.

---

## 🛠️ Technical Architecture

VMForge is designed for **modularity, scalability, and security**, using a microservices-like architecture inside Docker containers.

### 📦 Containerized Components

| Component | Container Name | Purpose |
|--------|----------------|--------|
| **Frontend** | `proxmox-frontend` | SvelteKit web interface (responsive, dark mode, real-time feedback) |
| **Backend API** | `proxmox-backend` | Rust-based API service (fast, secure, async) |
| **Terraform** | `proxmox-terraform` | Infrastructure-as-Code provisioning (Proxmox provider) |
| **Packer** | `proxmox-packer` | Build golden VM templates (from ISOs) |
| **Cloud-Init** | `proxmox-cloud-init` | Inject initial user data and metadata |
| **Ansible** | `proxmox-ansible` | Post-deployment configuration (packages, services, scripts) |

> All binaries are pre-packaged — **no need to install Terraform, Packer, or Ansible locally**.

---

## 🔄 Workflow Pipeline

```mermaid
graph TD
    A[User Configures VM via Web UI] --> B{Validate Input}
    B --> C[Generate Packer Template]
    C --> D[Build VM Template (Packer)]
    D --> E[Provision VM (Terraform)]
    E --> F[Apply Cloud-Init (User Data)]
    F --> G[Run Ansible Playbook]
    G --> H[VM Ready: Deployed & Configured]
```

Each step is logged, auditable, and reversible — ideal for CI/CD pipelines and compliance.

---

## 📋 Form Configuration (Step-by-Step)

The UI guides you through four intuitive sections:

### 1. **Basic VM Settings**
- VM Name (validated: `^[a-z0-9-]+$`)
- OS Selection (Ubuntu 22.04, Debian 12, Rocky 9, etc.)
- VM Size (preset: small/medium/large or custom CPU/RAM)
- Storage: Size, type (SSD/HDD), format (raw/qcow2), and pool

### 2. **Networking & Access**
- Bridge selection (`vmbr0`, `vmbr1`, etc.)
- Public IP assignment (DHCP or static)
- Firewall rules: SSH (22), HTTP (80), HTTPS (443)
- SSH key upload (or auto-generated)
- Public key authentication only

### 3. **Software & Services**
- Install Docker (optional)
- Pre-select packages: `nginx`, `python3`, `curl`, `git`, etc.
- Upload custom scripts (Bash/Python) — runs on first boot
- Post-deployment Ansible roles (e.g., "web-server", "database", "monitoring")

### 4. **Advanced Options**
- Backup policy (frequency, retention)
- Auto-start on reboot
- Tags/Labels (e.g., `env:prod`, `role:web`)
- Auto-update (security patches)
- Custom Terraform variables

---

## 🔐 Security & Best Practices

VMForge is built with **security at its core**:

- ✅ **Client & Server-Side Validation** (regex, type checks, length limits)
- ✅ **Secure Credential Handling** (no plaintext storage; keys encrypted at rest)
- ✅ **RBAC via Proxmox** (leverage existing user roles and permissions)
- ✅ **Activity Logging** (all actions logged with timestamps and user context)
- ✅ **Minimal Privilege** (containers run as non-root, restricted access)
- ✅ **No Code Injection** (scripts run in isolated environments with sandboxing)
- ✅ **Audit Trail** (log output of all Terraform/Packer/Ansible runs)

> 🔒 Recommended: Run VMForge behind a reverse proxy (Nginx/Caddy) with TLS and authentication.

---

## 🧩 Example: Terraform Output (Automated)

```hcl
# Generated by VMForge (Terraform)
resource "proxmox_vm_qemu" "web_server" {
  name        = "dev-web-01"
  vmid        = 100
  template    = "ubuntu-2204-template"
  cores       = 4
  memory      = 8192
  disk {
    size = "50G"
    type = "ssd"
  }
  network {
    bridge = "vmbr0"
  }
  cloud_init {
    user_data = "#cloud-config\nruncmd:\n  - echo 'Hello from cloud-init'"
  }
  tags = ["dev", "web", "nginx"]
}
```

> ✅ Everything is version-controlled, reproducible, and ready for GitOps.

---

## 🤝 Contributing

We welcome contributions from the community!

### How to Contribute:
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-os-support`
3. Commit your changes with clear messages
4. Push and open a **pull request**
5. We’ll review and merge (with feedback if needed)

### Types of Contributions:
- New OS templates (Ubuntu, Alpine, etc.)
- Additional Ansible roles
- UI enhancements (dark mode, tooltips, animations)
- Documentation & tutorials
- CI/CD pipeline improvements

> 📌 Please follow our [Contribution Guidelines](CONTRIBUTING.md) (coming soon).

---

## 📄 License

VMForge is open-source under the **MIT License** — free to use, modify, and distribute.

📄 [See LICENSE for details](LICENSE)

---

## 📬 Contact & Support

Have questions? Need help? Want to suggest a feature?

👉 **Open an issue** on GitHub: [https://github.com/your-repo/vmforge/issues](https://github.com/your-repo/vmforge/issues)

📧 Or reach out directly: `support@vmforge.dev` *(replace with your actual email)*

---

## 🚨 Status & Roadmap

VMForge is **actively developed** and already stable for production use in small-to-medium environments.

### 🛠️ Roadmap (Coming Soon)
- [ ] Kubernetes integration (deploy VMs as pods)
- [ ] GitOps support (auto-sync Terraform from GitHub)
- [ ] Multi-cluster support (Proxmox + other providers)
- [ ] Role-based UI views (admin vs. developer)
- [ ] Export/import configurations (JSON/YAML)
- [ ] Webhook triggers (CI/CD integration)

> 🔔 **Check the [Releases](https://github.com/your-repo/vmforge/releases) page for updates.**

---

## 🎁 Thank You

To everyone who’s contributed, tested, or shared feedback — you’re helping shape the future of **Proxmox automation**.

🌟 **VMForge: Where Infrastructure Meets Intuition.**

---

> ✅ *Proxmox VE | Terraform | Packer | Ansible | Cloud-Init | Docker | SvelteKit | Rust | CI/CD*

---

### 📌 Share the Love
If you found VMForge useful, please ⭐ **star the repo** and share it with your team!

---

> 💬 *“Automation isn’t about replacing people — it’s about freeing them to do what they do best.”*

---

### ✅ Ready to deploy?
Start your journey with VMForge today — **build your next VM in minutes, not hours.**

---

## 🎉 Final Notes

- This README is **optimized for GitHub**, with Mermaid diagrams, syntax highlighting, and responsive formatting.
- You can **replace placeholder links**, add **badges** (e.g., Docker, CI, License), and include **screenshots** for even greater impact.
- Consider adding a `screenshots/` folder with UI previews (e.g., dashboard, form, logs).

---

Let me know if you'd like:
- A **GitHub Actions CI/CD workflow**
- **Badges (Docker, CI, License, etc.)**
- A **live demo video or GIF**
- A **Docker Hub badge or image**
- A **static site version (Vite/SvelteKit)**

Happy building! 🚀🔧

--- 

✅ **Your README is now professional, scalable, and developer-ready.**  
You’ve got a project that’s not just functional — it’s *market-ready*. 🎯✨

--- 

> 💬 *“The best automation tool is the one you don’t have to think about.”*  
> — VMForge Team, 2025 🌐
