################################################################################
## ATTENTION: multistage build
##
## based on current USER and TAG, DOCKER_BASE
##
################################################################################
## base image settings
ARG USER="${USER}"
ARG DOCKER_BASE="ubu1804"
ARG DOCKER_BASE_TAG="ubu1804-20230501"

################################################################################
## base image
FROM ${USER}/${DOCKER_BASE}:${DOCKER_BASE_TAG} AS peta-2020.1
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive

################################################################################
## environment (applied ARG/ENV must come after FROM declaration)
ARG USER="${USER}"

################################################################################
## container additionals
USER root

## NB: don't do "apt-get upgrade -y", for avoiding trouble
## incompatible through packaging solutions
RUN apt-get update && apt-get autoremove -y --purge

## xilinx needed packages
RUN apt-get install -y \
	mercurial \
	libc6-i386 \
	bsdmainutils \
	google-perftools \
	libegl1-mesa \
	libsdl1.2-dev \
	python \
	pylint \
	python3 \
	python3-pip \
	python3-git \
	python3-jinja2 \
	python3-pexpect \
	perl \
	liberror-perl \
	haveged \
	lib32stdc++6 \
	libgtk2.0-0:i386 \
	libfontconfig1:i386 \
	libx11-6:i386 \
	libxext6:i386 \
	libxrender1:i386 \
	libsm6:i386 \
	xinetd \
	xterm \
	texinfo \
	zlib1g-dev \
	zlib1g:i386 \
	putty \
	pax \
	mtd-utils \
	x11-utils \
	xtrans-dev \
	libxcb-randr0-dev \
	libxcb-xtest0-dev \
	libxcb-xinerama0-dev \
	libxcb-shape0-dev \
	libxcb-xkb-dev \
	ncurses-dev \
	libncurses5 \
	libncurses5-dev \
	libncursesw5-dev \
	libncurses5:i386 \
	libtinfo5 \
	libstdc++6:i386 \
	dpkg-dev:i386 \
	ocl-icd-libopencl1 \
	opencl-headers \
	ocl-icd-opencl-dev

## GUI IDEs may require the following...
RUN apt-get install -y \
	'^libxcb.*-dev' \
	libx11-xcb-dev \
	libglu1-mesa-dev \
	libxrender-dev \
	libxi-dev \
	libxkbcommon-dev \
	libxkbcommon-x11-dev

## needed for setup
RUN apt-get install -y \
	expect \
	zstd

################################################################################
## prepare installation
USER root
RUN mkdir /tools
RUN sudo chown ${USER}:${USER} -R /tools

RUN mkdir /home/$USER/scripts
COPY *.run /home/$USER/scripts/
COPY *.exp /home/$USER/scripts/

RUN sudo chown ${USER}:${USER} -R /home/$USER/scripts

################################################################################
## installation
USER $USER
RUN mkdir /home/$USER/workspace

WORKDIR /home/$USER/workspace
RUN /home/$USER/scripts/install-*.exp ../scripts/petalinux-*-installer.run

## cleanup
USER root
RUN mv /home/$USER/workspace /home/$USER/workspace.template
RUN rm -rf /home/$USER/scripts

## link config environment
RUN rm -f /home/$USER/.petalinux-sys.env && ln -s ${MY_CONFIGS}/.petalinux-sys.env /home/$USER/

################################################################################
## command mode
USER $USER
WORKDIR /home/$USER
COPY *.sh /usr/local/bin/
CMD ["/bin/bash", "/usr/local/bin/build.sh"]
