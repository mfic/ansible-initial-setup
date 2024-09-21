#!/bin/bash

# Step 1: Install Git
echo "Installing Git..."
if ! command -v git &>/dev/null; then
  if [ -x "$(command -v apt)" ]; then
    sudo apt update
    sudo apt install -y git
  elif [ -x "$(command -v yum)" ]; then
    sudo yum install -y git
  elif [ -x "$(command -v dnf)" ]; then
    sudo dnf install -y git
  elif [ -x "$(command -v brew)" ]; then
    brew install git
  else
    echo "Error: Could not find a supported package manager to install Git."
    exit 1
  fi
else
  echo "Git is already installed."
fi

# Step 2: Install pipx if not installed
echo "Installing pipx..."
if ! command -v pipx &>/dev/null; then
  # Ensure that pip is installed
  if ! command -v pip3 &>/dev/null; then
    echo "Installing pip3..."
    if [ -x "$(command -v apt)" ]; then
      sudo apt update
      sudo apt install -y python3-pip
    elif [ -x "$(command -v yum)" ]; then
      sudo yum install -y python3-pip
    elif [ -x "$(command -v dnf)" ]; then
      sudo dnf install -y python3-pip
    elif [ -x "$(command -v brew)" ]; then
      brew install python3
    else
      echo "Error: Could not find a supported package manager to install pip3."
      exit 1
    fi
  fi

  # Install pipx using pip3
  python3 -m pip install --user pipx
  python3 -m pipx ensurepath

  # Reload shell to make pipx available in the current session
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "pipx is already installed."
fi

# Step 3: Install Ansible using pipx
echo "Installing Ansible with pipx..."
if ! command -v ansible &>/dev/null; then
  pipx install ansible
else
  echo "Ansible is already installed."
fi

# Step 4: Clone Ansible Setup Repository
ANSIBLE_REPO_URL="https://github.com/your-username/ansible-setup-repo.git"  # Replace with your repository URL
CLONE_DIR="$HOME/ansible-setup"

echo "Cloning Ansible setup repository..."
if [ ! -d "$CLONE_DIR" ]; then
  git clone "$ANSIBLE_REPO_URL" "$CLONE_DIR"
else
  echo "Repository already cloned."
fi

# Step 5: Run Ansible Playbook on localhost
echo "Running Ansible playbook..."
cd "$CLONE_DIR" || exit
ansible-playbook -i localhost, playbook.yml --connection=local

echo "Ansible setup completed."
