output "vm_list" {
  value = concat(
    [
      for vm in yandex_compute_instance.web : {
        name = vm.name
        id   = vm.id
        fqdn = vm.fqdn
      }
    ],
    [
      for vm in yandex_compute_instance.db : {
        name = vm.name
        id   = vm.id
        fqdn = vm.fqdn
      }
    ]
  )
  description = "List of dictionaries containing web and db instances"
}
