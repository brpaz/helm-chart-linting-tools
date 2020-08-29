FROM alpine:3.12

ARG KUBECTL_VERSION=1.19.0
ARG HELM_VERSION=3.3.0

RUN apk update && apk add --no-cache \
    bash \
    curl \
    git

# Install kubectl
RUN curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl version --client

RUN curl -L -o helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -xvf helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf linux-amd64 && \
    rm helm.tar.gz && \
    helm version && \
    helm plugin install https://github.com/instrumenta/helm-kubeval && \
    helm plugin install https://github.com/instrumenta/helm-conftest

ENTRYPOINT ["helm"]