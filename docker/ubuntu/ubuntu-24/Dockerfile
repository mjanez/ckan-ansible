FROM ubuntu:24.04
LABEL maintainer="mjanez" \
      name="ckan-ansible" \
      version="ubuntu-24"

# Set up environment variables
ENV ANSIBLE_DIR=/opt 
ENV SSH_PORT=22
ENV CKAN_PORT=5000
ENV NGINX_PORT=80
ENV CKAN_USER=ckan
ENV CKAN_USER_SSH_PWD=ckan

# Install necessary packages (exclude suggested or recommended) and install Ansible
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker && \
    echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker && \
    apt-get update -y && \
    # Basic packages
    apt-get -y install sudo nano git wget gcc openssh-server libssl-dev libffi-dev make automake cmake \
    # Python dependencies
    python3 python3-pip libpq-dev && \
    apt-get clean && \
    # Update pip
    pip3 install --upgrade pip && \
    # Install Ansible
    pip3 install --no-cache-dir virtualenv && \
    pip3 install --no-cache-dir ansible && \
    # Create ckan user/group with sudo access
    groupadd -g 92 ckan && \
    useradd -u 92 -m -d /home/ckan -s /bin/bash -g ckan ckan && \
    echo "ckan:${CKAN_USER_SSH_PWD}" | chpasswd && \
    echo "ckan ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/ckan && \
    chmod 0440 /etc/sudoers.d/ckan  && \
    # Clean up
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache/pip/*

# SSH setup
RUN mkdir /var/run/sshd && \
    # Configure SSH for non-root public key authentication
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    # Generate host keys
    ssh-keygen -A

# Copy the public key
RUN if [ -f .ssh/keys/ssh.pub ]; then \
    cp .ssh/keys/ssh.pub /home/ckan/.ssh/authorized_keys && \
    chown ckan:ckan /home/ckan/.ssh/authorized_keys && \
    chmod 600 /home/ckan/.ssh/authorized_keys; \
fi

EXPOSE ${CKAN_PORT} ${SSH_PORT} ${NGINX_PORT}

# Keep container running starts SSHD
CMD ["/usr/sbin/sshd", "-D"]