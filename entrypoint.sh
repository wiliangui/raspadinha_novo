#!/bin/bash

# Executa as migrations do Laravel
# O --force é necessário para o ambiente de produção
php artisan migrate --force

# Inicia o servidor Apache (este deve ser sempre o último comando)
apache2-foreground