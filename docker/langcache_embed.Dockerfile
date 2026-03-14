FROM dustynv/llama_cpp:0.3.9-r36.4.0-cu128-24.04

# Build llama.cpp from source (static, no shared libs), convert model — all in one layer
# llama-quantize omitted: compiled with GGML_CUDA=ON links libnvrm_gpu.so unavailable at build time
# F16 GGUF is 45.6MB — small enough to serve directly
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends git cmake build-essential python3-pip && \
    git clone --depth=1 https://github.com/ggml-org/llama.cpp /tmp/llama.cpp && \
    cd /tmp/llama.cpp && \
    cmake -B build -DGGML_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=87 -DBUILD_SHARED_LIBS=OFF && \
    cmake --build build --config Release -j$(nproc) --target llama-server && \
    cp build/bin/llama-server /usr/local/bin/llama-server && \
    pip3 install --no-cache-dir --index-url https://pypi.org/simple \
        torch transformers sentencepiece protobuf huggingface_hub && \
    pip3 install --no-cache-dir --index-url https://pypi.org/simple \
        -e /tmp/llama.cpp/gguf-py && \
    HF_HUB_DISABLE_IPV6=1 hf download redis/langcache-embed-v3-small \
        --local-dir /tmp/langcache-model && \
    mkdir -p /models && \
    python3 /tmp/llama.cpp/convert_hf_to_gguf.py /tmp/langcache-model \
        --outfile /models/langcache-embed-v3-small-F16.gguf && \
    rm -rf /tmp/llama.cpp /tmp/langcache-model \
           /root/.cache/huggingface /var/lib/apt/lists/*
