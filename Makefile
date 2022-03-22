IP=192.168.100.2

ifeq ($(origin CI_REGISTRY_IMAGE),undefined)
CI_REGISTRY_IMAGE := freeswitch-mini
endif

IMG_VER=$(shell grep "ARG CONT_IMG_VER" Dockerfile | awk -F'[ =]' '{print $$3}')
IMG_VER_SSH=$(shell grep "ARG CONT_IMG_VER" Dockerfile.ssh | awk -F'[ =]' '{print $$3}')


fs_cli:
	docker-compose exec freeswitch-mini	fs_cli

invite:
	docker-compose exec freeswitch-mini fs_cli -x "originate user/101@${IP} 'playback:background.wav,hangup' inline"

build:
	docker build -t ${CI_REGISTRY_IMAGE}:${IMG_VER} .
