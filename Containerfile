FROM ubuntu:26.04 AS source

ADD --checksum=sha256:c761acb9e52977924c6a36a10224cfb72985e6bef5c1e9e2c6f24e9748b106a7 https://github.com/zed-industries/zed/releases/download/v1.16.2/zed-linux-x86_64.tar.gz /tmp/app.tar.gz

RUN mkdir -p /out && \
    tar -xzf /tmp/app.tar.gz --strip-components=1 -C /out

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/zed"

COPY --from=source /out /opt/zed

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libvulkan1 libxkbcommon-x11-0 xdg-utils && \
    ln -sf /opt/zed/bin/zed /usr/bin/zed && \
    cpak-clean-junk

COPY icon.png /usr/share/icons/hicolor/128x128/apps/zed.png
COPY zed.desktop /usr/share/applications/zed.desktop
