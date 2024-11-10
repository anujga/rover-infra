#FROM pytorch/pytorch:2.5.0-cuda12.4-cudnn9-devel
FROM nvcr.io/nvidia/pytorch:24.10-py3

RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        apt-transport-https ca-certificates gnupg \
        curl btop htop git \
    &&  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
          | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt gcsfuse-jammy main" \
          | tee -a /etc/apt/sources.list.d/google-gcsfuse.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
          | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends google-cloud-cli gcsfuse


ADD ./external/te /app/external/te
WORKDIR /app/external/te


RUN --mount=type=cache,target=/root/.nv \
    --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/tmp \
    pip install .


RUN --mount=type=cache,target=/root/.nv \
    --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/tmp \
    pip install flash_attn==2.6.3

# we clone it incase someone wants to checkout different version
RUN --mount=type=cache,target=/git \
    git clone https://github.com/Dao-AILab/flash-attention /git/flash-attention
