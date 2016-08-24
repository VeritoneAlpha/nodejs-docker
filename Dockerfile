FROM xpatterns/base:1.0.2d

ENV NODE_VERSION v6.3.1
ENV NODE_DOWNLOAD_LINK http://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.gz

ENV USER node

# NodeJS
EXPOSE 8000


# ---- apt-get installs ----
RUN apt-get update && apt-get install -y --fix-missing\
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
	libcurl3-dev


# ---- Install NODEJS ----
RUN wget $NODE_DOWNLOAD_LINK -P /tmp/
RUN tar -xzf /tmp/node-$NODE_VERSION-linux-x64.tar.gz -C /usr/local/
RUN update-alternatives --install "/bin/node" "node" "/usr/local/node-$NODE_VERSION-linux-x64/bin/node" 1


# ---- Install NPM ----
# npm is already installed with node. We just need to make a symlink
RUN ln -s "/usr/local/node-$NODE_VERSION-linux-x64/bin/npm" "/bin/npm"

#clean up after ourselves
RUN rm -Rf /tmp/*

RUN gem update && \
	gem install compass

RUN npm install -g grunt-cli && \
	npm install -g bower && \
	npm install -g nodemon && \
    npm install -g jspm

# Test config
RUN npm install -g node-gyp


# ---- Add the user node ----
RUN useradd -m $USER -U
RUN echo $USER:$USER | chpasswd


# ---- Setup the startup script ----
COPY startup.sh /startup.sh


RUN chmod u+x /startup.sh
CMD ["/startup.sh"]
