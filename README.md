# Docker image for VsCode, Go and Go plugin

The Goal of this image is to have a portable development environment.
We ship this image with at least some of common dev tools I used
The image contains the following software:


- [Visual Studio Code](https://code.visualstudio.com/) [140 Mo ]
- [Go 1.6.3](https://golang.org/) [ 320Mo ]
- git 2.7.4
- Emacs 24.5.1 + ruby 2.3.1 [ 189Mo ]
- Cloud Foundry Client 6.12 [25Mo]

## Managing User

The best way to work with this tool is to bind-mount you $HOME inside the container so that you will be 
able to work on you file.
I prefer not to work as root inside the container, so i will create you user inside the container at startup.
You'll have to pass env variables `MYUSERNAME`, `MYUID` and `MYGID` so that when you edit files inside the container you'll have the sames rights as outside.


## Building

By default the build of the image will be made with a generic user inside.
  - `make build`

## Running

There are 2 run Options :

Running the container with user's specified inside :
  - `make run`

which runs :
By running the following command you'll be able to start the container

```bash
docker run -ti \
  --net="host" \
  --name=vscode \
  -u root \
  -h vscode \
  -e DISPLAY=$(DISPLAY) \
  -e MYUID=$(shell id -u) \
  -e MYGID=$(shell id -g) \
  -e MYUSERNAME=$(shell id -un) \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $(HOME):$(HOME) \
  sebmoule/vscode
```
### Entrypoint

The entrypoint will create your user inside the container if you have passed the according Environment variables.
It will also install some of tools for developping in `Golang`

The command will do the following:

- Create the user according to `MYUID` `MYGID` and `MYUSERNAME`
- save the IDE preferences into `<your-HOME-dir>/.vscode`
- mounts the `GOPATH` from your computer to the one in the container. This
assumes you have a single directory. If you have multiple directories in your
GOPATH, then see below how you can customize this to run correctly.

When bind-mounting you Home into the Container it will execture your `.bashrc` inside the container.

## Customizing the container

You can replace the `$(GOPATH)` environment variable to a hardcoded path that
you have in your directory.

You can also choose to save the preferences in another directory.



### OLD Way
>If you plan too bind-mount you Home inside the Container to have a fill Dockerized Development Environment you may choose to create the user inside the container sith your name and uid so that you can edit all files :
>  - `make build-user`

