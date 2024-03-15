#!/bin/bash
echo "[01_update_repos] Configuring RHEL 9 subscription..."
export ANSIBLE_CONFIG=$HOME/ckan-ansible/playbooks/rhel/rhel-9/ansible.cfg
sudo subscription-manager register --username "$VAGRANT_RHEL_DEV_USER" --password "$VAGRANT_RHEL_DEV_PASSWORD"
sudo subscription-manager attach --auto
sudo subscription-manager repos --enable=rhel-9-for-x86_64-baseos-rpms