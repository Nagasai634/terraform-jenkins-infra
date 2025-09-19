variable "project_id" {
    type = string
    default = "emerald-spring-465406-s1"
}

variable "network_name" {
    type = string
    default = "sai-vpc"
}

variable "sub_name" {
    type = string
    default = "sai-subnet"
}
variable "firewall_name" {
    type = string
    default = "allow-all-ssh"
}
variable "region_name" {
    type = string
    default = "us-central1"
}

variable "zone_name" {
    type = string
    default = "us-central1-a"
}
variable "vm_user" {
    type = string
    default = "sai"
}
