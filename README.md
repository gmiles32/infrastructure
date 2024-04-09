# Infrastructure
This is how I manage my homelab setup with Ansible. This repo is a WIP, but the goal is to have my configuration public in a secure way, taking advantage of secret management with `ansible-vault`.

# Background
I've been running a homelab for a little - nothing crazy, just maybe a dozen containers, plus a TrueNAS VM and recently pfsense. Initially I was sort of willy nilly with how I executed things, not paying much mind to reproducibility and security. So I'd have a lot of trouble trying to redo something that I did a couple months before. Plus, some docker containers don't have great options for secret management - so I had database passwords out in the open! Not great.

Over the past two months, I've made it my goal to improve the reproducibility of my setup, and to improve the security (no more secrets just out in the open!). I started learning about Ansible, and running playbooks. It turned out to be a really convenient way to record the steps needed to configure a VM from the ground up with everything I would normally use. And those Ansible playbooks evolved into this mess you see here.

For those who have been using Ansible, you might be wondering 'hey, why would you write your docker compose files using a template, rather than using the docker compose module?' And that would be a valid question. I considered doing that. But I really like using `docker compose`, it makes it really convenient to start and stop containers. More convenient than writing playbooks for every container. I also just thought that this way was cooler.

# Disclaimer
I am not a professional - in fact I am a chemist by trade. So this is probably not the best set up by any means. Take the parts you like, throw away the parts you don't. If you want to use this repo as a starting point for your homelab, by all means that is why I made it public. But I do not guarantee that this will work for your particular needs.

# Usage
After cloning this repository, make sure to load submodules:

```bash
git submodule update --init --recursive
```

Before doing anything, make sure to set up your own `ansible-vault` with the variables you will need. Set a vault password, and put into a file named `.vault_pass`.

To install all the requirements to run these playbooks, use the following command:

```bash
just reqs
```

This will install the Ansible Galixy modules and roles used.

## Docker
The following services are contained in this repository:
  - postgres
  - authelia
  - traefik
  - portainer
  - immich
  - traefik
  - calibre
  - freshrss
  - homepage
  - omada
  - paperless
  - scrutiny
  - syncthing
  - uptime-kuma
  - vaultwarden
  - vikunja

I won't go through the purpose of each container, please refer to there respective documentation. I have included my "docker-compose.yml" files in the [inventory/service_configs](inventory/service_configs) directory. I have not included any additional configs these services might require, so again please refer the the documentation. 

I've used "docker-compose" in quotes because it's had to be modified a little bit to work with the j2 templating. I am not the originator of this idea, credit goes to [ironicbadger](https://github.com/ironicbadger). I've extended his [original ansible module](https://github.com/IronicBadger/ansible-role-docker-compose-generator) to work with network and volume entries, which I had a lot of in my docker compose. It's very straightforward to convert your docker compose to this pseudo-docker compose format. 

To my standard configuration for a dockerhost, which includes installing commonly used packages, installing pip dependencies for Ansible, installing Docker, configuring `firewalld`, and generating the docker compose, use the following command:

```bash
just configure dockerhost
```

And now your dockerhost should be configured! If you make adjustments to your docker configs, you can regenerate the config using tags:

```bash
just configure dockerhost --tags=compose
```

This skips all the basic configuration, and jumps straight to making compose. You can also do the opposite and just install the basic packages using `just configure dockerhost --tags=basic`.

To start the newly generated docker compose, you can use the following command:

```bash
just serv
```

I have some homelab specific things that I've done, so you will need to write a `homelab_specific.yml` tasks list and put it into the [roles/docker_start/tasks](roles/docker_start/tasks/) directory. I recommend opening up `firewalld` ports in this manner. 

I don't have a playbook for stopping docker containers in a bulk fashion, but this can be accomplished using the command:

```bash
docker stop $(docker ps -a -q)
```

You can write that into a playbook like I have in my [pve reboot playbook](playbooks/pve_reboot.yml), but I tend to just run this on the host itself, or use portainer.

The biggest thing that I will say is that you have to make changes to your configuration _in this repository_. That way all changes are tracked via git and you have a centralized location for everything. Trust me, it will make your life way better. Also, you can do fun things like keep docker containers up to date with renovate - so convenient!

## Other playbooks
I'm continuing to add things as I explore more about Ansible and how I can use it in my homelab. I've make a playbook for configuring ssh keys, you can run this with the command:

```bash
just ssh host
```

I put the ssh keys for my desktop, laptop, and pi into my vault, which makes configuring a new machine very easy.

You can also update your machines (at least ones with `apt` and `yum` package managers) with the following command:

```bash
just update
```

This will update the system, and send you a discord message if you need to reboot a machine. I have it running as a systemd timer that goes off every Sunday to keep things up to date. It makes homelab management much easier. 

# Next steps
I'm always iterating, so this is definitely not the final configuration. I'm on a mission to have consistent configuration on all machines, and to have reproducibility. To me, that means having Ansible for configuring virtual machines, but also Terraform for making those VMs. I've also been playing around with NixOS, which I want to use as my primary operating OS. I just want absolute control over configuration, rahter than hoping for the best whenever I make a new VM or reinstall linux. Or maybe I just get a Mac. Who knows.
