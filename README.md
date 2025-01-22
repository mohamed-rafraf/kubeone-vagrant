# KubeOne Local Cluster Provisioning

Welcome to the **KubeOne Local Cluster Provisioning** project! This repository contains the necessary manifests and configurations to help you provision a KubeOne-managed Kubernetes cluster locally using virtual machines (VMs) with **libvirt** or **VirtualBox**.

## Features

- **Parametrized Setup:**
  - Define parameters like the number of nodes, IP addresses, Kubernetes version, and more in a single `settings.sh` file.
- **Multiple Providers:**
  - Support for **libvirt** and **VirtualBox** as virtualization backends.
- **Customizable Configurations:**
  - Flexible and easy-to-modify templates for your specific requirements.

## Requirements

### General Prerequisites
- **Vagrant**
- **KubeOne CLI**
- A virtualization provider (either **libvirt** or **VirtualBox**)

### Specific Dependencies
- **libvirt**:
  - Ensure `libvirt` and its development libraries (`libvirt-dev`) are installed.
- **VirtualBox**:
  - Install VirtualBox and its corresponding extensions.

## Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/mohamed-rafraf/kubeone-vagrant.git
cd kubeone-vagrant
```

### 2. Configure Your Cluster
Update the `settings.sh` file with your desired configuration:

```bash
# settings.sh
LIBVIRT_HOST_IP="192.168.56.1" # Network 
CONTROLE_PLANE_IP="192.168.56.4"  # Control Plane IP address
BASE_IP="192.168.56.43" # The First IP in the Range for worker nodes
BASE_MAC="08:00:27:9E:F5:3A" 
WORKERS_NUMBER=3
KUBERNETES_VERSION="1.27.4"
CLUSTER_NAME="kubeone-vagrant"
```

### 3. Bring Up the VMs
Run the following command to provision the virtual machines:
```bash
vagrant up
```

- **For libvirt:** Ensure `vagrant-libvirt` plugin is installed:
  ```bash
  vagrant plugin install vagrant-libvirt
  ```

- **For VirtualBox:** Ensure VirtualBox is installed and set as the default provider.

### 4. Deploy the Cluster
Render Kubeone YAML Manifest
```bash
hack/render-kubeone.sh
```

Use KubeOne to initialize and provision the cluster:
```bash
kubeone apply -m kubeone.yaml
```

### 5. Verify Your Cluster
Once the cluster is up and running, verify it:
```bash
kubectl get nodes
```

## Customization

### Supported Parameters
You can customize the following parameters in `settings.sh`:
- `WORKERS_NUMBER`: Number of worker nodes.
- `CONTROLE_PLANE_IP`: IP address of the control plane node.
- `BASE_IP`: Base IP for worker nodes.
- `KUBERNETES_VERSION`: The desired Kubernetes version.

### Example
To deploy a cluster with:
- 3 worker nodes
- Kubernetes version 1.26.2

Update `settings.sh`:
```bash
WORKERS_NUMBER=3
KUBERNETES_VERSION="1.26.2"
```

Then run:
```bash
vagrant up
```

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve this project.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

Happy provisioning! 🚀

