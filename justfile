#!/usr/bin/env -S just --justfile

reqs *FORCE:
	ansible-galaxy install -r requirements.yml {{FORCE}}

configure HOST *TAGS:
    ansible-playbook -b playbooks/configure.yml -e host={{HOST}} {{TAGS}}

serv HOST:
    ansible-playbook -b playbooks/start_docker.yml -e host={{HOST}}

ssh HOST:
    ansible-playbook -b playbooks/ssh.yml -e host={{HOST}}

update:
    ansible-playbook -b playbooks/update.yml