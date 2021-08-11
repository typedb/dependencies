terraform {
  backend "gcs" {
    bucket  = "vaticle-factory-prod-terraform-state"
    prefix  = "terraform/elk"
  }
}

provider "google" {
  project = "vaticle-factory-prod"
  region  = "europe-west2"
  zone    = "europe-west2-b"
}

resource "google_compute_firewall" "elk_api_firewall" {
  name    = "elk-api-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443", "2053"]
  }

  target_tags = ["elk"]
}

resource "google_compute_address" "elk_static_ip" {
  name = "elk-static-ip"
}

resource "google_compute_disk" "elk_additional" {
  name  = "elk-additional"
  type  = "pd-ssd"
}

resource "google_compute_instance" "elk" {
  name                      = "elk"
  machine_type              = "n1-standard-2"

  boot_disk {
    initialize_params {
      image = "vaticle-factory-prod/elk-v1"
    }
    device_name = "boot"
  }

  attached_disk {
    source = google_compute_disk.elk_additional.name
    device_name = "elk-additional"
  }

  service_account {
    email = "elk-account@vaticle-factory-prod.iam.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.elk_static_ip.address
    }
  }

  tags = ["elk"]

  metadata_startup_script = file("${path.module}/startup/startup-elk.sh")
}


resource "google_secret_manager_secret" "certificate" {
  secret_id = "certificate"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "certificate_version" {
  secret      = google_secret_manager_secret.certificate.id
  secret_data = var.secrets.certificate
}


resource "google_secret_manager_secret" "key" {
  secret_id = "key"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "key_version" {
  secret      = google_secret_manager_secret.key.id
  secret_data = var.secrets.key
}
