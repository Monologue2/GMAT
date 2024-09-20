# MIT License

# Copyright (c) 2024 Seung Un Yu

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

FROM nvcr.io/nvidia/cuda:12.2.0-devel-ubuntu20.04

ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

# TensorRT version: https://developer.nvidia.com/tensorrt/download/10x
ENV os="ubuntu2004"
ENV tag="10.4.0-cuda-12.6"

RUN apt update && apt install -y \
    yasm \
    libavdevice-dev \
    wget \
    git \
    cmake 

RUN export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

COPY .. /gmat
WORKDIR /gmat

RUN wget https://github.com/CVCUDA/CV-CUDA/releases/download/v0.3.1-beta/nvcv-lib-0.3.1_beta-cuda12-x86_64-linux.deb && \
    wget https://github.com/CVCUDA/CV-CUDA/releases/download/v0.3.1-beta/nvcv-dev-0.3.1_beta-cuda12-x86_64-linux.deb && \
    apt install ./nvcv-lib-0.3.1_beta-cuda12-x86_64-linux.deb ./nvcv-dev-0.3.1_beta-cuda12-x86_64-linux.deb

RUN wget https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/10.4.0/local_repo/nv-tensorrt-local-repo-ubuntu2004-10.4.0-cuda-12.6_1.0-1_amd64.deb && \
    dpkg -i nv-tensorrt-local-repo-${os}-${tag}_1.0-1_amd64.deb && \
    cp /var/nv-tensorrt-local-repo-${os}-${tag}/*-keyring.gpg /usr/share/keyrings/ && \
    apt update && \
    apt install -y tensorrt

RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
    cd nv-codec-headers && \
    make install

RUN git clone https://github.com/nokiatech/heif.git && \
    cd heif/build && \
    cmake ../srcs && \
    make -j 8 && \
    mkdir /usr/local/include/heif && \ 
    cp -r ../srcs/api/* /usr/local/include/heif && \
    cp ./lib/*.so /usr/local/lib

WORKDIR /gmat/ffmpeg-gpu
RUN ./configure --disable-ptx-compression --enable-cvcuda --enable-libtensorrt --extra-cflags=-I/opt/nvidia/cvcuda0/include/ --disable-static --enable-shared --enable-nonfree --enable-cuda-nvcc --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --nvccflags='-gencode arch=compute_86,code=sm_86 -I./' --extra-libs=-lstdc++ && \
    make -j 8 && \
    make install
    # make install && \
    # cd ../metrans && \
    # make -j 8

RUN mkdir workspace
WORKDIR /workspace
CMD ["ffmpeg"]