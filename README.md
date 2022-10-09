[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

# Container for Petalinux v2022.2

Docker for Petalinux BSPs. Staged build on based on external base container.  

!!! ATTENTION !!!  

!!! Switch over to one of the git BRANCHes to build !!! 

- [petalinux 2020.2](https://github.com/Rubusch/docker__petalinux/tree/peta2020.2-20230401)
- [petalinux 2022.1](https://github.com/Rubusch/docker__petalinux/tree/peta2022.1-20230401)
- [petalinux 2022.2](https://github.com/Rubusch/docker__petalinux/tree/peta2022.2-20230401)
 
(if you need vivado, vitis and petalinux try **https://github.com/Rubusch/docker__peta-vivado.git** )  


## Requirements

Make sure docker-compose is installed  
```
$ sudo apt-get install -y libffi-dev libssl-dev python3-dev python3-pyqt5 python3-pyqt5.qtwebengine python3 python3-pip
$ pip3 install docker-compose
```
Make sure ``~/.local`` is within ``$PATH`` or re-link e.g. it to ``/usr/local``, make sure to have docker group setup correctly, e.g.  
```
$ sudo usermod -aG docker $USER
```


## Build

Obtain official Petalinux installer (free) from https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools/archive.html
and place it in ``./docker/build_context``   

```
$ cp <path to petalinux installer>/petalinux-*-installer.run ./docker/build_context/

$ ./setup.sh
```


## Usage

Start and e.g. create a project from .xsa file copied to the workspace folder first (host).  
```
$ ./setup.sh
```

...or manually   
```
$ cd ./docker
$ docker-compose -f ./docker-compose.yml run --rm peta-2022.2 /bin/bash

docker$ cd ./workspace
docker$ petalinux-create -t project --template zynqMP -n MyBoard
docker$ cd ./MyBoard
docker$ petalinux-config --get-hw-description=~/workspace/MyDesign.xsa --silentconfig
docker$ petalinux-build
```

Reinitializing an empty workspace folder.  
```
docker$ build.sh
```

*NB*:  
  - Find the mounted workspace folder at: ``./docker/workspace``.  
  - Adjust Petalinux configuration in ``./docker/build_configs/.petalinux-sys.env``  
  - Adjust base image tag in first lines of ``./docker/build_context/Dockerfile``.  
