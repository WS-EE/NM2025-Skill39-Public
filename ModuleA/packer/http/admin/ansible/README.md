# How to use this folder
This folder shold be on the host `admin`.

Location on the host: `/home/meister/`
> `hosts.yaml` should be in `/home/meister/ansible/hosts.yaml` in the end.
## Tabel of content
1. [Install ansible with pip](#install-ansible-with-pip)
2. [Install ansible with apt](#install-ansible-with-apt)
3. [Test ansible connection](#test-ansible-connection)

## Install ansible with pip
### Install required packages from package manager

Install pip and venv from the available package manager.

This is how to do it on Debian:
```
~$ sudo apt install python3-pip python3-venv sshpass
```
> `sshpass` is needed if we want to connect with a password.

### Install ansible
Create a directory for ansible and create a venv
```
~$ mkdir ansible
~$ cd ansible/
~/ansible$ python3 -m venv .venv
~/ansible$ source .venv/bin/activate
(.venv) ~/ansible$
```
Update pip and install ansible
```
(.venv) ~/ansible$ pip install -U pip
(.venv) ~/ansible$ pip install ansible ansible-core
```

## Install ansible with apt
Install ansible with apt. This is not recommended in production setups.
This is how to do it on Debian:
```
~$ sudo apt install ansible ansible-core sshpass
```

## Test ansible connection
Now you can test ansible against a known host.
Let's use `proxy` hosts for this example.
```
(.venv) ~/ansible$ ansible -m ping proxy
```

