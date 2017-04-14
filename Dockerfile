FROM buildpack-deps:jessie

MAINTAINER Pijus Navickas <pijus.navickas@gmail.com>

# Set up Docker.
ENV DOCKER_VERSION 17.04.0-ce-rc2
ENV DOCKER_DOWNLOAD_URL https://test.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz
ENV DOCKER_DOWNLOAD_SHA256 64653090833c16e47426ada7dd85bec91d78e65beacd558e3b75ba4950e7be79
RUN set -x \
	&& curl -fSL "${DOCKER_DOWNLOAD_URL}" -o docker.tgz \
	&& echo "${DOCKER_DOWNLOAD_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz

# Set up GCloud SDK.
ENV PATH /google-cloud-sdk/bin:$PATH
RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz --no-check-certificate && \
    tar zxvf google-cloud-sdk.tar.gz && \
    rm google-cloud-sdk.tar.gz && \
    ./google-cloud-sdk/install.sh --usage-reporting=true --path-update=true && \
    gcloud --quiet components update && \
    gcloud --quiet components install kubectl
