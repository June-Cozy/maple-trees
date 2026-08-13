# Python helpers
DOCKER_BIN := docker

dockerx-qwen3: ## dockerx-qwen3 - Builds llama_cpp w qwen3 support
		docker build -t llama-cpp-qwen3:jp6 -f docker/llama_cpp.Dockerfile . && docker save llama-cpp-qwen3:jp6 | sudo k3s ctr images import -

dockerx-langcache: ## dockerx-langcache - Builds llama_cpp langcache
		docker build -f docker/langcache_embed.Dockerfile -t llama-cpp-langcache:jp6 . && docker save llama-cpp-langcache:jp6 | sudo k3s ctr images import -

# dockerx-test:
# 		if $(docker image ls|grep "llama-cpp-qwen3:jp6") ;  then echo "yay" ; fi