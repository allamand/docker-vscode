#!/usr/bin/env bash

function delayedPluginInstall {
#source : https://github.com/Microsoft/vscode-go
    echo "Install more powerful linter to check code" 
    go get -u github.com/alecthomas/gometalinter      
    gometalinter --install			      
    echo "For debugging we need to install delve"     
    go get github.com/derekparker/delve/cmd/dlv	      
    echo "Install go Helpers for VsCode"	      
    go get -u -v github.com/nsf/gocode		      
    go get -u -v github.com/rogpeppe/godef	       
    go get -u -v github.com/golang/lint/golint	       
    go get -u -v github.com/lukehoban/go-outline       
    go get -u -v sourcegraph.com/sqs/goreturns	       
    go get -u -v golang.org/x/tools/cmd/gorename       
    go get -u -v github.com/tpng/gopkgs		       
    go get -u -v github.com/newhook/go-symbols	   
    go get -u -v golang.org/x/tools/cmd/guru		

}


echo "You are connecting with User ${MYUSERNAME}"

ID=$(id -u)
if [ "$ID" -eq "0" ] && [ $MYUID != "" ]; then
    echo "Creating user $MYUSERNAME"
    useradd --uid $MYUID --gid $MYGID -s /bin/bash --home /home/$MYUSERNAME $MYUSERNAME
fi

if [ "$1" == "vscode" ]; then

    if [ ! -d /home/${MYUSERNAME}/go/src/github.com/alecthomas/gometalinter ]; then
	# We are running a fresh install we install some plugons
	delayedPluginInstall
    fi
    
    echo "Starting vscode $1, code"
    if [ $ID = 0 ];then
	su $MYUSERNAME -c "source /home/$MYUSERNAME/.bashrc && code"
	exec su $MYUSERNAME
    fi
else
    echo "Starting your overrided command : $1: exec $@"
    exec $@
fi

echo "end of script"

exit 0
