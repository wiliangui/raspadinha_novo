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

# Instala o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configura o Apache para usar a pasta pública e ativa o mod_rewrite
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN a2enmod rewrite

# Define o diretório de trabalho
WORKDIR /var/www/html

# Copia os arquivos do projeto
COPY . .

# Instala as dependências do Laravel
RUN composer install --no-interaction --optimize-autoloader --no-dev

# ---- AJUSTE DE PERMISSÕES FINAL E CORRETO ----
# Garante que as pastas de log e cache existam
RUN mkdir -p storage/framework/sessions storage/framework/views storage/framework/cache storage/logs
RUN touch storage/logs/laravel.log

# Define as permissões corretas para as pastas, permitindo que o servidor escreva nelas
RUN chmod -R 775 storage bootstrap/cache

# Define o dono de TUDO para o usuário do servidor web (www-data)
RUN chown -R www-data:www-data /var/www/html

# Copia e torna o script de inicialização executável
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Define o nosso script como o comando de inicialização
ENTRYPOINT ["/var/www/html/entrypoint.sh"]