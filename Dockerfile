FROM ubuntu:16.04

MAINTAINER Sebastien Allamand "sebastien@allamand.com"

ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

ARG MYUSERNAME=developer
ARG MYUID=1000
ARG MYGID=100
ENV MYUSERNAME=${MYUSERNAME} \
    MYUID=${MYUID} \
    MYGID=${MYGID} 


RUN apt-get update -qq && \
    echo 'Installing OS dependencies' && \
    apt-get install -qq -y --fix-missing \ 
      sudo software-properties-common libxext-dev libxrender-dev libxslt1.1 \
      libgconf-2-4 libnotify4 libnspr4 libnss3 libnss3-nssdb \
      libxtst-dev libgtk2.0-0 libcanberra-gtk-module \
      git curl \
      emacs ruby \
    && \
    echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \


    echo 'Creating user: ${MYUSERNAME} wit UID $UID' && \
    mkdir -p /home/${MYUSERNAME} && \
    echo "${MYUSERNAME}:x:${MYUID}:${MYGID}:Developer,,,:/home/${MYUSERNAME}:/bin/bash" >> /etc/passwd && \
    echo "${MYUSERNAME}:x:${MYGID}:" >> /etc/group && \
    sudo echo "${MYUSERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${MYUSERNAME} && \
    sudo chmod 0440 /etc/sudoers.d/${MYUSERNAME} && \
    sudo chown ${MYUSERNAME}:${MYUSERNAME} -R /home/${MYUSERNAME} && \
    sudo chown root:root /usr/bin/sudo && \
    chmod 4755 /usr/bin/sudo && \


    echo 'Downloading Go 1.6.3' && \
    curl -o /tmp/go.tar.gz -J -L 'https://storage.googleapis.com/golang/go1.6.3.linux-amd64.tar.gz' && \
    echo 'Installing Go 1.6.3' && \
    sudo tar -zxf /tmp/go.tar.gz -C /usr/local/ && \
    rm -f /tmp/go.tar.gz && \

    echo 'Installing VsCode' && \
    curl -o vscode.deb -J -L 'http://go.microsoft.com/fwlink/?LinkID=760868' && \
    dpkg -i vscode.deb && rm -f vscode.deb && \


    echo 'Installing Cloud Foundry Client' && \
    curl -o cf_cli.deb -J -L 'https://cli.run.pivotal.io/stable?release=debian64&source=github' && \
    dpkg -i cf_cli.deb  && rm cf_cli.deb && \
    sudo gem install cf_completion && \
    echo "complete -C cf_completion cf" >> ~/.bash_profile 



#USER ${MYUSERNAME}
ENV HOME /home/${MYUSERNAME}
ENV GOPATH /home/${MYUSERNAME}/go
ENV PATH $PATH:/home/${MYUSERNAME}/go/bin:/usr/local/go/bin
WORKDIR /home/${MYUSERNAME}/go

ADD ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["vscode"]
