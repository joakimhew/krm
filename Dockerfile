ARG ARGOCD_VERSION=v2.8.4
FROM quay.io/argoproj/argocd:${ARGOCD_VERSION} as builder
RUN echo "Getting Kustomize from ArgoCD"

# currently trying out non-minimal. No luck AFAIK
FROM mgoltzsche/podman:4.1 as sidecar 
USER root
# Makes 3.9.3 the default kustomize being run
COPY --from=builder /usr/local/bin/kustomize /usr/local/bin/kustomize
RUN ln -s /usr/local/bin/podman /usr/local/bin/docker \
  # This is me trying to get rootless podman working
  # "ping" already had GID 999 which argocd says you need UID 999 so unsure whether a matching GID is also necessary
  && adduser -h /home/argocd -s /bin/sh -G ping -u 999 -D argocd \
  && echo 'argocd:165536:65536' >> /etc/subuid \
  && echo 'argocd:165536:65536' >> /etc/subgid