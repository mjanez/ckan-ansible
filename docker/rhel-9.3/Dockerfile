FROM registry.access.redhat.com/ubi9/ubi:9.3
LABEL maintainer="mjanez" \
      name="ckan-ansible" \
      version="rhel-9.3"

# Set up environment variables
ENV ANSIBLE_DIR=/opt

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
    # Create user_ckan with sudo access
    useradd -m user_ckan && \
    echo "user_ckan ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user_ckan && \
    chmod 0440 /etc/sudoers.d/user_ckan

# SSH setup
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    chown root:root /root/.ssh && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    chmod o-rwx /root/.ssh

# Copy the public key
COPY docker/ssh/keys/ssh.pub /root/.ssh/authorized_keys

RUN chown root:root /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

# Switch to user_ckan
USER user_ckan

EXPOSE 80 22

# Keep container running
CMD tail -f /dev/null
