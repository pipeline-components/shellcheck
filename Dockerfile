FROM alpine:3.15.5 as build

# hadolint ignore=DL3018
RUN apk --no-cache add \
    curl \
    cabal=3.6.2.0-r1 \
    ghc=9.0.1-r1 \
    build-base \
    libffi-dev \
    upx

COPY app /app/
RUN mkdir -p /app/shellcheck
WORKDIR /app/shellcheck

RUN cabal update && \
    cabal install --jobs  --enable-executable-stripping --enable-optimization=2 --enable-shared --enable-split-sections  --disable-debug-info  ShellCheck-0.8.0

RUN cp "$(readlink -f /root/.cabal/bin/shellcheck)" /root/.cabal/bin/shellcheck && \
    upx -9 /root/.cabal/bin/shellcheck

FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

FROM alpine:3.15.5
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD shellcheck

COPY app /app/

# hadolint ignore=DL3018
RUN apk --no-cache add libffi libgmpxx parallel bash
COPY --from=build /root/.cabal/bin/shellcheck /usr/local/bin/shellcheck

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
    org.label-schema.usage="https://gitlab.com/pipeline-components/shellcheck/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/shellcheck/" \
    org.label-schema.vendor="Pipeline Components"
