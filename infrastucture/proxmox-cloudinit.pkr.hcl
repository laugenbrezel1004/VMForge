

source "proxmox-iso" "ubuntu_cloudimg" {
  # Proxmox-Verbindung
  proxmox_url              = var.proxmox_api_url
  username                 = var.proxmox_api_token_id     # Format: "USER@REALM!TOKENID"
  token                    = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true  # Nur für Testumgebungen!

  # VM-Einstellungen
  vm_id                    = 9000  # Template-ID
  vm_name                  = "ubuntu-22.04-cloudimg"
  template_description     = "Ubuntu 22.04 mit Cloud-Init"
  node                     = "proxmox"  # Dein Proxmox-Knoten
  #pool                     = "terraform"  # Optional: Ressourcen-Pool

  # ISO dynamisch herunterladen
  iso_url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  iso_checksum     = "sha256:10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
  iso_storage_pool = "local"  # ISO wird hier gespeichert
  unmount_iso      = true

  # Cloud-Init vorbereiten
  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"  # Für Cloud-Init-Disk

  # Hardware-Konfiguration
  cores    = 2
  memory   = 2048
  scsi_controller = "virtio-scsi-pci"

  # SSH für Provisioning
  ssh_username = "ubuntu"
  ssh_password = "ubuntu"  # Wird von Cloud-Init überschrieben
  ssh_timeout  = "15m"

  # Boot-Kommando (für Cloud-Init)
  boot_command = [
    "<esc><wait>",
    "linux /casper/vmlinuz quiet autoinstall ds=nocloud-net;s=/cdrom/nocloud/ --",
    "<enter>"
  ]
  boot_wait = "5s"

  # Provisioner (optional)
  #boot_command = ["<enter><wait>"]  # Falls kein Autoinstall benötigt
}

build {
  sources = ["source.proxmox-iso.ubuntu_cloudimg"]

  # Provisioning-Skripte (z.B. Pakete installieren)
  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y qemu-guest-agent",
      "sudo systemctl enable qemu-guest-agent"
    ]
  }
}