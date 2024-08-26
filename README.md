# CKAN Ansible Deployments
Ansible playbook for the deployment of a custom CKAN for spatial data management in different environments.

Deployments available for the following OS:
  - RedHat Enterprise Linux 9 ([RHEL 9](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9))
  - RedHat Enterprise Linux 8 ([RHEL 8](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8))
  - [WIP] Debian 12 ([Bookworm](https://www.debian.org/releases/bookworm/))
  - [WIP] Ubuntu 20.04 ([Focal Fossa](https://releases.ubuntu.com/20.04/))

## Requirements
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## CKAN Ansible Deployment
1. Clone this repository to your local machine and edit the `ansible.cfg` to use the env what you want, by default `staging`:

    ```bash
    git clone https://github.com/mjanez/ckan-ansible.git && cd ckan-ansible
    vi playbook/ansible.cfg
    ```

2. Ensure that `inventory` and `hostfile` point to the desired hosts files, e.g., for `staging` (default):

    ```ini
    [defaults]

    ########################################
    # Common destinations
    ########################################

    inventory = ./inventories/staging/hosts.ini
    hostfile = ./inventories/staging/hosts.ini
    roles_path = ./roles/common:./roles/ckan:./roles/database:./roles/webserver:./roles/solr:./roles/redis:./roles/supervisor
    retry_files_save_path = ./config/tmp/retry/
    log_path = ./config/ansible.log
    stdout_callback = yaml
    ```

3. Edit the `hosts.ini` and add the target deployment servers IP addresses or `hostname` for the specific environment.

    ```bash
    vi playbook/inventories/staging/hosts.ini
    ```

    ```ini
    [ckan_servers]
    staging_01 ansible_host=192.168.68.01 ansible_user=sudouser ansible_port=222 ansible_ssh_pass=sudouserpassword ansible_connection=ssh
    ```

    Or for local use:

    ```ini
    [ckan_servers]
    staging_01 ansible_connection=local
    ```

4. Modify the host variables in `playbook/inventories/*/host_vars/*_01.yml`, for instance, [`staging_01.yml`](./playbook/inventories/staging/host_vars/staging_01.yml). Check any necessary variables such as database credentials, CKAN versions, and other specific settings.

    ```yaml
    ### Webserver #########################################
    proxy_server_name: localhost
    proxy_server_url: http://{{ proxy_server_name }}
    proxy_local_services_url: http://localhost
    ...

    ### Database service #########################################
    postgres_port: 5432
    postgres_dir: "/var/lib/pgsql/data"
    ckan_database: {
      postgres_user: "postgres",
      postgres_password: "postgres",
      ckan_db_user: "ckandbuser",
      ckan_db_password: "ckandbpassword",
      ckan_db: "ckan_db",
      postgres_host: "localhost",
    }

    ...
    ```

>[!CAUTION]
> The `playbook/inventories/*/host_vars/*.yml` file contain customizable configuration variables for deployment. Remember to change before running the Ansible playbook. Specifically the host users/pwds info, and CKAN configuration:  `ckan_sysadmin_name`, `ckan_sysadmin_password` and `ckan_sysadmin_email`. Also the `proxy_server_name` and `nginx_port` for correct deployment.

>[!IMPORTANT]
> Also if using a SSH password authentication for private repos [create a SSH key pair](.ssh/keys/README.md) and copy the keys to the `./playbook/roles/common/files/keys`. The filenames of the keypair files must begin with id_ (e.g. `id_rsa` + `id_rsa.pub`)

5. Last, run the Ansible playbook to deploy CKAN on the target server. The following command will deploy CKAN on the target server using the playbook configuration. The `-vvv` flag is used for verbose output:

    ```bash
    # Location of the ansible.cfg file based on the clone directory
    export ANSIBLE_CONFIG=$(pwd)/playbook/ansible.cfg

    # Location if ckan-ansible is cloned in the home directory
    export ANSIBLE_CONFIG=$HOME/ckan-ansible/playbook/ansible.cfg

    # Run the ansible playbook, Verbose with  -vvv
    ansible-playbook $HOME/ckan-ansible/playbook/playbook.yml
    ```

    The `ANSIBLE_CONFIG` environment variable is used to specify the location of the `ansible.cfg` file. This is useful when you have multiple Ansible configurations and you want to specify which one to use, eg. `rhel-9`, `ubuntu-20.04`, etc.

## Test
### Vagrant
Once you have [Vagrant](https://www.vagrantup.com/docs/installation), [VirtualBox](https://www.virtualbox.org/wiki/Downloads)  installed, run the following commands under your [project directory](https://learn.hashicorp.com/tutorials/vagrant/getting-started-project-setup?in=vagrant/getting-started):

1. Start the VM:

  ```bash
  # Change to the project directory
  cd ckan-ansible

  # Change to a specific OS directory
  cd vagrant/rhel/rhel-9

  # Edit the host_vars file: ansible_host, ansible_port, ansible_user, ansible_ssh_pass with the Vagrantfile values and .env file as needed
  vi playbook/inventories/staging/host_vars/staging_01.yml
  vi .env

  # Start the virtual machine, vagrant copy the playbook to the VM
  vagrant up

  # Launch ansible playbook
  vagrant ssh
  ```

2. In the virtual machine, run the following commands to deploy CKAN with Ansible:

  ```bash
  # ckan-ansible has been cloned into the home directory
  export ANSIBLE_CONFIG=$HOME/ckan-ansible/playbook/ansible.cfg

  # Verbose with  -vvv
  ansible-playbook $HOME/ckan-ansible/playbook/playbook.yml
  ```

  >[!TIP]
  > `ckan-ansible/*/*` are rsynced to the VM at `/home/vagrant/ckan-ansible/*/*`, you can edit the playbook in your local machine and run the ansible-playbook command in the VM using [VSCode](#vagrant-and-visual-studio-code).


1. Once the playbook has finished, you can access CKAN at `http://192.168.56.20` from your local machine.

### Docker [WIP]
Once you have [Docker](https://docs.docker.com/get-docker/) installed, run the following commands under your [project directory](https://docs.docker.com/compose/gettingstarted/):

```bash
# Edit the .env file with the docker-compose values
vi .env

# Up the docker compose services
docker-compose up -d

# Test the ssh connection
ssh -p 2222 ckan@localhost
```

### Virtual Box
Could you  https://developers.redhat.com/rhel8/install-rhel8-vbox#overview


RHEL info:
- [RHEL](https://developers.redhat.com/rhel8/install-rhel8-vbox#)
- [DVD Binary files (`.iso`)](https://developers.redhat.com/products/rhel/download)


## Information
### Vagrant commands
```bash
# To obtain info of the SSH connection
vagrant ssh-config

# To stop the virtual machine
vagrant halt

# To suspend the virtual machine
vagrant suspend

# Terminate the virtual machine
vagrant destroy --force
```

### Vagrant and Visual Studio Code
You can use the `vagrant ssh-config` command to get the SSH configuration for your Vagrant machine, which can be simpler. Here's how:

1. Run `vagrant ssh-config` in the terminal in your Vagrant project directory. This will print the SSH configuration for your Vagrant machine.

2. Copy the output of `vagrant ssh-config` into your SSH configuration file (`~/.ssh/config`).

3. In VS Code, open the command palette and run the `"Remote-SSH: Connect to Host..."` command. Choose your Vagrant machine from the list of hosts.

VS Code will connect to your Vagrant machine and you will be able to edit files directly on the Vagrant machine using VS Code.

### NGINX Configuration
The base configuration uses an NGINX image as the front-end (ie: reverse proxy). It includes HTTPS running on port number 8443. A "self-signed" SSL certificate is generated. The ENV `proxy_server_name`, NGINX `server_name` directive and the `CN` field in the SSL certificate have been both set to 'localhost'. This should obviously not be used for production.

Creating the SSL cert and key files as follows:
`openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=DE/ST=Berlin/L=Berlin/O=None/CN=localhost" -keyout ckan-local.key -out ckan-local.crt`
The `ckan-local.*` files will then need to be moved into the `ckan-ansible/playbook/roles/webserver/tasks/files` directory

## Structure of the Ansible playbook
  ```bash
    playbook/
    ├── ansible.cfg
    ├── playbook.yml
    ├── inventories/
    │   ├── group_vars/
    │   │   ├── all.yml
    │   │   ├── production_01.yml
    │   ├── os_vars/
    │   │   ├── archlinux.yml
    │   │   ├── centos-8.yml
    │   │   ├── centos-9.yml
    │   │   ├── debian-12.yml
    │   │   ├── redhat-8.yml
    │   │   ├── redhat-9.yml
    │   ├── production/
    │   │   ├── hosts.ini
    │   │   └── host_vars/
    │   │       ├── production_01.yml
    │   ├── staging/
    │       ├── hosts.ini
    │       └── host_vars/
    │           └── staging_01.yml
    └── roles/
        ├── ckan/
        │   ├── tasks/
        │   │   └── main.yml
        │   └── ...
        ├── ckan_pycsw/
        │   ├── tasks/
        │   │   └── main.yml
        │   └── ...
        ├── common/
        │   ├── files/
        │   ├── tasks/
        │   │   └── main.yml
        │   └── ...
        ├── database/
        │   ├── tasks/
        │   │   └── main.yml
        │   └── ...
        ├── redis/
        │   ├── tasks/
        │   │   └── main.yml
        │   └── ...
        ├── solr/
        │   ├── tasks/
        │   │   └── main.yml
        │   └── ...
        ├── supervisor/
        │   ├── tasks/
        │   │   └── main.yml
        │   └── ...
        └── webserver/
            ├── tasks/
            │   └── main.yml
            └── ...
  ```

This directory structure organizes the `ckan-ansible` project. Here's an explanation:

* `ansible.cfg`: Ansible configuration file. This file sets global configurations for Ansible, such as the inventory file location, roles path, logging, and other settings. It ensures that Ansible knows where to find the necessary files and how to execute the playbooks.
* `playbook.yml`: Ansible playbook for deploying CKAN. This file contains a series of tasks and roles that define the steps required to set up and configure CKAN and its dependencies. It orchestrates the deployment process by specifying which roles to apply and in what order.
* `inventories/`: Inventory files for different environments (e.g., production, staging). These files list the servers (hosts) that Ansible will manage. Each environment has its own directory containing the relevant inventory files.
  * `group_vars/`: Group-specific variables. These files define variables that apply to groups of hosts, allowing for centralized configuration management.
  * `os_vars/`: OS-specific variables. These files define variables specific to different operating systems, ensuring that tasks are executed correctly on different OS types.
  * `production/`: Production environment inventory.
    * `hosts.ini`: Hosts file for production.
    * `host_vars/`: Host-specific variables.
  * `staging/`: Staging environment inventory.
    * `hosts.ini`: Hosts file for staging.
    * `host_vars/`: Host-specific variables.
* `roles/`: Ansible roles for different components.
  * `ckan/`: CKAN installation and configuration.
  * `ckan_pycsw/`: [ckan-pycsw](https://github.com/mjanez/ckan-pycsw) CSW/INSPIRE endpoint.
  * `common/`: Common tasks shared across different components. Also contains the `files/keys/` directory for copying SSH keys to the target server as needed.
  * `database/`: PostgreSQL databases.
  * `redis/`: Redis.
  * `solr/`: Solr.
  * `supervisor/`: Supervisor configuration.
  * `webserver/`: Web server (NGINX).

### How They Work Together
1. **Configuration (`ansible.cfg`)**:
   - Sets the default inventory file location (`inventories/staging/hosts.ini` or `inventories/production/hosts.ini`).
   - Defines the roles path, so Ansible knows where to find the roles.
   - Configures logging and other settings to control Ansible's behavior.

2. **Inventory (`hosts.ini`)**:
   - Lists the servers that Ansible will manage.
   - Specifies connection details for each server (e.g., IP address, SSH user, port).
   - Can be environment-specific (e.g., `staging`, `production`).

3. **Playbook (`playbook.yml`)**:
   - Defines the sequence of tasks and roles to be executed on the servers listed in the inventory.
   - Uses the roles defined in the `roles/` directory to perform specific tasks (e.g., installing CKAN, configuring the database).

4. **Variables (`group_vars/`, `host_vars/`, `os_vars/`)**:
   - Provide configuration details that can be applied to groups of hosts, individual hosts, or specific operating systems.
   - Ensure that tasks are executed with the correct parameters and settings.

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE - see the [LICENSE](LICENSE) file for details.