FROM quay.io/yeebase/debian-base:stretch

ENV PHP_VERSION 7.2
ENV NODEJS_VERSION 10
ENV DOCKER_COMPOSE_VERSION 1.21.2

RUN set -x && \
    # install fetch and build packages
    clean-install apt-transport-https lsb-release ca-certificates curl gnupg2 \
      software-properties-common && \
    # php repo
    curl -sL https://packages.sury.org/php/apt.gpg -o /etc/apt/trusted.gpg.d/php.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    # docker repo
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
      "deb https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    # nodejs repo
    curl -fsSL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash - && \
    # yarn repo
    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    add-apt-repository \
      "deb https://dl.yarnpkg.com/debian/ stable main" && \
    # install packages
    clean-install \
      git ssh locales zip bzip2 sqlite unzip \
      php${PHP_VERSION}-common \
      php${PHP_VERSION}-cli \
      php${PHP_VERSION}-sqlite3 \
      php${PHP_VERSION}-xml \
      nodejs yarn docker-ce && \
    sed -i '/de_DE/s/^# //g' /etc/locale.gen && \
    ln -s /etc/locale.alias /usr/share/locale/locale.alias && \
    locale-gen && \
    npm install --global gulp-cli && \
    # install composer
    curl -fsSL https://getcomposer.org/composer.phar -o /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    # install docker-compose
    curl -fsSL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

ENV LANG=de_DE.UTF-8
ENV LANGUAGE=de_DE.UTF-8
ENV LC_ALL=de_DE.UTF-8
