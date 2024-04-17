#!/bin/bash
echo "[01_update_repos] Configuring OpenSUSE repos..."
export ANSIBLE_CONFIG=$HOME/ckan-ansible/playbook/ansible.cfg

# Update system to the latest packages
sudo zypper refresh
sudo zypper update