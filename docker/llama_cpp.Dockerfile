FROM dustynv/llama_cpp:0.3.9-r36.4.0-cu128-24.04

RUN apt-get update -qq && apt-get install -y --no-install-recommends git cmake build-essential && \
    git clone --depth=1 https://github.com/ggml-org/llama.cpp /tmp/llama.cpp && \
    cd /tmp/llama.cpp && \
    cmake -B build -DGGML_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=87 -DBUILD_SHARED_LIBS=OFF && \
    cmake --build build --config Release -j$(nproc) --target llama-server && \
    cp build/bin/llama-server /usr/local/bin/llama-server && \
    rm -rf /tmp/llama.cpp /var/lib/apt/lists/*
