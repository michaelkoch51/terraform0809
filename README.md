# Домашнее задание к занятию «Управляющие конструкции в коде Terraform» - Михаил Кочнев

### Задание 1
Проект успешно инициализирован, конфигурация применена. 
Входящие правила «Группы безопасности» в ЛК Yandex Cloud:
![Группа безопасности](https://github.com/user-attachments/assets/ef70d1c1-5b28-4e19-9cec-57571a559af3)

---

### Задание 2
1. Создан файл `count-vm.tf`, описывающий создание двух прерываемых ВМ (`web-1`, `web-2`) с использованием мета-аргумента `count`.
2. Создан файл `for_each-vm.tf`, описывающий создание ВМ для баз данных (`main`, `replica`) с различными параметрами через `for_each` и строго типизированную переменную `each_vm`.
3. Настроена зависимость `depends_on`: ВМ из `count` создаются строго после ВМ из `for_each`.
4. Реализовано динамическое считывание публичного SSH-ключа с помощью функции `file("~/.ssh/id_rsa.pub")` в блоке `locals`.

---

### Задание 3
1. В файле `disk_vm.tf` с помощью мета-аргумента `count` описано создание 3 виртуальных дисков размером по 1 Гб.
2. В том же файле создана одиночная ВМ `storage`, к которой созданные диски подключаются динамически с помощью блока `dynamic "secondary_disk"` и цикла `for_each`.

---

### Задание 4
1. В файле `ansible.tf` настроена автоматическая генерация Ansible Inventory файла `hosts` с помощью функции `templatefile()` и шаблона `hosts.tftpl`.
2. Инвентарь динамически обрабатывает группы хостов (`[webservers]`, `[databases]`, `[storage]`) и включает переменную `fqdn`.

Результат генерации файла `hosts`:
![Ansible Hosts](https://github.com/user-attachments/assets/a9ecfeda-7001-4d8b-a892-ee778bba8f8f)

---

### Задание 5* (необязательное)
Написан итеративный блок `output "vm_list"`, который собирает ВМ из ресурсов `count` и `for_each` в плоский список словарей.
Вывод команды `terraform output`:
![Terraform Output](https://github.com/user-attachments/assets/eb732e8a-6414-453b-93ac-0b91b8e506d5)

---

### Задание 6* (необязательное)
В файл `ansible.tf` добавлен ресурс `null_resource` с провайдером `local-exec` для автоматизации вызова `ansible-playbook` после обновления инвентаря хостов. В файл-шаблон `hosts.tftpl` добавлено тернарное выражение для гибкой подстановки IP: `i.network_interface.nat_ip_address != "" ? i.network_interface.nat_ip_address : i.network_interface.ip_address`.

---

### Задание 7* (необязательное)
Выражение в `terraform console` для удаления 3-го элемента (индекс 2) из списков структуры `local.vpc`:
```hcl
{
  "network_id" = local.vpc.network_id
  "subnet_ids" = concat(slice(local.vpc.subnet_ids, 0, 2), slice(local.vpc.subnet_ids, 3, length(local.vpc.subnet_ids)))
  "subnet_zones" = concat(slice(local.vpc.subnet_zones, 0, 2), slice(local.vpc.subnet_zones, 3, length(local.vpc.subnet_zones)))
}
```

---

### Задание 8* (необязательное)
Синтаксически корректный и исправленный вариант tpl-шаблона:
```text
[webservers]
%{~ for i in webservers ~}
\${i["name"]} ansible_host=\({i["network_interface"]["nat_ip_address"]} platform_id=\){i["platform_id"]}
%{~ endfor ~}
```

---

### Задание 9* (необязательное)
Terraform-выражения для формирования списков строк:
1. Список от `rc01` до `rc99`:
```hcl
[for i in range(1, 100) : format("rc%02d", i)]
```
2. Фильтрованный список (пропуск окончаний на 0, 7, 8, 9 с исключением для 19):
```hcl
[for i in range(1, 97) : format("rc%02d", i) if !contains([0, 7, 8, 9], i % 10) || i == 19]
```
