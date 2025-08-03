# Usa a imagem oficial do PHP 8.2 com servidor Apache
FROM php:8.2-apache

# Instala dependências do sistema e extensões PHP que o Laravel precisa
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd zip intl simplexml curl soap

# Instala o Composer (gerenciador de pacotes do PHP)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configura o Apache para usar a pasta /public do Laravel
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN a2enmod rewrite

# Define o diretório de trabalho do container
WORKDIR /var/www/html

# Copia os arquivos do seu projeto para dentro do container
COPY . .

# Instala as dependências do Laravel (sem as de desenvolvimento)
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Ajusta as permissões das pastas do Laravel
RUN chown -R www-data:www-data storage bootstrap/cache
RUN chmod -R 775 storage bootstrap/cache