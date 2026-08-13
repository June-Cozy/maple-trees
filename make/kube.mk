KUBE_BIN := kubecolor

# Install
kube-apply: kube-nvidia kube-namespace kube-pvc kube-embedding-langcache kube-embedding-qwen3 kube-reranker-qwen3  ## kube-apply - Deploy

kube-nvidia: ## kube-nvidia - Installs Nvidia plugin(patched)
		@$(KUBE_BIN) apply -f ./k8s/0-nvidia-device-plugin.yml
kube-namespace: ## kube-namespace - Create namespace
		@$(KUBE_BIN) apply -f ./k8s/1-namespace.yaml
kube-pvc: ## kube-pvc - Create storage
		@$(KUBE_BIN) apply -f ./k8s/2-pvc.yaml
kube-embedding-langcache: ## kube-embedding-langcache - Deploy langcache embed
		@$(KUBE_BIN) apply -f ./k8s/4-llama-cpp-langcache-embed-v3-small.yaml
kube-embedding-qwen3: ## kube-embedding-qwen3 - Deploy qwen3 embed
		@$(KUBE_BIN) apply -f ./k8s/4-llama-cpp-qwen3-embedding-0.6b.yaml
kube-reranker-qwen3: ## kube-reranker-qwen3 - Deploy qwen3 rerank
		@$(KUBE_BIN) apply -f ./k8s/4-llama-cpp-qwen3-reranker-0.6b.yaml

# Configure
NODE ?= papaya
kube-label-nvidia: require-NODE ## kube-label-nvidia - Set current host nvidia tag
		$(KUBE_BIN) label node $(NODE) nvidia.com/gpu=present