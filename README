# Elk-stack anf filebeat vagrant-ansible setup

This is a setup of an ELK-stack version 6.6 with Filebeat on separate virtual machines. Communication between Logstash and Filebeat servers is secured with ssl_certificates. In this setup the certificate authority is self generated.

### Example
**CA authority:**
$ openssl genrsa -des3 -out files/certs/myCA.key 2048
$ openssl req -x509 -new -nodes -key files/certs/myCA.key -sha256 -days 1825 -out files/certs/myCA.pem
**Self signed certificate:**
The CN of certificate must match the name of ELK host.
$ openssl genrsa -out files/certs/filebeat.key 2048
$ openssl req -new -key files/certs/filebeat.key -out files/certs/filebeat.csr
$ openssl x509 -req -in files/certs/filebeat.csr -CA files/certs/myCA.pem -CAkey files/certs/myCA.key -CAcreateserial -out files/certs/filebeat.crt -days 1825 -sha256

### Vagrant
Vagrantfile needs plugins hostmanager and disksize to be installed:
$ vagrant plugin install vagrant-hostmanager
$ vagrant plugin install vagrant-disksize

Configurations for Vagrantfile are in vagrantfile.yaml. Contains names and ip addresses of the virtual machines

### Ansible
  Configurations for ansible setup are in elk.yml. Contains names of hosts which have to mach with vagrantfile.yaml hosts.
  Index templates arevlocated in roles/elasticsearch/files/templates/*.json. Includes number of shards and replicas.
