# Docker Client App 

A Docker client app for Linux developed with Flutter

---
#### IMPORTANT
You need to enable docker to use it without sudo command, for that follow the next steps:

#### To create the docker group and add your user:

1. Create the docker group.
```bash
$ sudo groupadd docker
```
2. Add your user to the docker group.
```bash
$ sudo usermod -aG docker $USER
```
3. Log out and log back in so that your group membership is re-evaluated.

> If you’re running Linux in a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

- You can also run the following command to activate the changes to groups:
```bash
$ newgrp docker
```

4. Verify that you can run docker commands without sudo.
```bash
$ docker run hello-world
```

More info in the [Official Docker Documentation](https://docs.docker.com/engine/install/linux-postinstall/)
