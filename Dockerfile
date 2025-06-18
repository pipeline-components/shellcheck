FROM alpine:3.22.0 AS build

# hadolint ignore=DL3018
RUN apk --no-cache add \
    curl \
    cabal \
    ghc \
    build-base \
    libffi-dev \
    upx

COPY app /app/
RUN mkdir -p /app/shellcheck
WORKDIR /app/shellcheck

RUN \
    cabal update && \
    cabal install --jobs  --enable-executable-stripping --enable-optimization=2 --enable-shared --enable-split-sections  --disable-debug-info  ShellCheck-0.10.0

RUN cp "$(readlink -f /root/.local/bin/shellcheck)" /root/.local/bin/shellcheck && \
    upx -9 /root/.local/bin/shellcheck

FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

FROM alpine:3.22.0
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD shellcheck

COPY app /app/

# hadolint ignore=DL3018
RUN apk --no-cache add libffi libgmpxx parallel bash
COPY --from=build /root/.local/bin/shellcheck /usr/local/bin/shellcheck

WORKDIR /code/
# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <dev@pipeline-components.dev>" \
    org.label-schema.description="Shellcheck in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Shellcheck" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/shellcheck/blob/main/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/shellcheck/" \
    org.label-schema.vendor="Pipeline Components"
