FROM microsoft/azure-cli

ARG GCP_CLOUD_SDK_URL=""

WORKDIR /app
RUN apk add --no-cache bash curl python && \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-272.0.0-linux-x86_64.tar.gz && \
    tar xf google-cloud-sdk-* && \
    ./google-cloud-sdk/install.sh --quiet && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.3/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl


ENV PATH="${PATH}:/usr/local/bin:/app/google-cloud-sdk/bin"

ENTRYPOINT [ "/bin/bash" ]