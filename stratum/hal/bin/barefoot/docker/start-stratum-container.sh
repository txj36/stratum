#!/bin/bash
#
# Copyright 2018-present Open Networking Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
set -e
set -x
PLATFORM_ARGS=""

if [ -n "$PLATFORM" ]; then
    # Use specific platorm port map
    PLATFORM_ARGS="--env PLATFORM=$PLATFORM"
elif [ -d "/etc/onl" ]; then
    # Use ONLP to find platform and it's library
    PLATFORM_ARGS=$(ls /lib/**/libonlp* | awk '{print "-v " $1 ":" $1 " " }')
    PLATFORM_ARGS="$PLATFORM_ARGS \
              -v /lib/platform-config:/lib/platform-config \
              -v /etc/onl:/etc/onl"
fi

CONFIG_DIR=${CONFIG_DIR:-/root}
LOG_DIR=${LOG_DIR:-/var/log}
SDE_VERSION=${SDE_VERSION:-9.0.0}
KERNEL_VERSION=$(uname -r)
DOCKER_IMAGE=${DOCKER_IMAGE:-stratumproject/stratum-bf}
DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG:-$SDE_VERSION-$KERNEL_VERSION}

docker run -it --privileged \
    -v /dev:/dev -v /sys:/sys  \
    -v /lib/modules/$(uname -r):/lib/modules/$(uname -r) \
    $PLATFORM_ARGS \
    -p 28000:28000 \
    -p 9339:9339 \
    -v $CONFIG_DIR:/etc/stratum \
    -v $LOG_DIR:/var/log/stratum \
    $DOCKER_IMAGE:$DOCKER_IMAGE_TAG
