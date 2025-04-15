#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting prerequisite installation for Ansible K3s/Rancher control node..."

# --- 1. Update Package List & Install Base Dependencies ---
echo "[TASK 1] Updating apt cache and installing base dependencies..."
sudo apt-get update -y
sudo apt-get install -y curl gnupg apt-transport-https ca-certificates lsb-release software-properties-common python3-pip python3-venv
echo "[TASK 1] Base dependencies installed."

# --- 2. Install Ansible ---
echo "[TASK 2] Installing Ansible..."
# Add Ansible PPA for potentially newer versions
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible-core
echo "[TASK 2] Ansible installed successfully."
ansible --version # Verify installation

# --- 3. Install kubectl ---
echo "[TASK 3] Installing kubectl..."
KUBECTL_LATEST=$(curl -L -s https://dl.k8s.io/release/stable.txt)
echo "  Downloading kubectl version: ${KUBECTL_LATEST}"
curl -LO "https://dl.k8s.io/release/${KUBECTL_LATEST}/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl # Clean up downloaded binary
echo "[TASK 3] kubectl installed successfully."
kubectl version --client # Verify installation

# --- 4. Install Helm ---
echo "[TASK 4] Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
echo "[TASK 4] Helm installed successfully."
helm version # Verify installation

# --- 5. Install Python Kubernetes Library ---
echo "[TASK 5] Installing Python Kubernetes library..."
# Note: Installing system-wide via pip
sudo pip3 install kubernetes
echo "[TASK 5] Python Kubernetes library installed."

# --- 6. Install Ansible Kubernetes Collection ---
echo "[TASK 6] Installing Ansible Kubernetes collection..."
ansible-galaxy collection install kubernetes.core
echo "[TASK 6] Ansible Kubernetes collection installed."

echo "-----------------------------------------------------"
echo "Prerequisite installation completed successfully!"
echo "You should now be able to run the Ansible playbooks."
echo "-----------------------------------------------------"

exit 0
