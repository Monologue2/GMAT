FFmpeg GPU Demo
==========================
This demo shows a ffmpeg-based full-GPU rendering and inference pipeline. The code is based on ffmpeg release 4.4.

## Build
Requirements:
* libtorch >= 1.9.1
* torchvision >= 0.11.1
* TensoRT >= 8.0.1
* onnxruntime-gpu 1.8.1
* Eigen 3.4.0
* CUDA >= 11.0

Download libtorch with cxx11 ABI

```bash
wget https://download.pytorch.org/libtorch/cu113/libtorch-cxx11-abi-shared-with-deps-1.10.2%2Bcu113.zip
unzip libtorch-cxx11-abi-shared-with-deps-1.10.2+cu113.zip
```

Compile torchvision with C++ API

```bash
git clone https://github.com/pytorch/vision.git
cd torchvision && mkdir build
cmake -DWITH_CUDA=on ..
make
make install
```
Go to the ffmpeg-gpu folder

```bash
cd ffmpeg-gpu
```

Remeber to change the *PATH variables in `config_ffmpeg_libtorch.sh` according to your installation, then configure ffmpeg

```bash
bash config_ffmpeg_libtorch.sh && make
```

You can modify the `config_ffmpeg_libtorch.sh` file to add additional configure options, e.g. --enable-libx264.
If your libtorch/torchvision binary is built with pre-cxx11 ABI (e.g. installed using pip), add --extra-cxxflags="-D_GLIBCXX_USE_CXX11_ABI=0" to the configure options.

## Run the pipeline
The code provides an ESRGAN super-resolution model (ESRGAN_x4_dynamic.onnx) just for reference. Before running the pipeline, please convert the ONNX model to a TRT engine using `trtexec`. Download the [img2pose model](https://drive.google.com/file/d/1OvnZ7OUQFg2bAgFADhT7UnCkSaXst10O/view) and unzip the model. The img2pose model can be run directly by onnxruntime, no need to convert.

If you want to run the rendering filter, remember to put the rendering assets (medmask/) in the directory where you call `ffmpeg`, e.g. the root folder of ffmpeg.

Use the following command to run the pipeline:

```bash
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i <input> -vf pose="./img2pose_v1_ft_300w_lp_static_nopost.onnx":8,format_cuda=rgbpf32,tensorrt="./ESRGAN_x4.trt",format_cuda=nv12,scale_npp=1920:1080 -c:v h264_nvenc <output>
```

This is the first version of the pipeline, we expect bugs and errors, feel free to communicate with us if you have any problems.

