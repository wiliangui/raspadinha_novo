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

# Define o diretório de trabalho do container
WORKDIR /var/www/html

# Copia os arquivos do projeto
COPY . .

# Instala as dependências do Laravel
RUN composer install --no-interaction --optimize-autoloader --no-dev

# ---- AJUSTE DE PERMISSÕES MELHORADO ----
# Garante que o dono de todos os arquivos seja o usuário do servidor web
RUN chown -R www-data:www-data /var/www/html
# Cria o arquivo de log para garantir que ele exista
RUN touch /var/www/html/storage/logs/laravel.log
# Define as permissões corretas para as pastas e o arquivo de log
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod 664 /var/www/html/storage/logs/laravel.log

# Copia e torna o script de inicialização executável
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Define o nosso script como o comando de inicialização
ENTRYPOINT ["/var/www/html/entrypoint.sh"]