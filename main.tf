# The provider block is essential. Harness will handle the credentials.
provider "google" {
  project = "project-demos-469216"
  region  = "us-central1"
  zone    = "us-central1-a"
}

# Create a network
resource "google_compute_network" "vpc_network" {
  name = "terraform-vpc-network"
  auto_create_subnetworks = true
}

# Firewall rule to allow SSH access via IAP
resource "google_compute_firewall" "allow_ssh_from_iap" {
  name    = "allow-ssh-from-iap"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["ssh-iap"]
}

# Firewall rule to allow HTTP/HTTPS traffic to the application on port 8000
resource "google_compute_firewall" "allow_web_traffic" {
  name    = "allow-web-traffic"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8000"]
  }
  source_ranges = ["0.0.0.0/0"]
}

# Define the GCE instance
resource "google_compute_instance" "app_vm" {
  name         = "todo-app-instance" # Changed the name for clarity
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  # Add the tag for the SSH firewall rule
  tags         = ["ssh-iap"]

  # Use a public image
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      # This block allows an external IP
    }
  }

  # Startup script to install Docker and run the application
  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo usermod -aG docker $USER
    sudo docker run -d -p 8000:8000 ganesh243/python-todo-app:latest
  EOT
}

# Output the external IP address of the VM
output "instance_ip_address" {
  value = google_compute_instance.app_vm.network_interface[0].access_config[0].nat_ip
}
