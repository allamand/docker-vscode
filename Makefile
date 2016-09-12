

ifndef ARGS
ARGS="vscode"
endif

#https://github.com/microscaling/microscaling/blob/master/Makefile


#Build with generic user developer inside  the docker
build:
	echo 'This will take a lot of time...'
	docker build --rm -t sebmoule/vscode \
		.

rerun: 
	docker stop vscode || true
	docker rm vscode || true
	make -s run

run:	
	docker run -ti \
	--net="host" \
	--name=vscode \
	-u root \
	-h vscode \
	-e DISPLAY=${DISPLAY} \
	-e MYUID=${shell id -u} \
	-e MYGID=${shell id -g} \
	-e MYUSERNAME=${shell id -un} \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ${HOME}:${HOME} \
	-v /mnt/filer/work:/mnt/filer/work \
	sebmoule/vscode $(ARGS)




#########################
#tests

#Build withlocal user inside the image docker 
build-user:
	echo 'This will take a lot of time...'
	docker build --rm -t sebmoule/vscode-${USER} \
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
           sebmoule/vscode-${USER} bash





