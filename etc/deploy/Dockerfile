FROM microsoft/azure-cli

ARG GCP_CLOUD_SDK_URL=""

WORKDIR /app
RUN apk add --no-cache bash curl python && \
    curl -O $GCP_CLOUD_SDK_URL && \
    tar xf google-cloud-sdk-* && \
    ./google-cloud-sdk/install.sh --quiet && \
    export PATH=$PATH:/app/google-cloud-sdk/bin && \
    gcloud components install kubectl --quiet

ENV PATH="${PATH}:/app/google-cloud-sdk/bin"

ENTRYPOINT [ "/bin/bash" ]