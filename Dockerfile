# Copyright 2018 Audios Ventures, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Build this container from the official Hyperkube container from Google.
FROM gcr.io/google-containers/hyperkube-amd64:v1.10.1

# Setup some labels for user's who want to inspect the container.
LABEL MAINTAINER="Steven Crothers <crothers@simplecast.com>"
LABEL DESCRIPTION="The simpledeploy system is a Python based Kubernetes deployment tool designed to work with Gitlab CI."
LABEL LICENSE="Apache 2.0"
LABEL LICENSE_URL="https://opensource.org/licenses/Apache-2.0"
LABEL SOURCE="https://github.com/audiosventures/simpledeploy"
LABEL ISSUES="https://github.com/audiosventures/simpledeploy/issues"

# Install Python3 as a dependancy for simpledeploy.
RUN apt-get -y update && \
    apt-get -y install python3 python3-setuptools python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Copy the simpledeploy code over to the container and build.
ADD . /tmp
RUN cd /tmp && \
    pip3 install -r requirements.txt && \
    python3 setup.py install

# Clean up the operating system to reduce the weight of the container.
RUN apt-get -y remove --purge python3-setuptools python3-pip && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -Rf /tmp/*

# Create an application working directory and use it for default entry.
RUN mkdir /deployment
WORKDIR /deployment

# Setup the default command to be bash instead of sh.
CMD ["/bin/bash"]
