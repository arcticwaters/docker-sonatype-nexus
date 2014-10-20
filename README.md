Nexus
=====

This repository contains building a [docker](https://docker.io) image of [Sonatype Nexus](http://www.sonatype.org/nexus).


# Usage
Start a new container and bind to host port 8081

```
docker run -d -p 8081:8081 -t nexus:latest
```

or if you want to keep all nexus state on the host machine

```
docker run -d -p 8081:8081 -v /home/nexus:/opt/sonatype-work -t nexus:latest 
```
