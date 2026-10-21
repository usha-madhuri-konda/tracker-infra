# tracker-infra

Infrastructure and deployment configuration for [tracker-app](https://github.com/usha-madhuri-konda/tracker-app).

## Layout

| Path | What it holds |
|---|---|
| `terraform/` | AWS network and one EC2 server: VPC, subnet, security group, key pair, instance |
| `ansible/` | Configures the server: installs Docker and runs the app and Postgres containers |
| `helm/tracker-chart/` | Helm chart for running the app on Kubernetes |
| `kubernetes/` | Plain manifests and a kind cluster config for local testing |

## Secrets and local files

Nothing sensitive is committed. These stay local and are ignored by git:

- Terraform state and `terraform.tfvars`
- `ansible/inventory.ini` and `ansible/group_vars/tracker/vault.yaml` (encrypted with Ansible Vault)
- SSH keys and the Vault password file

Copy from the examples instead: `terraform/terraform.tfvars.example`, `ansible/inventory.ini.example` and `ansible/group_vars/tracker/vault.yaml.example`.

## Rebuilding the server

1. In `terraform/`, copy `terraform.tfvars.example` to `terraform.tfvars`, fill in your values, then run `terraform init` and `terraform apply`.
2. Put the new server IP in `ansible/inventory.ini`.
3. Create the encrypted vault file with `ansible-vault create ansible/group_vars/tracker/vault.yaml`, using the variable names from `vault.yaml.example`. The Vault password file path is set in `ansible/ansible.cfg`.
4. In `ansible/`, run `ansible-playbook site.yaml`.
5. When finished, run `terraform destroy` in `terraform/`.

The image version the server runs is `app_image` in `ansible/group_vars/tracker/vars.yaml`.

## Checks

Every push and pull request runs `terraform fmt -check`, `terraform validate` and `helm lint`.
