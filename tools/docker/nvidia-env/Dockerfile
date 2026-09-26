FROM gcr.io/syzkaller/env:latest

ARG DEBIAN_VERSION=13
ARG CUDA_VERSION=13-4
ARG CUDA_KEYRING_VERSION=1.1-1

RUN apt-get update \
  && apt-get install -y --no-install-recommends wget ca-certificates \
  && wget -q https://developer.download.nvidia.com/compute/cuda/repos/debian${DEBIAN_VERSION}/x86_64/cuda-keyring_${CUDA_KEYRING_VERSION}_all.deb \
  && dpkg -i cuda-keyring_${CUDA_KEYRING_VERSION}_all.deb \
  && rm cuda-keyring_${CUDA_KEYRING_VERSION}_all.deb \
  && apt-get update \
  && apt-get install -y --no-install-recommends cuda-toolkit-${CUDA_VERSION} \
  && rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV CPATH="/usr/local/cuda/include:${CPATH}"
ENV LIBRARY_PATH="/usr/local/cuda/lib64/stubs:${LIBRARY_PATH}"
