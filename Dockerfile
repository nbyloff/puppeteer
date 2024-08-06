# Set master image
# FROM --platform=linux/amd64 php:8.2-fpm
FROM php:8.2-fpm

ARG UID


# Set the SHELL to bash with pipefail option
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN useradd -u $UID -g www-data -m web -d /home/web \
    && mkdir /home/web/.nvm
COPY --chown=web:www-data config/package.json /home/web/package.json

# Configure default locale (important for chrome-headless-shell).
ENV LANG=en_US.UTF-8
ENV NODE_VERSION=20.16.0
ENV NVM_DIR=/home/web/.nvm
ENV PATH="${NVM_DIR}/versions/node/v${NODE_VERSION}/bin/:${PATH}"

RUN apt-get update \
    && apt-get install -y curl wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg \
    && sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] https://dl-ssl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-khmeros fonts-kacst fonts-freefont-ttf libxss1 dbus dbus-x11 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

USER web
WORKDIR /home/web

ENV DBUS_SESSION_BUS_ADDRESS=autolaunch:

# Install @puppeteer/browsers, puppeteer and puppeteer-core into /home/web/node_modules.
RUN echo 'export NVM_DIR="$HOME/.nvm"'                                       >> "$HOME/.bashrc" \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$HOME/.bashrc" \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> "$HOME/.bashrc" \
    && . $HOME/.nvm/nvm.sh \
    && . $HOME/.bashrc \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && cd /home/web \
    && node --version \
    && npm --version \
    && npm install puppeteer@^22


# set command to run puppeteer script
CMD ["node", "demo.js"]
#CMD ["php-fpm"]