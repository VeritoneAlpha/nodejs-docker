FROM xpatterns/base:1.0.3

ENV NODE_VERSION v6.3.1
ENV NODE_DOWNLOAD_LINK http://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.gz

ENV USER node

# NodeJS
EXPOSE 8000

# ---- apt-get installs ----
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	wget \
	curl \
	vim	\
	gcc \
	g++ \
	make \
	automake \
	autoconf \
	build-essential \
	python \
	git \
	ruby-full \
	libcurl3-dev && \
	rm -rf /var/lib/apt/lists/*


# ---- Ruby and Compass stuff
RUN gem update && \
	gem install compass

# ---- Install NODEJS and NPM----

RUN wget $NODE_DOWNLOAD_LINK -P /tmp/ && \
	tar -xzf /tmp/node-$NODE_VERSION-linux-x64.tar.gz -C /usr/local/ && \
	update-alternatives --install "/bin/node" "node" "/usr/local/node-$NODE_VERSION-linux-x64/bin/node" 1 && \
	# npm is already installed with node. We just need to make a symlink
	ln -s "/usr/local/node-$NODE_VERSION-linux-x64/bin/npm" "/bin/npm" && \
	# clean up after ourselves
	rm -Rf /tmp/* && \
	# set npm prefix to /usr/local
	# This fixes global installs
	# (symlinked) binaries get placed in /usr/local/bin
	# node_modules folder in /usr/local/lib/node_modules
	npm config set prefix /usr/local && \
	npm install -g grunt-cli \
	bower \
	nodemon \
	jspm \
	node-gyp


# ---- Test that applications are linked properly ----
# ruby apps
RUN compass --version

# node apps
RUN npm --version; bower --version; grunt --version; jspm --version; node-gyp --version;

# ---- Add the user node ----
RUN useradd -m $USER -U
RUN echo $USER:$USER | chpasswd


# ---- Setup the startup script ----
COPY startup.sh /startup.sh

RUN chmod u+x /startup.sh
#CMD ["/startup.sh"]
