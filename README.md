# ckan-ansible
Ansible playbook to deploy CKAN on different environments.

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

Customize the deployment configurations in `group_vars/*` to match your requirements. Modify any necessary variables such as database credentials, CKAN versions, and other specific settings.

Run the Ansible playbook to deploy CKAN:

    ```bash
    ansible-playbook playbooks/production/deploy_ckan.yml
    ```

### Configuration
The `inventories/production/host_vars/*.yml` file contains configuration variables that can be customized according to your deployment needs. These variables include database credentials, CKAN version, data storage paths, and other CKAN-specific settings. Review and modify these variables before running the Ansible playbook.