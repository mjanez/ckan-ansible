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
