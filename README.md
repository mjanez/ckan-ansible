# CKAN Ansible Deployments
Ansible playbooks for the deployment of a custom CKAN for spatial data management in different environments.

Deployments available for the following OS:
  - [WIP] RedHat Enterprise Linux 9
  - [WIP] RedHat Enterprise Linux 8
  - [WIP] Debian 12
  - [WIP] Ubuntu 20.04

## Requirements
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## CKAN Ansible Deployment
Clone this repository to your local machine:

```bash
git clone https://github.com/mjanez/ckan-ansible.git
cd ckan-ansible
```

Edit the `inventory` folder hosts vars and add the target deployment servers IP addresses or `hostname` for the specific environment.

Customize the deployment configurations in `host_vars/*` to match your requirements. Modify any necessary variables such as database credentials, CKAN versions, and other specific settings.

Also specify if using a SSH password authentication or [create a SSH key pair](docker/.ssh/keys/README.md) and copy the public key to the target deployment servers.


### Example
1. Select the environment you want to deploy, e.g: `rhel-9`.

2. Edit the `playbooks/rhel/rhel-9/host_vars/production_01.yml` with the variables for the target deployment server. And put the path to the SSH private key if is not using password authentication (`ansible_ssh_private_key_file`/`ansible_ssh_pass` ).

3. Run the Ansible playbook to deploy CKAN on the target server. The following command will deploy CKAN on the target server using the `rhel-9` environment configuration. The `-vvv` flag is used for verbose output.:

    ```bash
    # Location of the ansible.cfg file based on the clone directory
    export ANSIBLE_CONFIG=$(pwd)/playbooks/rhel/rhel-9/ansible.cfg
    ansible-playbook playbooks/rhel/rhel-9/playbook.yml -vvv
    ```

> [!TIP]
> The `ANSIBLE_CONFIG` environment variable is used to specify the location of the `ansible.cfg` file. This is useful when you have multiple Ansible configurations and you want to specify which one to use, eg. rhel-9, ubuntu-20.04, etc.

### Configuration
The `inventories/production/host_vars/*.yml` file contains configuration variables that can be customized according to your deployment needs. These variables include database credentials, CKAN version, data storage paths, and other CKAN-specific settings. Review and modify these variables before running the Ansible playbook.

## Test
### Vagrant
Once you have [Vagrant](https://www.vagrantup.com/docs/installation), [VirtualBox](https://www.virtualbox.org/) and [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed, run the following commands under your [project directory](https://learn.hashicorp.com/tutorials/vagrant/getting-started-project-setup?in=vagrant/getting-started):

```bash
# Change to a specific OS directory
cd vagrant/rhel/rhel-9

# Initialize Vagrant
vagrant init alvistack/rhel-9

# Start the virtual machine
vagrant up

# Launch ansible playbook
export ANSIBLE_CONFIG=$(pwd)/playbooks/rhel/rhel-9/ansible.cfg
ansible-playbook playbooks/rhel/rhel-9/playbook.yml

# SSH into this machine
vagrant ssh

# Terminate the virtual machine
vagrant destroy --force
```

### Docker
Once you have [Docker](https://docs.docker.com/get-docker/) installed, run the following commands under your [project directory](https://docs.docker.com/compose/gettingstarted/):

```bash
# Up the docker compose services
docker-compose up -d

# Test the ssh connection
ssh -p 2222 ckan@localhost
```

## Structure of the Ansible playbooks
  ```bash
    rhel/rhel-9/
    ├── ansible.cfg
    ├── playbook.yml
    ├── group_vars/
    │   ├── all.yml
    │   └──production_01.yml
    ├── inventory/
    │   └── host.ini
    ├── host_vars/
    │   └── production_01.yml
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

* `ansible.cfg`: Contains the Ansible configuration file for the specific environment.	
* `playbook.yml`: Contains Ansible playbook for deploying CKAN and related tasks.
* `inventory/`: Contains inventories files for different environments (e.g., production, staging).
* `roles/`: Contains Ansible roles for managing different components.
  * `ckan/`: Role for managing CKAN installation and configuration.
  * `common/`: Role for common tasks shared across different components.
  * `webserver/`: Role for managing web server configuration.
  * `postgresql/`: Role for managing database installation and configuration.
  * `solr/`: Role for managing Solr installation and configuration.
  * `redis/`: Role for managing Redis installation and configuration.

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE - see the [LICENSE](LICENSE) file for details.