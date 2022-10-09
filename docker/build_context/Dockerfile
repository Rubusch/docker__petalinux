################################################################################
## ATTENTION: multistage build
##
## based on current USER and TAG, DOCKER_BASE
##
################################################################################
## base image settings
ARG USER="${USER}"
ARG DOCKER_BASE="ubu1804"
ARG DOCKER_BASE_TAG="ubu1804-20221011"


################################################################################
## base image
FROM ${USER}/${DOCKER_BASE}:${DOCKER_BASE_TAG} AS peta-2020.2
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## environment (applied ARG/ENV must come after FROM declaration)
ARG USER="${USER}"


################################################################################
## container additionals
USER root

#RUN dpkg --add-architecture i386
RUN apt-get update
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
