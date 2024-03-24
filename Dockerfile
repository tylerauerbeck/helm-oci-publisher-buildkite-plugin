FROM buildkite/plugin-tester:v4.1.1

ENV BATS_PLUGIN_PATH=/usr/lib/bats

# Install yq
RUN curl -fsSL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq && chmod a+x /usr/local/bin/yq

# Install helm
RUN curl -s -L https://get.helm.sh/helm-v3.14.3-linux-amd64.tar.gz | tar xvz --strip-components=1 -C /usr/local/bin linux-amd64/helm

WORKDIR /plugin

ENTRYPOINT []
CMD ["bats", "tests/"]