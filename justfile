#!/usr/bin/env -S just --justfile

reqs *FORCE:
	ansible-galaxy install -r requirements.yml {{FORCE}}

configure HOST *TAGS:
    ansible-playbook -b playbooks/configure.yml -e host={{HOST}} --tags {{TAGS}}