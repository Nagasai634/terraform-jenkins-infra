output "jenkins-masterip" {
    value = "https:${google_compute_instance.tf_vm["jenkins-master"].network_interface[0].access_config[0].nat_ip}:8080"
  
}
output "jenkins-slaveip" {
    value = "https:${google_compute_instance.tf_vm["jenkins-slave"].network_interface[0].access_config[0].nat_ip}:8080"
  
}