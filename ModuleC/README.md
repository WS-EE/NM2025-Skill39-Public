Bootstrap the GNS3 server:
```
ansible-playbook -i <gns3_host>, bootstrap.yaml
```

Configure the GNS3 with competitor user accounts and import required templates
```
ansible-playbook -i <gns3_host>, gns3.yaml
```
