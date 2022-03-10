FROM alpine:3.13.7 as build

# hadolint ignore=DL3018
RUN apk --no-cache add \
    curl \
    cabal=3.2.0.0-r0 \
    ghc=8.8.4-r0 \
    build-base=0.5-r2 \
    upx

COPY app /app/
RUN mkdir -p /app/shellcheck
WORKDIR /app/shellcheck

RUN cabal update && \
    cabal install --jobs  --enable-executable-stripping --enable-optimization=2 --enable-shared --enable-split-sections  --disable-debug-info  ShellCheck-0.7.1

RUN cp "$(readlink -f /root/.cabal/bin/shellcheck)" /root/.cabal/bin/shellcheck && \
    upx -9 /root/.cabal/bin/shellcheck

FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

FROM alpine:3.13.7
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD shellcheck

COPY app /app/

# hadolint ignore=DL3018
RUN apk --no-cache add libffi=3.3-r2 libgmpxx=6.2.1-r0 parallel
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
