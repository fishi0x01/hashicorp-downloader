VAULT_VERSION := 1.9.3
TERRAFORM_VERSION := 1.1.5
VAGRANT_VERSION := 2.2.19
PACKER_VERSION := 1.7.10
CONSUL_VERSION := 1.11.2

SHELL := /bin/sh
OS := $(shell uname | tr '[:upper:]' '[:lower:]')
UNAME_M := $(shell uname -m)
ARCH := $(UNAME_M)
ifeq ($(UNAME_M),x86_64)
	ARCH=amd64
endif
ifneq ($(filter %86,$(UNAME_M)),)
	ARCH=386
endif
ifneq ($(filter arm%,$(UNAME_M)),)
  ARCH=arm
endif
ifneq ($(filter $(UNAME_M),arm64 aarch64 armv8b armv8l),)
	ARCH=arm64
endif

import-hashicorp-asc:
	@gpg --list-keys 72D7468F >/dev/null || gpg --import hashicorp.asc

get-tool: import-hashicorp-asc
	@mkdir -p ./bin
	@cd ./bin && curl -sLO https://releases.hashicorp.com/$(TOOL)/$(TOOL_VERSION)/$(TOOL)_$(TOOL_VERSION)_$(OS)_$(ARCH).zip
	@cd ./bin && curl -sLO https://releases.hashicorp.com/$(TOOL)/$(TOOL_VERSION)/$(TOOL)_$(TOOL_VERSION)_SHA256SUMS
	@cd ./bin && curl -sLO https://releases.hashicorp.com/$(TOOL)/$(TOOL_VERSION)/$(TOOL)_$(TOOL_VERSION)_SHA256SUMS.72D7468F.sig
	@cd ./bin && gpg --verify $(TOOL)_$(TOOL_VERSION)_SHA256SUMS.72D7468F.sig $(TOOL)_$(TOOL_VERSION)_SHA256SUMS
	@cd ./bin && cat $(TOOL)_$(TOOL_VERSION)_SHA256SUMS | grep $(TOOL)_$(TOOL_VERSION)_$(OS)_$(ARCH).zip | sha256sum -c
	@cd ./bin && unzip -u $(TOOL)_$(TOOL_VERSION)_$(OS)_$(ARCH).zip
	@rm ./bin/$(TOOL)_*

get-terraform: TOOL=terraform
get-terraform: TOOL_VERSION=$(TERRAFORM_VERSION)
get-terraform: get-tool

get-vault: TOOL=vault
get-vault: TOOL_VERSION=$(VAULT_VERSION)
get-vault: get-tool

get-vagrant: TOOL=vagrant
get-vagrant: TOOL_VERSION=$(VAGRANT_VERSION)
get-vagrant: get-tool

get-packer: TOOL=packer
get-packer: TOOL_VERSION=$(PACKER_VERSION)
get-packer: get-tool

get-consul: TOOL=consul
get-consul: TOOL_VERSION=$(CONSUL_VERSION)
get-consul: get-tool
