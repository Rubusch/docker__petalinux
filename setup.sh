#!/bin/sh -e
## obtains the BASE_IMAGE name from the script
##	./docker*/build_context/Dockerfile
##
## Dryrun - with arguments the script will only build the container
die()
{
	echo "FAILED! $@"
	exit 1
}

do_env()
{
	test -e .env && return || true
	rm -f .env  ## in case of broken symlink
	echo "UID=$(id -u)" > .env
	echo "GID=$(id -g)" >> .env
}

build()
{
	CONTAINER_NAME="$(grep "container_name:" -r "${1}/docker-compose.yml" | awk -F: '{ print $2 }' | tr -d ' ')"
	cd "${1}"
	do_env
	if [ -n "${2}" ]; then
		docker-compose build --no-cache
	else
		docker-compose up --exit-code-from "${CONTAINER_NAME}"
	fi
	cd -
}

DRYRUN="${1}"

TOPDIR="$(pwd)"
test -z "${DOCKERDIR}" && DOCKERDIR="docker"
test -z "${DOWNLOADDIR}" && DOWNLOADDIR="${TOPDIR}/${DOCKERDIR}/build_context"
BASE_IMAGE="$(grep "ARG DOCKER_BASE=" -r "${DOCKERDIR}/build_context/Dockerfile" | awk -F= '{ print $2 }' | tr -d '"')"
BASE_IMAGE_FOLDER="docker-base"
BASE_IMAGE_TAG="$(grep "ARG DOCKER_BASE_TAG" -r "${DOCKERDIR}/build_context/Dockerfile" | awk -F= '{ print $2 }' | tr -d '"')"
IMAGE="$( grep "^FROM" -r ${DOCKERDIR}/build_context/Dockerfile | awk '{ print $NF }' )"
IMAGE_TAG="$( grep 'image: ${USER}/' -r ${DOCKERDIR}/docker-compose.yml | awk -F: '{ print $NF }' )"
VERSION="$( echo ${IMAGE} | awk -F'-' '{ print $NF }' )"
CONTAINER_BASE="$(docker images | grep "${BASE_IMAGE}" | grep "${BASE_IMAGE_TAG}" | awk '{print $3}')" || true
CONTAINER="$(docker images | grep "${IMAGE_TAG}")" || true

## evaluate
if [ -z "${CONTAINER_BASE}" ]; then
	DO_BUILDBASE=1
	DO_BUILD=1
else
	if [ -z "${CONTAINER}" ]; then
		DO_BUILD=1
	else
		cd "${DOCKERDIR}"
		do_env
		docker-compose -f ./docker-compose.yml run --rm "${IMAGE}" /bin/bash
		exit 0
	fi
fi

## check
if [ -n "${DO_BUILD}" ]; then
	test -f ${TOPDIR}/${DOCKERDIR}/build_context/petalinux-v${VERSION}-*-installer.run || die "No petalinux installer provided! Please, put a petalinux-v${VERSION}-*-installer.run file in ${DOWNLOADDIR}"
fi

## build
if [ -n "${DO_BUILDBASE}" ]; then
	git clone "https://github.com/Rubusch/docker__ubu.git" "${BASE_IMAGE_FOLDER}" || die "Could not clone base container repo"
	cd "${BASE_IMAGE_FOLDER}"
	git checkout "${BASE_IMAGE_TAG}"
	build "${DOCKERDIR}" "base"
	cd "${TOPDIR}"
fi
if [ -n "${DO_BUILD}" ]; then
	build "${DOCKERDIR}" "${DRYRUN}"
fi

echo "READY."
