# Using SSH Keys

SSH keys are a form of identification that the Secure Shell (SSH) protocol uses to securely connect to remote servers. Here's how to use SSH keys.

## Generating SSH Keys

1. Open a terminal.

2. Run the following command to generate a new SSH key:

    ```bash
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```

Replace "your_email@example.com" with your email address.

3. When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location.

4. At the prompt, type a secure passphrase.

## Adding Your SSH Key to the ssh-agent
1. Start the ssh-agent in the background:

   ```bash
   eval "$(ssh-agent -s)"
   ```	

2. Add your SSH private key to the ssh-agent:

   ```bash
   ssh-add ~/.ssh/id_rsa
   ```

## Adding Your SSH Key to Your Account on the Server
1. Copy your SSH public key to your clipboard:

    ```bash
    clip < ~/.ssh/id_rsa.pub
    ```

On Linux, you can use xclip:

    ```bash
    xclip -sel clip < ~/.ssh/id_rsa.pub
    ```

2. On the server you want to connect to, open the `~/.ssh/authorized_keys` file in a text editor and paste your public key on a new line.

## Connecting to the Server
You can now connect to the server with:

    ```bash
    ssh user@hostname
    ```

Replace `user` with your username on the server and `hostname` with the hostname of the server. Because you've added your SSH key to the ssh-agent, you shouldn't have to enter your passphrase every time you connect.
