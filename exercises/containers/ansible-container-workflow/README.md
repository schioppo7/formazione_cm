# Container workflow with Ansible

This exercise detects Docker or Podman, builds two SSH images, pushes them to a local registry and starts the containers.

Start the `local-registry` exercise before running this workflow.

The roles run in this order:

1. `container_registry`
2. `container_build`
3. `container_deploy`

Run from this folder:

```bash
ansible-playbook site.yml
```
