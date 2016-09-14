# ChangeLog


## Size of the Image 

I have tested base image from Ubuntu or Debian, but know the Ubuntu image is smaller.

## TODOS

//TODO: see what gosu can offers for swithcing user
//TODO: does tidi can be helpful for our development environment (much thant 1 process in the container) 
# grab tini for signal processing and zombie killing
	ENV TINI_VERSION v0.9.0
	RUN set -x \
	    && curl -fSL "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini" -o /usr/local/bin/tini \
	    && curl -fSL "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini.asc" -o /usr/local/bin/tini.asc \
	    && export GNUPGHOME="$(mktemp -d)" \
	    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5 \
	    && gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini \
	    && rm -r "$GNUPGHOME" /usr/local/bin/tini.asc \
	    && chmod +x /usr/local/bin/tini \
	    && tini -h
