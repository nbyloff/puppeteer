# Set master image
FROM php:8.2-fpm

ARG UID

RUN useradd -u $UID -g www-data -m web -d /home/web \
    && mkdir /home/web/.nvm

COPY --chown=web:www-data ./config/package.json /home/web/package.json

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV NODE_VERSION=20.16.0
ENV NVM_DIR=/home/web/.nvm
ENV PATH="${NVM_DIR}/versions/node/v${NODE_VERSION}/bin/:${PATH}"

RUN apt-get update \
    && apt-get install -y curl chromium \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION} \
    && . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION} \
    && . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION} \
    && cd /home/web \
    && npm install

USER web
WORKDIR /home/web

# set command to run puppeteer script
CMD ["node", "demo.js"]