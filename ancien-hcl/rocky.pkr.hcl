source "qemu" "example" {
  iso_url           = "../Rocky-8.4-x86_64-minimal.iso"
  iso_checksum      = "sha256:0de5f12eba93e00fefc06cdb0aa4389a0972a4212977362ea18bde46a1a1aa4f"
  output_directory  = "build-rocky-8"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  disk_size         = "5000M"
  format            = "qcow2"
  accelerator       = "kvm"
  http_directory    = "./ks"
  ssh_username      = "root"
  ssh_password      = "%Serveur44"
  ssh_timeout       = "20m"
  vm_name           = "tdhtest"
  memory            = "2048"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  boot_wait         = "10s"
  boot_command      = ["<tab> text inst.ks=http://192.168.124.1:{{ .HTTPPort }}/rocky-8.cfg<enter><wait>"]
  qemu_binary       = "/usr/libexec/qemu-kvm"
  display           = "none"
  headless          = "true"
}


build {  
  sources = ["source.qemu.example"]

 provisioner "file" {
    destination = "/etc/systemd/system/golang-myip.service"
    source      = "./golang-myip.service"
  }


 provisioner "shell" {
    inline = [
      "echo 'Je suis vivant :) !'",
      "dnf install git go make -y",
      "echo 'Les paquets sont installés chef !'",
      "git clone https://github.com/BastienBalaud/golang-myip",
      "cd golang-myip/",
      "make",
      "echo 'Hop MyIP est pret à etre lancer'",
      "cd build/",
      "mv /root/golang-myip /opt/golang-myip/",
      "/sbin/restorecon -v /opt/golang-myip/build/server.x86_64",
      "systemctl daemon-reload",
      "systemctl start golang-myip",
      "systemctl enable golang-myip",
      "systemctl status golang-myip"
    ]
  }

}
