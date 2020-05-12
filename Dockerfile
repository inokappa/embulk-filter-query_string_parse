FROM openjdk:8-jdk-alpine

RUN apk update && apk add --no-cache curl bash libc6-compat \
    && mkdir /embulk \
    && curl -o /usr/local/bin/embulk -L "https://dl.embulk.org/embulk-latest.jar" \
    && chmod +x /usr/local/bin/embulk
CMD ["bash"]
