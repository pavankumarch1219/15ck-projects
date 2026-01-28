output "vm_names" {
  value = {
    for k, vm in azurerm_linux_virtual_machine.vm :
    k => vm.name
  }
}

