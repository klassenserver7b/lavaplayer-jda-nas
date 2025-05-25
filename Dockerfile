FROM alpine:latest

# Install build dependencies
RUN apk add --no-cache \
    cmake \
    make \
    gcc \
    musl-dev \
    openjdk8 \
    bash

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk

# Create working directory
WORKDIR /workspace

# Default command
CMD ["sh"]