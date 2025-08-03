<?php
file_put_contents(__DIR__ . '/../storage/logs/hello_world2.log', "Hello World\n", FILE_APPEND);
echo "Hello World - check storage/logs/hello_world2.log";
echo '\n';
echo exec('whoami');
echo '\n';
echo 'Usuário atual: ' . trim(shell_exec('whoami'));
