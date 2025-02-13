#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM openjdk:11-jdk-bullseye

ARG SPARK_VERSION=3.3.2
ARG HADOOP_VERSION=3
ARG APACHE_LIVY=0.8.0

# configure locale
RUN apt-get update -qq > /dev/null && apt-get install -qq --yes \
    locales && \
    locale-gen en_US.UTF-8
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

# Install necessary dependencies for build/test
RUN apt-get install -qq \
    apt-transport-https \
    curl \
    git \
    libkrb5-dev \
    maven \
    python3-dev \
    python3-setuptools \
    python3-pip \
    software-properties-common \
    wget \
    unzip \
    apt-utils

# R 3.x install - ensure to add the signing key per https://cran.r-project.org/bin/linux/ubuntu/olderreleasesREADME.html
RUN apt-get update && \
    apt-get -qq install -y r-base

# Now do the same for python3
RUN python3 -m pip install -U pip
RUN python3 -m pip install \
        cloudpickle \
        codecov \
        flake8 \
        flaky \
        "future>=0.15.2" \
        "futures>=3.0.5" \
        pytest \
        pytest-runner \
        requests-kerberos \
        "requests >= 2.10.0" \
        "responses >= 0.5.1" \
        pyspark
# Install spark
RUN mkdir -p /opt/spark &&  mkdir -p /opt/livy && mkdir -p /opt/release-staging
RUN curl -L -o /opt/spark.tgz http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xvzf /opt/spark.tgz -C /opt/spark --strip-components 1

COPY release-staging/apache-livy-${APACHE_LIVY}-incubating-SNAPSHOT-bin.zip /opt/release-staging

RUN unzip -d /opt/livy /opt/release-staging/apache-livy-${APACHE_LIVY}-incubating-SNAPSHOT-bin.zip 

RUN mv /opt/livy/apache-livy-${APACHE_LIVY}-incubating-SNAPSHOT-bin /opt/livy/server

COPY conf/livy.conf.template /opt/livy/server/conf/livy.conf
COPY conf/livy-env.sh.template /opt/livy/server/conf/livy-env.sh
COPY conf/spark-blacklist.conf.template /opt/livy/server/conf/spark-blacklist.conf
COPY conf/livy-client.conf.template /opt/livy/server/conf/livy-client.conf
COPY conf/log4j.properties.template /opt/livy/server/conf/log4j.properties
COPY dev/docker/start_server.sh /start_server.sh

RUN chmod 755 /start_server.sh

# Install Livy
WORKDIR /workspace

EXPOSE 8998

ENTRYPOINT ["/start_server.sh"]