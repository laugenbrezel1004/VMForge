resource "proxmox_vm_qemu" "test_vm" {
  name        = "test-vm-terraform"
  target_node = "proxmox"  # Name deines Proxmox Hosts

  # VM Einstellungen
  desc        = "Test VM created by Terraform"
  vmid        = 9999  # Freie VM ID oder weglassen für automatische Vergabe
  onboot      = true
  agent       = 1  # QEMU Guest Agent aktivieren

  # Betriebssystem Einstellungen
  iso         = "local:iso/ubuntu-24.04.2-live-server-amd64.iso"  # ISO Image auf Proxmox
  sockets     = 1
  cores       = 2
  memory      = 2048

  # Festplatte
  disk {
    size    = "20G"
    type    = "scsi"
    storage = "local-lvm"
  }

  # Netzwerk
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-Init Einstellungen (optional)
#  ciuser     = "ubuntu"
#  cipassword = "ubuntu"
#  sshkeys    = <<EOF
#ssh-rsa AAAAB3NzaC1yc2E... user@example.com
#EOF

  # Lifecycle: Ignoriere Änderungen an ISO und Netzwerk, um ungewollte Neustarts zu vermeiden
  lifecycle {
    ignore_changes = [
      network,
      iso,
    ]
  }
}
