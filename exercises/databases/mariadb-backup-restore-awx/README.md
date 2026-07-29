# MariaDB backup and restore

This exercise backs up a MariaDB database on one Vagrant VM and restores it on a second VM.

Run from this folder:

```bash
vagrant up
ansible-playbook -i ansible/inventory.ini ansible/site.yml --ask-vault-pass
```

The database variables are stored in the encrypted `ansible/vault.yml` file. The AWX files are optional.

Check the SSH ports in `ansible/inventory.ini` after starting the VMs.
