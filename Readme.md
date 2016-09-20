# Go Dev Environment with VsCode

The Goal of this image is to have a portable development environment.
We ship this image with at least some of common dev tools I used
The image contains the following software:


- [Visual Studio Code](https://code.visualstudio.com/) [ 140 Mo ]
- [Go 1.6.3](https://golang.org/) [ 320Mo ]
- [git]() 2.7.4
- [Emacs]() 24.5.1 + ruby 2.3.1 [ 189Mo ]
- Cloud Foundry Client 6.12 [25Mo]

[![](https://images.microbadger.com/badges/version/sebmoule/docker-vscode.svg)](http://microbadger.com/images/sebmoule/docker-vscode "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/sebmoule/docker-vscode.svg)](http://microbadger.com/images/sebmoule/docker-vscode "Get your own image badge on microbadger.com")

[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://hub.docker.com/r/sebmoule/docker-vscode/)
[![Docker Pulls](https://img.shields.io/docker/pulls/sebmoule/docker-vscode.svg?maxAge=2592000)]()
[![Docker Stars](https://img.shields.io/docker/stars/sebmoule/docker-vscode.svg?maxAge=2592000)]()


## Managing User

The best way to work with this tool is to bind-mount you $HOME inside the container so that you will be 
able to work on you file.
I prefer not to work as root inside the container, so I will create you user inside the container at startup.
You'll have to pass env variables `MYUSERNAME`, `MYUID` and `MYGID` so that when you edit files inside the container you'll have the sames rights as outside.

## Get Image

Simply pull image from docker Hub
```
docker pull sebmoule/docker-vscode
```

Or build from source 
```
make build
```

## Running

There are 2 run Options :

Running the container with user's specified inside :
  - `make run`

which runs :
By running the following command you'll be able to start the container.
I've added it to my bash aliases

```bash
alias vscode='docker rm vscode || true ; docker run -dti \
  docker run -dti \
    --net="host" \
    --name=vscode \
    -h vscode \
    -e DISPLAY=$DISPLAY \
    -e MYUID=$(id -u) \
    -e MYGID=$(id -g) \
    -e MYUSERNAME=$(id -un) \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME:$HOME \
    -w $HOME \
    sebmoule/docker-vscode'
```

>with this alias, I remove and Recreate my container If not running.
>If my container vscode is already running, then it won't delete it neither create another one.
>I can just enter the container and start working.



Explain Parameters :

- Make Graphical application Works : share DISPLAY, X11 socket en local network
  - `--net="host"` 
  - `-e $DISPLAY`
  - `-v /tmp/.X11-unix:/tmp/.X11-unix`
- Gives Home access and Create your own user inside the container :
  - `-e MYUID=$(id -u)` create user with your UID
  - `-e MYGID=$(id -g)` create group with your GID
  - `-e MYUSERNAME=$(id -un)` create user with you username
  - `-v ${HOME}:${HOME}` We bind-mount our `HOME` so that we can works with our files and access at least to :
    - `~/.bashrc ~/.Xauthority ~/.local/ .ssh ~/.gconf ~/.npm ~/.config/Code ~/.vscode` ...
    - If you do so and bind-mount your home, your .bashrc Profile **MUST** set `GOPATH` and `PATH` so that it can resolve on `/usr/local/go/bin`.	
    - that also mount the vscode preference directories `.config` and `.vscode`
  - `-w $HOME` set working directory to $HOME or whatever you like (your $GOPATH..)
- Gives access to your SSH-Agent (for ssh keys to connect to servers, git...)
  - `-e SSH_AUTH_SOCK=$SSH_AUTH_SOCK`
  - `-v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK)`



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

### Configuring .bashrc

This Tool when bind-mounting your $HOME inside the container will  source your `HOME/.bashrc` file.
To work properly this file must at least contains :

```bash
...
#Add my PATH                                                                                                                                                                   
export GOPATH=~/go                                                                                                                                                             
PATH=$PATH:~/bin:~/.local/bin/:$GOPATH/bin/:/usr/local/go/bin/ 
...
```

In order to know when I work inside the container or on my box, I have differentiate my bash Prompt with different colors :

```bash
       # If we have MYUSERNAME we are in Docker                                                                                                                               
        if [ -z "$MYUSERNAME" ]; then                                                                                                                                          
            #I am on my box                                                                                                                                                    
            PS1="[\[\033[31m\]\u\[\033[00m\]@\[\033[35m\]\h\[\033[00m\]: \[\033[34m\]\w\[\033[00m\]]\[\033[00m\]$"                                                             
        else                                                                                                                                                                   
            #I am in the container                                                                                                                                             
            PS1="[\[\033[34m\]\u\[\033[00m\]@\[\033[32m\]\h-in-docker\[\033[00m\]: \[\033[35m\]\w\[\033[00m\]]\[\033[00m\]$"                                                   
        fi  
```


# Demo


![demo](https://github.com/sebmoule/docker-vscode/raw/master/demo.gif)
<!-- 
![demo](demo.gif)
[![asciicast](https://asciinema.org/a/86284.png)](https://asciinema.org/a/86284) 
-->

