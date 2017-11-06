
NAME=docker-vscode


ifndef ARGS
ARGS="vscode"
endif

#https://github.com/microscaling/microscaling/blob/master/Makefile

fast:
	docker build -t sebmoule/$(NAME) .

#Build with generic user developer inside  the docker
build:
	echo 'This will take a lot of time...'
	docker build --build-arg VCF_REF=${shell git rev-parse --short HEAD} \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` --rm -t sebmoule/$(NAME) \
		.

rerun: 
	docker stop $(NAME) || true
	docker rm $(NAME) || true
	make -s run

run:	
	docker run -dti \
	--net="host" \
	--name=vscode \
	-h vscode \
	-e DISPLAY=${DISPLAY} \
	-e MYUID=${shell id -u} \
	-e MYGID=${shell id -g} \
	-e MYUSERNAME=${shell id -un} \
	-e SSH_AUTH_SOCK=${SSH_AUTH_SOCK} \
	-v ${shell dirname ${SSH_AUTH_SOCK}}:${shell dirname ${SSH_AUTH_SOCK}} \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ${HOME}:${HOME} \
	-w /mnt/filer/work \
	-v /mnt/filer/work:/mnt/filer/work \
	sebmoule/$(NAME) $(ARGS)



#########################
#tests

#Build withlocal user inside the image docker 
build-user:
	echo 'This will take a lot of time...'
	docker build --rm -t sebmoule/$(NAME)-${USER} \
		--build-arg MYUSERNAME=${USER} \
		--build-arg MYUID=${shell id -u} \
		--build-arg MYGID=${shell id -g} \
		.


#Run Container with local user inside
run-user:
	docker run --rm -ti \
	   --net="host" \
           --name=vscode \
           --privileged=true \
	   -h vscode \
           -e DISPLAY=${DISPLAY} \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ${HOME}:${HOME} \
           -v /mnt/filer/work:/mnt/filer/work \
           sebmoule/$(NAME)-${USER} bash




#Install VsCode on local system

install:
	curl -o vscode.deb -J -L https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable
	sudo dpkg -i vscode.deb
	rm -f vscode.deb 

