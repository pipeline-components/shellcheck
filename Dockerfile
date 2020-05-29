FROM alpine:3.12.0 as build

RUN apk --no-cache add curl=7.67.0-r0 cabal=2.4.1.0-r0 ghc=8.6.5-r3 build-base=0.5-r1 upx=3.95-r2
RUN mkdir -p /app/shellcheck
WORKDIR /app/shellcheck

RUN cabal update
RUN cabal install --jobs  --enable-executable-stripping --enable-optimization=2 --enable-shared --enable-split-sections  --disable-debug-info  ShellCheck-0.6.0

RUN upx -9 /root/.cabal/bin/shellcheck

FROM pipelinecomponents/base-entrypoint:0.2.0 as entrypoint

FROM alpine:3.12.0
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD shellcheck

RUN apk --no-cache add libffi=3.2.1-r6 libgmpxx=6.1.2-r1 parallel=20191122-r0
COPY --from=build /root/.cabal/bin/shellcheck /usr/local/bin/shellcheck

WORKDIR /code/
# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <spam.me@grols.ch>" \
    org.label-schema.description="Shellcheck in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Shellcheck" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/shellcheck/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/shellcheck/" \
    org.label-schema.vendor="Pipeline Components"
