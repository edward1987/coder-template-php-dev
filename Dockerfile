FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=coder
ARG WORKDIR=/home/coder/www

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Instalare dependențe de bază și PPA pentru PHP 8.3
RUN apt-get update && apt-get install -y \
    software-properties-common gnupg curl zip unzip git supervisor \
    apache2 mariadb-client lsb-release ca-certificates debconf-utils && \
    echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections && \
    echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections && \
    apt-get install -y phpmyadmin && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get install -y \
    php8.3 php8.3-fpm php8.3-cli php8.3-mysql php8.3-mbstring dos2unix \
    php8.3-xml php8.3-curl php8.3-zip php8.3-bcmath php8.3-gd   \
    php8.3-soap php8.3-intl php8.3-readline php8.3-opcache libapache2-mod-php8.3 && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalare sudo (dacă nu e deja instalat)
RUN apt-get update && apt-get install -y sudo







# Copiere fișiere de configurare (trebuie să existe în contextul build-ului)
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY php.ini /etc/php/8.3/fpm/conf.d/99-custom.ini
COPY php.ini /etc/php/8.3/apache2/conf.d/99-custom.ini
COPY start.sh /usr/local/bin/start.sh
COPY apache-site.conf /etc/apache2/sites-available/000-default.conf

RUN chmod +x /usr/local/bin/start.sh
RUN dos2unix /usr/local/bin/start.sh
# Creare utilizator și director de lucru
# Creează utilizatorul și directoarele necesare
RUN useradd -m -s /bin/bash $USER && \
    mkdir -p /home/$USER/logs $WORKDIR && \
    chown -R $USER:$USER /home/$USER

RUN mkdir -p /home/$USER/logs && chown -R coder:coder /home/$USER/logs
RUN mkdir -p /run/php && chown coder:coder /run/php
RUN sed -i 's/^APACHE_RUN_USER=.*/APACHE_RUN_USER=coder/' /etc/apache2/envvars && \
    sed -i 's/^APACHE_RUN_GROUP=.*/APACHE_RUN_GROUP=coder/' /etc/apache2/envvars && \
    a2enmod rewrite && \
    if [ -f /etc/apache2/conf-available/phpmyadmin.conf ]; then a2enconf phpmyadmin; fi && \
    mkdir -p /run/apache2 /var/lock/apache2 /var/log/apache2 && \
    chown -R coder:coder /run/apache2 /var/log/apache2 /var/lock/apache2
# Instalare NVM + Node.js v22 pentru utilizatorul coder
RUN mkdir -p /home/$USER/.nvm && chown -R coder:coder /home/$USER/.nvm
ENV NVM_DIR=/home/${USER}/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    NVM_DIR="$NVM_DIR" bash -c 'source $NVM_DIR/nvm.sh && nvm install 22' && \
    chown -R ${USER}:${USER} $NVM_DIR
RUN curl -fsSL https://coder.com/install.sh | sh
# Asigură-te că utilizatorul coder există deja
RUN usermod -aG www-data coder 
# Adaugă userul `coder` în grupul sudo și setează fără parolă
RUN usermod -aG sudo coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/coder && \
    chmod 0440 /etc/sudoers.d/coder

WORKDIR $WORKDIR
USER $USER

