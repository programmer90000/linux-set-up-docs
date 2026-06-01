To start a VM, run:
```
virsh start <vm_name>
```

To get the IP or port of a VM, run:
```
virsh vncdisplay <vm_name>
```

To connect to a VM, run:
```
vncviewer 127.0.0.1:5901
```

Replace `127.0.0.1` with the IP address the VM was created with. Replace `5901` with the port the VM was created on.
> `127.0.0.1` refers to localhost

To shutdown a VM, run:
```
virsh shutdown <vm_name>
```

To stop an unresponsive VM, run:
```
virsh destroy <vm_name>
```

To reboot a VM, run:
```
virsh reboot <vm_name>
```

To suspend a VM, run:
```
virsh suspend <vm_name>
```

To resume a suspended VM, run:
```
virsh resume <vm_name>
```

To list all VMs, run:
```
virsh list --all
```
