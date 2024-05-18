#!/usr/bin/env -S just --justfile

reqs *FORCE:
	ansible-galaxy install -r requirements.yml {{FORCE}}

configure HOST TAGS="compose":
    ansible-playbook -b playbooks/configure.yml -e host={{HOST}} --tags={{TAGS}}

serv HOST TAGS="restart":
    ansible-playbook -b playbooks/start_docker.yml -e host={{HOST}} --tags={{ TAGS }}

ssh HOST:
    ansible-playbook -b playbooks/ssh.yml -e host={{HOST}} -k -K

renovate HOST:
    git pull origin main
    ansible-playbook -b playbooks/configure.yml -e host={{HOST}} --tags=compose
    ansible-playbook -b playbooks/start_docker.yml -e host={{HOST}} --tags=restart
  
update:
    ansible-playbook -b playbooks/update.yml

