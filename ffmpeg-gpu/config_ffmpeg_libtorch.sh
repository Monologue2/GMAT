# !/bin/bash
TORCH_VISION_INCPATH=-I/home/xiaowei/Codes/libtorch/include/torch/csrc/api/include
TORCH_INCPATH=-I/home/xiaowei/Codes/libtorch/include
TORCH_LIBPATH=/home/xiaowei/Codes/libtorch/lib
CV_CUDA_INCPATH=-I../cv-cuda/include
CV_CUDA_LIBPATH=../cv-cuda/build/lib

./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include \
--extra-ldflags=-L/usr/local/cuda/lib64 --disable-static --enable-shared --enable-opengl --enable-libtensorrt \
--extra-ldflags=-L$TORCH_LIBPATH \
--extra-cflags=$TORCH_VISION_INCPATH \
--extra-cflags=$TORCH_INCPATH \
--extra-cflags=$CV_CUDA_INCPATH \
--extra-ldflags=-L$CV_CUDA_LIBPATH \
--nvccflags="-gencode arch=compute_75,code=sm_75 -lineinfo -Xcompiler -fPIC" \
# --disable-stripping