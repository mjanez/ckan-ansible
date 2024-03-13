FROM registry.access.redhat.com/ubi9/ubi:9.3
LABEL maintainer="mjanez" \
      name="ckan-ansible" \
      version="rhel-9.3"

# Set up environment variables
ENV ANSIBLE_DIR=/opt 
ENV SSH_PORT=22
ENV CKAN_PORT=5000
ENV NGINX_PORT=80
ENV CKAN_USER=ckan

# Install necessary packages and install Ansible
RUN dnf update -y && \
    # Basic packages
    dnf -y install sudo nano git wget gcc openssl-devel libffi-devel make automake cmake \
    # Python dependencies
    python3 python3-pip libpq && \
    dnf clean all && \
    # Install Ansible
    pip3 install --no-cache-dir virtualenv && \
    pip3 install --no-cache-dir ansible && \
    # Create ckan user/group with sudo access
    groupadd -g 92 ${CKAN_USER} && \
    useradd -u 92 -m -d /home/${CKAN_USER} -s /bin/bash -g ${CKAN_USER} ${CKAN_USER} && \
    echo "${CKAN_USER} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${CKAN_USER} && \
    chmod 0440 /etc/sudoers.d/${CKAN_USER}

# SSH setup
RUN mkdir -p /home/ckan/.ssh && \
    chmod 700 /home/ckan/.ssh && \
    chown ckan:ckan /home/ckan/.ssh && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    chmod o-rwx /home/ckan/.ssh

# Copy the public key
COPY docker/ssh/keys/ssh.pub /home/ckan/.ssh/authorized_keys

RUN chown ckan:ckan /home/ckan/.ssh/authorized_keys && \
    chmod 600 /home/ckan/.ssh/authorized_keys

# Switch to ckan user
USER ${CKAN_USER}

EXPOSE ${CKAN_PORT} ${SSH_PORT} ${NGINX_PORT}

# Keep container running
CMD tail -f /dev/null
