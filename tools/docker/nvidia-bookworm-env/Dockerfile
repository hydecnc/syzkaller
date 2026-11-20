# Builds the NVIDIA executor against Debian bookworm's glibc (2.36), matching the
# bookworm guest image used by OG StepStone. The executor links libcuda dynamically,
# so building it in the trixie-based syz-env yields a binary that needs GLIBC_2.38+.
# Use via tools/syz-bookworm-env, e.g. `./tools/syz-bookworm-env make nvidia`.
FROM debian:bookworm

ARG CUDA_VERSION=12-6
ARG CUDA_KEYRING_VERSION=1.1-1
ARG GO_VERSION=1.26.0

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends \
    make gcc g++ libc6-dev git curl wget ca-certificates ncurses-bin \
  && wget -q https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_${CUDA_KEYRING_VERSION}_all.deb \
  && dpkg -i cuda-keyring_${CUDA_KEYRING_VERSION}_all.deb \
  && rm cuda-keyring_${CUDA_KEYRING_VERSION}_all.deb \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends \
    cuda-driver-dev-${CUDA_VERSION} cuda-cudart-dev-${CUDA_VERSION} \
  && rm -rf /var/lib/apt/lists/*

RUN ln -sfn /usr/local/cuda-$(echo ${CUDA_VERSION} | tr - .) /usr/local/cuda

RUN curl -sSL https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xz
RUN mkdir -p /syzkaller/gopath/src/github.com/google/syzkaller /syzkaller/.cache/gomod /gopath \
  && chmod -R 0777 /syzkaller /gopath

ENV PATH="/usr/local/go/bin:/gopath/bin:/usr/local/cuda/bin:${PATH}"
ENV GOPATH=/gopath
ENV GOMODCACHE=/syzkaller/.cache/gomod
ENV SYZ_ENV=yes

RUN test -f /usr/local/cuda/include/cuda.h && test -f /usr/local/cuda/lib64/stubs/libcuda.so \
  && ldd --version | head -1

ENTRYPOINT ["bash"]
