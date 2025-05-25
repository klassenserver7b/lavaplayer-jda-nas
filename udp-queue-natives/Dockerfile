FROM alpine:3.18

# Install build tools and dependencies
RUN apk add --no-cache \
    build-base \
    cmake \
    musl-dev \
    openjdk11 \
    git \
    bash

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

# Create working directory
WORKDIR /build

# Copy the source code
COPY . .

# Set default command - build without static flag
CMD ["bash", "-c", "mkdir -p build-musl && cd build-musl && \
     cmake .. -DCMAKE_C_FLAGS=\"-fpic -D_GNU_SOURCE -D__MUSL__\" -DMUSL_BUILD=ON && \
     make -j$(nproc) && \
     mkdir -p ../output && \
     find . -name \"*.so\" -o -name \"*.dylib\" -o -name \"*.dll\" | xargs -I{} cp {} ../output/"]
