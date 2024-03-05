# siamt

## Desarrollo
Instalar [Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
>Requiere Microsoft Windows 10 Professional o Enterprise 64-bit, o Windows 10 Home 64-bit con WSL 2.

[Documentación](https://docs.docker.com/desktop/windows/install/)

Una vez instalado:
1. Iniciar sesion con las credenciales de gitlab

	```docker login gitaty.transporteyucatan.org.mx:5050 -u <username> -p <token>```
	
	**Nota:** ```<token>``` representa un [token personal de acceso](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)
1. Clonar repositorio
1. Iniciar linea de comando
1. Cambiarse a la carpeta "containers"
1. Ejecutar 
```sh
docker compose up -d
```

En la interfaz grafica de docker se podra observar como se inician todos los servicios del sistema.

Para bajar todos los servicios
```sh
docker compose down
```

Para operaciones individuales como:
* Iniciar una linea de comandos de un contenedor, 
* Reiniciar/detener/eliminar un contenedor

Se puede utilizar la interfaz grafica.


## Servicios nodejs

### UI
Para agregar dependencia
* Iniciar linea de comando en contenedor
* Cambiarse a /srv/app
* ```yarn add *dependencia*```

### Otros
Para agregar dependencia
* Iniciar linea de comando en contenedor
* Cambiarse a /srv/app
* ```npm install *dependencia*```


## Acceso
El login es multidominio el registro por defecto es usando localhost
https://localhost/
usuario: master
password: master