/*
Title: Ubuntu VM Configuration
Description: Defines an Ubuntu virtual machine using libvirt.
*/
{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.ubuntu-vm.enable {
  # Ensure virtualization is enabled
  virtualization.enable = true;

  # Create a systemd service to manage the Ubuntu VM
  systemd.services.ubuntu-vm = {
    description = "Ubuntu Virtual Machine";
    after = ["libvirtd.service"];
    requires = ["libvirtd.service"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
    };

    # Script to ensure VM exists and start it
    script = ''
      # Wait for libvirtd to be ready
      sleep 5

      # Check if VM exists
      if ! ${pkgs.libvirt}/bin/virsh list --all | grep -q "ubuntu-vm"; then
        echo "Ubuntu VM not found. Please create it manually using virt-manager or virt-install."
        echo "Example command:"
        echo "virt-install --name ubuntu-vm --memory 4096 --vcpus 2 --disk size=50 --cdrom /path/to/ubuntu.iso --os-variant ubuntu24.04 --network network=default --graphics spice"
      else
        # Start VM if not running
        if ! ${pkgs.libvirt}/bin/virsh list --state-running | grep -q "ubuntu-vm"; then
          ${pkgs.libvirt}/bin/virsh start ubuntu-vm
        fi
      fi
    '';

    preStop = ''
      # Gracefully shutdown VM
      if ${pkgs.libvirt}/bin/virsh list --state-running | grep -q "ubuntu-vm"; then
        ${pkgs.libvirt}/bin/virsh shutdown ubuntu-vm
        # Wait up to 60 seconds for shutdown
        for i in {1..60}; do
          if ! ${pkgs.libvirt}/bin/virsh list --state-running | grep -q "ubuntu-vm"; then
            break
          fi
          sleep 1
        done
      fi
    '';
  };

  # Create a helper script for VM management
  environment.systemPackages = [
    (pkgs.writeScriptBin "ubuntu-vm-create" ''
      #!${pkgs.bash}/bin/bash

      # Default values
      NAME="ubuntu-vm"
      MEMORY=4096
      VCPUS=2
      DISK_SIZE=50
      ISO_PATH=""

      # Parse arguments
      while [[ $# -gt 0 ]]; do
        case $1 in
          --iso)
            ISO_PATH="$2"
            shift 2
            ;;
          --memory)
            MEMORY="$2"
            shift 2
            ;;
          --vcpus)
            VCPUS="$2"
            shift 2
            ;;
          --disk)
            DISK_SIZE="$2"
            shift 2
            ;;
          --help)
            echo "Usage: ubuntu-vm-create --iso <path> [--memory <MB>] [--vcpus <num>] [--disk <GB>]"
            exit 0
            ;;
          *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
        esac
      done

      if [ -z "$ISO_PATH" ]; then
        echo "Error: ISO path is required. Use --iso <path>"
        exit 1
      fi

      if [ ! -f "$ISO_PATH" ]; then
        echo "Error: ISO file not found at $ISO_PATH"
        exit 1
      fi

      echo "Creating Ubuntu VM with:"
      echo "  Memory: $MEMORY MB"
      echo "  vCPUs: $VCPUS"
      echo "  Disk: $DISK_SIZE GB"
      echo "  ISO: $ISO_PATH"

      ${pkgs.virt-manager}/bin/virt-install \
        --name "$NAME" \
        --memory "$MEMORY" \
        --vcpus "$VCPUS" \
        --disk size="$DISK_SIZE" \
        --cdrom "$ISO_PATH" \
        --os-variant ubuntu24.04 \
        --network network=default \
        --graphics spice \
        --video qxl \
        --channel spicevmc \
        --console pty,target_type=serial
    '')
  ];
}
