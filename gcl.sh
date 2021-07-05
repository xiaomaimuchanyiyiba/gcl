#! /usr/bin/env bash

set -uo pipefail

trap "echo 'something wrong'" ERR
function initAsHTTPUrl() {
    local elements=($(echo $URL | tr '/' ' '))
    HOST=${elements[1]}
    GROUP=${elements[2]}
    PROJECT=$(echo ${elements[3]} | sed 's/.git//g')
    DEST_DIR=${HOME}/${WORKSPACE}/${HOST}/${GROUP}/${PROJECT}
}

function initAsSSHUrl() {
    local elements=($(echo $URL | tr '@' ' ' | tr ':' ' ' | tr '/' ' '))
    HOST=${elements[1]}
    GROUP=${elements[2]}
    PROJECT=$(echo ${elements[3]} | sed 's/.git//g')
    DEST_DIR=${HOME}/${WORKSPACE}/${HOST}/${GROUP}/${PROJECT}
}

function init() {
    if [[ ${URL} =~ "http://" ]]; then
        initAsHTTPUrl
    fi
    if [[ ${URL} =~ "https://" ]]; then
        initAsHTTPUrl
    fi
    if [[ ${URL} =~ "git@" ]]; then
        initAsSSHUrl
    fi
}

function clone() {
    mkdir -p ${DEST_DIR}
    git clone ${URL} ${DEST_DIR}
}

function postProcess() {
    read -p "Do you wish to open ${DEST_DIR} with vscode ?" OPEN_WITH_EDITOR
    if [[ ${OPEN_WITH_EDITOR} == "y" ]]; then
        code ${DEST_DIR}
    fi
}

WORKSPACE=workspace
URL=$1

init
clone
postProcess
