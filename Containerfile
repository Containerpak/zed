FROM ubuntu:26.04 AS source

ADD --checksum=sha256:abf751395da92fcac783e1ec59e9812ac4c4ebb33a27f7f51059edde1aee99f9 https://github.com/zed-industries/zed/releases/download/v1.15.0/zed-linux-x86_64.tar.gz /tmp/app.tar.gz

RUN mkdir -p /out && \
    tar -xzf /tmp/app.tar.gz -C /out

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/zed"

COPY --from=source /out /opt/zed

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libvulkan1 libxkbcommon-x11-0 xdg-utils && \
    ln -sf /opt/zed/bin/zed /usr/bin/zed && \
    cpak-clean-junk

COPY icon.png /usr/share/icons/hicolor/128x128/apps/zed.png
COPY zed.desktop /usr/share/applications/zed.desktop
