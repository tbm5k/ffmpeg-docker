FROM ubuntu:24.10 AS build

WORKDIR /service

ARG TOOLS="xz-utils wget gcc ca-certificates libc6-dev"

RUN apt -qqy update \
    && apt install -qqy --no-install-recommends ${TOOLS}

RUN wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/ffmpeg/7:7.1-3ubuntu1/ffmpeg_7.1.orig.tar.xz -O ffmpeg.tar.xz

RUN apt install -qqy --no-install-recommends pkg-config make

RUN tar -Jxvf ffmpeg.tar.xz && \
    mv ffmpeg-7.1 ffmpeg && \
    cd ffmpeg && \
    ./configure && \
    make && \
    make install

FROM ubuntu:24.10

COPY --from=build /usr/local/bin /usr/local/bin

RUN apt update -qqy && apt install -qqy --no-install-recommends

ENTRYPOINT ["ffmpeg"]

