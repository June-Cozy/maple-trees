# README.md

> [!TIP]
> 🎆 **Works on** 
> [vegcom/cozy-salt](https://github.com/vegcom/cozy-salt)

## QuickStart

### Prep System

```shell
kubectl label node papaya nvidia.com/gpu=present
```

### Prep image

```shell
# llama.cpp
docker build -t llama-cpp-qwen3:jp6 -f docker/llama_cpp.Dockerfile . &&\
docker save llama-cpp-qwen3:jp6 | sudo k3s ctr images import -
```

```shell
# langcache
docker build -f docker/langcache_embed.Dockerfile -t llama-cpp-langcache:jp6 . &&\
docker save llama-cpp-langcache:jp6 | sudo k3s ctr images import -
```

---

### deploy

```shell
# Start
kubectl apply -f k8s/llama-cpp-qwen3-embedding-0.6b.yaml
kubectl apply -f k8s/llama-cpp-langcache-embed-v3-small.yaml
```

```shell
# Or restart
kubectl rollout restart deployment/llama-cpp-qwen3-embedding-0-6b -n cozy-ai
kubectl rollout restart deployment/llama-cpp-langcache-embed-v3-small -n cozy-ai
```