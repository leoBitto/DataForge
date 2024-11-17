# DataForge Installation Guide

[Back to index]({{ site.baseurl }})

## Development Environment Setup

This guide outlines the steps to set up a local development environment for DataForge using MicroK8s on a Windows machine with WSL2.

### Prerequisites

1. **Windows OS** with [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install) installed.
2. A **Linux distribution** installed on WSL2 (e.g., Ubuntu 22.04).
3. Administrator privileges to enable necessary Windows features and install required tools.
4. Internet access to download and install dependencies.

---

### Step 1: Install MicroK8s on WSL2

1. Open your WSL2 terminal (e.g., Ubuntu).
2. Update the package list and install the necessary dependencies:
   ```bash
   sudo apt update
   sudo apt install -y snapd
   sudo snap install core
   sudo snap refresh
   ```
3. Install MicroK8s:
   ```bash
   sudo snap install microk8s --classic
   ```
4. Add your user to the `microk8s` group to avoid using `sudo`:
   ```bash
   sudo usermod -aG microk8s $USER
   sudo chown -R $USER ~/.kube
   ```
5. Restart your terminal or run:
   ```bash
   newgrp microk8s
   ```

---

### Step 2: Enable Required MicroK8s Add-ons

Activate essential add-ons:
```bash
microk8s enable dns 
microk8s enable helm3 
microk8s enable hostpath-storage
```

---

### Step 3: Verify MicroK8s Installation

Check the status of MicroK8s:
```bash
microk8s status --wait-ready
```
Ensure the output indicates that all services are running.

---

### Step 4: Install Helm

1. Download the Helm binary:
   ```bash
   curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
   ```
2. Verify Helm installation:
   ```bash
   helm version
   ```

---

### Step 5: Clone the DataForge Repository

Navigate to your project directory and clone the repository:
```bash
git clone https://github.com/leoBitto/DataForge.git
cd DataForge
```

---

### Step 6: Deploy DataForge (Development Environment)

1. Run the setup script to deploy the environment:
   ```bash
   chmod +x start.sh
   ./start.sh
   ```
2. Check the status of the pods:
   ```bash
   microk8s kubectl get pods -n dataforge-test
   ```
   All pods should show a `Running` status.

3. Access the Django application in your browser at [http://localhost](http://localhost).

---

### Step 7: Troubleshooting

1. Check MicroK8s logs:
   ```bash
   microk8s kubectl logs <pod-name> -n dataforge-test
   ```
2. Verify Kubernetes services:
   ```bash
   microk8s kubectl get services -n dataforge-test
   ```
3. Restart MicroK8s if necessary:
   ```bash
   microk8s stop
   microk8s start
   ```

---
