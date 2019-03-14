/EDITOR=vim

export COMPOSE_PROJECT_NAME=latelier
export PORT=3306
export MARIADB_ROOT_PASSWORD=*PLZ_ch4ng3_M3!
export MARIADB_DATABASE=${COMPOSE_PROJECT_NAME}
export MARIADB_USER=${COMPOSE_PROJECT_NAME}
export MARIADB_PASSWORD=*ch4ng3_M3!

dummy               := $(shell touch artifacts)
include ./artifacts

include /etc/os-release

install-prerequisites:
ifeq ("$(wildcard /usr/bin/docker)","")
        @echo install docker-ce, still to be tested
        sudo apt-get update
        sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

        curl -fsSL https://download.docker.com/linux/${ID}/gpg | sudo apt-key add -
        sudo add-apt-repository \
                "deb https://download.docker.com/linux/ubuntu \
                `lsb_release -cs` \
                stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce
        sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
endif

network: 
	@docker network create ${COMPOSE_PROJECT_NAME} 2> /dev/null; true

clean: down
	sudo rm -rf  data/ && sudo mkdir -p data/etc data/mysql data/local 

build:
	docker build --build-arg proxy=${http_proxy} -t vertica .

up: network
	docker-compose up -d

down:
	docker-compose down
log:
	docker-compose logs -f 

restart: down up

