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
Clone this repository to your local machine and edit the variables of the `playbook/host_vars/production_01.yml`:

> [!CAUTION]
> Remember to change the CKAN configuration variables before running the Ansible playbook. Specifically the `ckan_sysadmin_name`, `ckan_sysadmin_password` and `ckan_sysadmin_email`. Also the `proxy_server_name` and `nginx_port` for correct deployment.

```bash
git clone https://github.com/mjanez/ckan-ansible.git
cd ckan-ansible
```

Edit the `inventory` folder hosts vars and add the target deployment servers IP addresses or `hostname` for the specific environment.

Customize the deployment configurations in `host_vars/*` to match your requirements. Modify any necessary variables such as database credentials, CKAN versions, and other specific settings.

>[!IMPORTANT]
> Also if using a SSH password authentication for private repos [create a SSH key pair](.ssh/keys/README.md) and copy the keys to the `./playbook/roles/common/tasks/files`. The filenames of the keypair files must begin with id_ (e.g. `id_rsa` + `id_rsa.pub`)


### Example
1. Select the environment you want to deploy, e.g: `rhel`.

2. Edit the `playbook/host_vars/production_01.yml`. Put the path to the SSH private key if is not using password authentication (`ansible_ssh_private_key_file`/`ansible_ssh_pass` ).

3. Run the Ansible playbook to deploy CKAN on the target server. The following command will deploy CKAN on the target server using the playbook configuration. The `-vvv` flag is used for verbose output.:

    ```bash
    # Location of the ansible.cfg file based on the clone directory
    export ANSIBLE_CONFIG=$(pwd)/playbook/ansible.cfg

    # Location if ckan-ansible is cloned in the home directory
    export ANSIBLE_CONFIG=$HOME/ckan-ansible/playbook/ansible.cfg

    # Run the ansible playbook
    ansible-playbook $(pwd)/playbook/playbook.yml -vvv
    ```

    The `ANSIBLE_CONFIG` environment variable is used to specify the location of the `ansible.cfg` file. This is useful when you have multiple Ansible configurations and you want to specify which one to use, eg. `rhel-9`, `ubuntu-20.04`, etc.

> [!IMPORTANT] Configuration
> The `*/host_vars/*.yml` file contain customizable configuration variables for deployment, including database credentials, CKAN version, and web server configuration. Review and modify these before running the Ansible playbook.
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
  vi ./playbook/host_vars/production_01.yml
  vi .env

  # Start the virtual machine, vagrant copy the playbook to the VM
  vagrant up

  # Launch ansible playbook
  vagrant ssh
  ```

2. In the virtual machine, run the following commands to deploy CKAN with Ansible:

  ```bash
  ansible-playbook $HOME/ckan-ansible/playbook.yml -vvv
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
The `ckan-local.*` files will then need to be moved into the `ckan-ansible\playbook\roles\webserver\tasks\files` directory

## Structure of the Ansible playbook
  ```bash
    playbook/
    ├── ansible.cfg
    ├── playbook.yml
    ├── group_vars/
    │   ├── all.yml
    │   └──production_01.yml
    ├── inventory/
    │   └── host.ini
    ├── host_vars/
    │   └── production_01.yml
    ├── os_vars/
    │   ├── debian.yml
    │   ├── rhel-8.yml
    │   └── rhel-9.yml
    └── roles/
        ├── common/
        │   ├── tasks/
        │   │   └── files/
        │   │   └── main.yml
        │   └── ...
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
* `host_vars/`: Contains host-specific variables for different environments. Keep the same values in the `.env `file.
* `os_vars`: Contains OS-specific variables for different environments.
* `group_vars`: Contains group-specific variables for different environments.
* `roles/`: Contains Ansible roles for managing different components.
  * `ckan/`: Role for managing CKAN installation and configuration.
  * `common/`: Role for common tasks shared across different components. Also contains the `files/` directory for copying SSH keys to the target server as needed.
  * `webserver/`: Role for managing web server configuration.
  * `postgresql/`: Role for managing database installation and configuration.
  * `solr/`: Role for managing Solr installation and configuration.
  * `redis/`: Role for managing Redis installation and configuration.

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE - see the [LICENSE](LICENSE) file for details.