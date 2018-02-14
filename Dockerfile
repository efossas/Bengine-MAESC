FROM alpine
MAINTAINER Academic Systems

# update, upgrade, & install packages

RUN apk update && apk upgrade
RUN apk add coreutils git nodejs-npm openssl wget yarn

# install node and npm

RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | ash
RUN export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && nvm install node; exit 0

# configure bengine

RUN git clone https://github.com/academicsystems/Bengine /var/www
RUN cd /var/www && chmod 744 ./scripts/*.sh && chmod 744 ./tools/*.sh && npm install

# add files for running container

COPY assets/ssldomain /var/ssldomain
COPY assets/load /bin/load
RUN chmod 550 /bin/load

# this conf must be provided by the person building the image
COPY assets/config.json /var/www/config.json

CMD ["load"]
