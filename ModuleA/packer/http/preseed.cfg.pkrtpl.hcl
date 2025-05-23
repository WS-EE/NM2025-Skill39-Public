#_preseed_V1
# https://www.debian.org/releases/stable/example-preseed.txt

### OS Localization
d-i debian-installer/locale string en_US.UTF-8
d-i keyboard-configuration/xkb-keymap select us

### Network configuration
d-i netcfg/choose_interface select auto

# Any hostname and domain names assigned from dhcp take precedence over
# values set here. However, setting the values still prevents the questions
# from being shown, even if values come from dhcp.
d-i netcfg/get_hostname string unassigned-hostname
d-i netcfg/get_domain string unassigned-domain
# Disable that annoying WEP key dialog.
d-i netcfg/wireless_wep string

### Mirror settings
d-i mirror/country string manual
d-i mirror/http/hostname string http.us.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string

### Account setup
# Skip creation of a root account (normal user account will be able to
# use sudo).
d-i passwd/root-login boolean true
# Alternatively, to skip creation of a normal user account.
d-i passwd/make-user boolean false
# Root password in clear text
d-i passwd/root-password password ${root_password}
d-i passwd/root-password-again password ${root_password}

### Clock and time zone setup
d-i clock-setup/utc boolean true
d-i time/zone string UTC
d-i clock-setup/ntp boolean true

### Partitioning
# You can choose one of the three predefined partitioning recipes:
# - atomic: all files in one partition (default)
d-i partman-auto/choose_recipe select atomic
d-i partman-auto/method string lvm
d-i partman-auto-lvm/guided_size string max
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
# This makes partman automatically partition without confirmation
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

### Apt setup
# Choose, if you want to scan additional installation media
d-i apt-setup/cdrom/set-first boolean false
# Select which update services to use; define the mirrors to be used.
# Values shown below are the normal defaults.
d-i apt-setup/services-select multiselect security, updates
d-i apt-setup/security_host string security.debian.org

### Package selection
tasksel tasksel/first multiselect ssh-server
# Individual additional packages to install
d-i pkgsel/include string bash-completion cloud-init python3 qemu-guest-agent sudo net-tools
# Upgrade packages after debootstrap (none, safe-upgrade, full-upgrade)
d-i pkgsel/upgrade select full-upgrade
popularity-contest popularity-contest/participate boolean false

### Boot loader installation
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
d-i grub-installer/bootdev  string /dev/vda

### Finishing up the installation
# Avoid that last message about the install being complete.
d-i finish-install/reboot_in_progress note

#### Advanced options
# Add SSH key to root user for Packer build
d-i preseed/late_command string in-target /bin/sh -c "sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config"

