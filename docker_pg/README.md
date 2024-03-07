

## Levantar el servidor 
```
# docker compose up -d 
[+] Building 0.0s (0/ 0)                                                                                                                                                                                 
[+] Running 3/3
 ✔ Network docker_pgadmin_default  Created                                                                                                                                                         0.3s 
 ✔ Container my-database           Started                                                                                                                                                         2.4s 
 ✔ Container pgadmin4              Started                            
```

## Destruir el contenedor                                                                                                                              2.8s 
```
# docker compose down
```



# Problems with docker


### Create the docker group.


```bash 
sudo groupadd docker
```

### Add your user to the docker group.

```bash 
 sudo usermod -aG docker $USER
```

Log out and log back in so that your group membership is re-evaluated. If you're running Linux in a virtual machine, it may be necessary to restart the virtual machine for changes to take effect. You can also run the following command to activate the changes to groups:

```bash 
newgrp docker
 ```

### source
https://docs.docker.com/engine/install/linux-postinstall/

