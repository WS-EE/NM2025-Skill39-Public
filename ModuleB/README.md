Host which is used to provision Module B templates with Packer does not need to be routable to Proxmox.

Change the variables at `packer/variables.auto.pkrvars.hcl` according to your environment.

```
packer init .
packer build .
```

Ansible configures the Proxmox hosts access to competitors, clone the templates with correct network parameters and creates initial snapshots of all the VMs.

```
ansible-playbook vms.yaml
ansible-playbook pve.yaml
ansible-playbook snapshot.ymal
```