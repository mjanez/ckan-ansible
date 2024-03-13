# CKAN Ansible Deployment
Ansible playbooks to deploy CKAN on different environments.

Environments:
  - RedHat Enterprise Linux 9

## Structure
```bash
/opt/
└── ckan-ansible/
    ├── inventories/
    │   ├── production/
    │   │   ├── hosts
    │   │   └── group_vars/
    │   └── staging/
    │       ├── hosts
    │       └── group_vars/
    ├── playbooks/
    │   ├── deploy_ckan.yml
    │   └── ...
    └── roles/
        ├── ckan/
        │   ├── tasks/
        │   │   └── main.yml
        │   └── ...
        ├── postgresql/
        │   ├── tasks/
        │   │   └── main.yml
        │   └── ...
        ├── solr/
        │   ├── tasks/
        │   │   └── main.yml
        │   └── ...
        ├── redis/
        │   ├── tasks/
        │   │   └── main.yml
        │   └── ...
        └── webserver/
            ├── tasks/
            │   └── main.yml
            └── ...
```

This directory structure organizes `ckan-ansible` project. Here's an explanation:

* `inventories/`: Contains inventories files for different environments (e.g., production, staging).
  * `production/`: inventories files specific to the production environment.
  * `staging/`: inventories files specific to the staging environment.
* `playbooks/`: Contains Ansible playbooks for deploying CKAN and related tasks.
* `roles/`: Contains Ansible roles for managing different components.
  * `ckan/`: Role for managing CKAN installation and configuration.
  * `common/`: Role for common tasks shared across different components.
  * `webserver/`: Role for managing web server configuration.
  * `postgresql/`: Role for managing database installation and configuration.
  * `solr/`: Role for managing Solr installation and configuration.
  * `redis/`: Role for managing Redis installation and configuration.

## CKAN Ansible Deployment
Clone this repository to your local machine:

```bash
git clone https://github.com/mjanez/ckan-ansible.git
cd ckan-ansible
```

Edit the `inventories` folder hosts vars and add the target deployment servers IP addresses or `hostname`.

Customize the deployment configurations in `host_vars/*` to match your requirements. Modify any necessary variables such as database credentials, CKAN versions, and other specific settings.

Also specify if using a SSH password authentication or [create a SSH key pair](docker/ssh/keys/README.md) and copy the public key to the target deployment servers.


### Example
1. Select the environment you want to deploy, `rhel-9.3`.

2. Edit the `playbooks/rhel-9.3/host_vars/production_01.yml` with the variables for the target deployment server. And put the SSH keys if is not using password authentication (`ansible_ssh_private_key_file`/`ansible_ssh_pass` ).

3. Run the Ansible playbook to deploy CKAN on the target server. The following command will deploy CKAN on the target server using the `rhel-9.3` environment configuration. The `-vvv` flag is used for verbose output.:

    ```bash
    # Location of the ansible.cfg file based on the clone directory
    export ANSIBLE_CONFIG=$(pwd)/playbooks/rhel-9.3/ansible.cfg
    ansible-playbook playbooks/rhel-9.3/playbook.yml -vvv
    ```

> [!TIP]
> The `ANSIBLE_CONFIG` environment variable is used to specify the location of the `ansible.cfg` file. This is useful when you have multiple Ansible configurations and you want to specify which one to use, eg. rhel-9, ubuntu-20.04, etc.

### Configuration
The `inventories/production/host_vars/*.yml` file contains configuration variables that can be customized according to your deployment needs. These variables include database credentials, CKAN version, data storage paths, and other CKAN-specific settings. Review and modify these variables before running the Ansible playbook.