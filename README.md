# Warpgate Openstack

This repository showcase how to deploy a **Warpgate** service on Openstack using Terraform. Warpgate is a reverse proxy service that allows you to access your internal services from anywhere.

It uses [Caddy](https://caddyserver.com/) as the reverse proxy server and the [Openstack-VM module](github.com/GridexX/openstack-vm-module) to provision the VM.

## Requirements

- Cloudflare account
- Openstack cluster
- Terraform CLI

## Installation and usage

Clone the repository and navigate to the `terraform` directory. Edit the `variables.tf` file to match your environment.
Here are the commands to run:

```bash
git clone https://github.com/GridexX/warpgate-openstack
cd ./warpgate-openstack/terraform

# Edit the variables in the `variables.tf` file
terraform init
terraform plan
terraform apply
```

You should retrieve as output some information about the provisioned VM.

```bash
instance_id = "openstack_compute_instance_v2.instance.id"
  Description: The ID of the instance

instance_name = "openstack_compute_instance_v2.instance.name"
  Description: The name of the instance

instance_ip = "openstack_compute_instance_v2.instance.access_ip_v4"
  Description: The IP address of the instance

instance_floating_ip = "openstack_networking_floatingip_v2.floating_ip.address"
  Description: The floating IP address of the instance

instance_connection = "ssh -i ${var.public_key_pair_path} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.ssh_user}@${openstack_networking_floatingip_v2.floating_ip.address}"
  Description: Command to connect to the instance
```

> [!TIP]
> Save the `instance_connection` output to connect to the provisioned VM later.

## Configuration

### Create the DNS records

Once the VM is provisioned, you need to configure the `docker-compose.yml` file with the Warpgate Domain name

First, retrieve the floating IP address with the following command:

```bash
terraform output -json | jq '.instance_fip_address.value' | sed -e 's/"//g'
```

**Then add a DNS A record to your domain with the floating IP address.**

### Configure the Warpgate service

First, we need to setup the Warpgate service. Connect to the provisioned VM with the command printed previously. 
It will asks to choose an admin password and for some optional information.
We will do the setup manually, by running the following commands:

```bash:
# Then run the setup manually:
cd ~/compose-warpgate/
docker run --rm -it -v ./data:/data ghcr.io/warp-tech/warpgate setup
```

Go back to the directory where the `docker-compose.yml` file is located, edit the file and replace the `WARPGATE_DOMAIN` environment variable with your domain name.

Then push the `docker-compose.yml` file to the VM and start the Warpgate service.

```bash
scp -i <public_key_pair_path> docker-compose.yml <ssh_user>@<floating_ip>:~/compose-warpgate
```

> [!NOTE]
> Replace the `<public_key_pair_path>`, `<ssh_user>`, and `<floating_ip>` with the appropriate values.

## Start the stack

Finally launch the containers with the following command:

```bash
ssh -i <public_key_pair_path> <ssh_user>@<floating_ip> "cd ~/compose-warpgate && docker-compose up -d"
```

## License

This module is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more information.

## Authors

This module is maintained by [GridexX](https://github.com/GridexX).
