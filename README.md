# practica-sysadmin

## ¿Cómo desplegar el entorno ELK?

Al estar utilizando Vagrant, es imprescindible tener Virtualbox y Vagrant instalado en  la máquina.

Una vez estemos en la carpeta con la terminal, ejecutamos

``vagrant up``

Una vez se haya ejecutado todo el proceso, entramos en el VirtualBox haciendo uso de

``vagrant ssh``

Una vez dentro, ejecutamos lo siguiente:

``sudo -s``

``cd /vagrant/ && ./deploy_elk_environment.sh``

A las preguntas de Y/n, siempre responder `Y`
Al solicitar una password del Kibana, escribimos una cualquiera, en mi caso, pulso enter dos veces. Ya que es todo de prueba.

## ¿Cómo desplegar el entorno App? 


[Tienes que acceder a la siguiente url en GitHub para ver toda la documentación.](https://github.com/JesusGR4/instapybot/tree/develop)


## ¿Quieres verlo desplegado y probarlo tú mismo?

[Aquí](http://54.187.194.44/app/infra#/logs?_g=()) puedes ver en tiempo real cómo se captal los logs. Pulsa live stream y verás como se rellenan :)

[Ésta](http://34.208.196.105:8000/) es la aplicación Django en el que navegando por ella (es una app muy virgen) puedes ver cómo se van actualizando los logs.

Como los discos están limitados en AWS, si se cae o algo avísame por favor. Esto es puro testing :)