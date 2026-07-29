# SSH container images

This exercise builds Ubuntu and Debian images with SSH using Ansible and Podman.

Run from this folder:

```bash
ansible-playbook build_container_images.yml
```

The playbook creates a local SSH key pair. Generated keys are ignored by Git.
