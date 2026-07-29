# Training Exercises

Small hands-on exercises for practicing containers, Ansible, Kubernetes,
databases and CI/CD. Each exercise has its own short README.

## Technologies

- Ansible and Ansible Vault
- Docker, Podman and a local container registry
- Kubernetes, Kind and Cluster API
- MariaDB, Vagrant and AWX
- Jenkins and Nginx

## Roadmap

### 1. Container foundations

- [Build SSH container images](exercises/containers/ssh-images/) with Ansible and Podman.
- [Run a local registry](exercises/containers/local-registry/) on port `5000`.
- [Automate the container workflow](exercises/containers/ansible-container-workflow/) with reusable Ansible roles.

### 2. Credentials

- [Protect registry credentials with Ansible Vault](exercises/ansible/registry-credentials-vault/) and keep the Vault password outside Git.

### 3. Kubernetes and databases

- [Create clusters with Cluster API and Kind](exercises/kubernetes/cluster-api/).
- [Back up and restore MariaDB](exercises/databases/mariadb-backup-restore-awx/) between two virtual machines. The AWX setup is optional.

### 4. CI/CD

- [Jenkins and Ansible deployment](exercises/ci-cd/jenkins-ansible-deployment/) is a starter project for deploying an Nginx application. Some pipeline files are intentionally incomplete.

## How to use the repository

Follow the roadmap in order or choose one topic. Open the exercise folder, read
its README and run the commands from that folder. Keep generated keys,
unencrypted credentials and kubeconfig files outside Git.
