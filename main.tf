provider "google" {
  project = var.project_id
  region = var.region_name
}


resource "google_compute_network" "tf_net" {
    name = var.network_name
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tf_sub" {
    name = var.sub_name
    network = google_compute_network.tf_net.id
    region =  var.region_name
    ip_cidr_range = "10.5.0.0/24"
}

resource "google_compute_firewall" "tf_fire" {
    name = var.firewall_name
    network = google_compute_network.tf_net.name
    allow {
      ports = ["22","8080"]
      protocol = "tcp"
    }
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["jenkins-master","jenkins-slave"]
  
}
resource "tls_private_key" "jenkins-keys" {
    algorithm = "RSA"
    rsa_bits = "4096"
}

resource "local_file" "jenkins-public" {
    content = tls_private_key.jenkins-keys.public_key_openssh
    filename = "${path.module}/id_rsa.pub"
}
resource "local_file" "jenkins-private" {
    content = tls_private_key.jenkins-keys.private_key_pem
    filename = "${path.module}/id_rsa"
}
locals {
  instances = {
    jenkins-master = {
        tags = ["jenkins-master"]
        script = "${path.module}/jenkins-master.sh"
    }
    jenkins-slave = {
        tags = ["jenkins-slave"]
        script = "${path.module}/jenkins-slave.sh"
    }
  }
}


resource "google_compute_instance" "tf_vm" {
    for_each = local.instances
    name = each.key
    zone = var.zone_name
    machine_type = "e2-medium"
    boot_disk {
      initialize_params {
        image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      }
    }
    network_interface {
      network = google_compute_network.tf_net.id
      subnetwork = google_compute_subnetwork.tf_sub.id
      access_config {
        
      }

    }
    metadata = {
      ssh-keys = "${var.vm_user}:${tls_private_key.jenkins-keys.public_key_openssh}"
    }
    connection {
      type = "ssh"
      user = "${var.vm_user}"
      host = self.network_interface[0].access_config[0].nat_ip
      private_key = tls_private_key.jenkins-keys.private_key_pem
    }
  provisioner "remote-exec" {
    inline = [ 
        each.key == "jenkins-slave" ? "mkdir -p /home/${var.vm_user}/jenkins" : "echo 'Not an slave vm'"
     ]
  }
  tags = each.value.tags
  metadata_startup_script = file(each.value.script)

  
}

