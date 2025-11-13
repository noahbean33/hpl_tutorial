# ===== Dockerfile =====
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1️⃣ 安裝基本工具與編譯環境
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    mpich \
    libopenblas-dev \
    && rm -rf /var/lib/apt/lists/*

# 2️⃣ 下載並編譯 HPL
WORKDIR /opt
RUN wget http://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz && \
    tar xzf hpl-2.3.tar.gz && \
    rm hpl-2.3.tar.gz

COPY Make.Linux_CPU /opt/hpl-2.3/Make.Linux_CPU

WORKDIR /opt/hpl-2.3
RUN make arch=Linux_CPU

# 3️⃣ 複製測試設定與執行腳本
WORKDIR /workspace
COPY HPL.dat .
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/workspace/entrypoint.sh"]
