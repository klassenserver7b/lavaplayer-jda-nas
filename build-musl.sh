#!/bin/bash

# build-musl.sh - Script to build the musl variant using Docker

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Building UDP Queue Manager with musl-libc support${NC}"

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker is required but not installed. Please install Docker first.${NC}"
    exit 1
fi

# Build the Docker image
echo -e "${YELLOW}Building Alpine build environment...${NC}"
docker build -t udp-queue-musl-builder -f Dockerfile.alpine .

# Run the build in the container
echo -e "${YELLOW}Building native libraries for musl...${NC}"
docker run --rm -v "$(pwd):/workspace" -w /workspace udp-queue-musl-builder ./gradlew :udp-queue-natives:compileNatives

# Check if the musl variant was built
MUSL_LIB_PATH="udp-queue-natives/dist/linux-x86-64-musl/libudpqueue.so"
if [ -f "$MUSL_LIB_PATH" ]; then
    echo -e "${GREEN}Successfully built musl variant: $MUSL_LIB_PATH${NC}"
    
    # Show library info
    echo -e "${YELLOW}Library information:${NC}"
    docker run --rm -v "$(pwd):/workspace" -w /workspace udp-queue-musl-builder file "$MUSL_LIB_PATH"
    docker run --rm -v "$(pwd):/workspace" -w /workspace udp-queue-musl-builder ldd "$MUSL_LIB_PATH" || echo "Static binary (good for musl)"
else
    echo -e "${RED}Failed to build musl variant${NC}"
    exit 1
fi

# Copy natives to the Java project
echo -e "${YELLOW}Copying natives to Java resources...${NC}"
docker run --rm -v "$(pwd):/workspace" -w /workspace udp-queue-musl-builder ./gradlew :udp-queue:copyNatives

echo -e "${GREEN}Build completed successfully!${NC}"
echo -e "${YELLOW}The musl library is available at: $MUSL_LIB_PATH${NC}"