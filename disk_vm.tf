# 1. Создаем 3 одинаковых диска по 1 Гб
resource "yandex_compute_disk" "storage_disk" {
  count = 3
  name  = "disk-${count.index + 1}"
  size  = 1
  zone  = "ru-central1-a" # Проверь, что в main.tf указана эта же зона
}

# 2. Создаем одиночную ВМ "storage"
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id # Ubuntu OS
    }
  }

  # Динамический блок для подключения всех созданных дисков
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk
    content {
      disk_id = secondary_disk.value.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_key}"
  }

  scheduling_policy {
    preemptible = true
  }
}
