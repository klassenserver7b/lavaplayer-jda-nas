#!/bin/bash

# Build script for musl-libc variant
# This script can be used as an alternative to the Gradle Docker integration

set -e

PROJECT_ROOT=$(dirname "$0")
NATIVE_DIR="$PROJECT_ROOT/udp-queue-natives"
BUILD_DIR="$NATIVE_DIR/build/linux-x86-64-musl"
DIST_DIR="$NATIVE_DIR/dist/linux-x86-64-musl"

echo "Building udpqueue for musl-libc..."

# Ensure directories exist
mkdir -p "$BUILD_DIR"
mkdir -p "$DIST_DIR"

# Check if we're in a musl environment
if ! ldd --version 2>&1 | grep -q musl; then
    echo "Warning: Not running in a musl environment. Consider using Alpine Linux or musl toolchain."
fi

# Set environment variables
export DIST_DIR="$DIST_DIR"
export JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-1.8-openjdk}"

if [ ! -d "$JAVA_HOME" ]; then
    echo "Error: JAVA_HOME not found at $JAVA_HOME"
    echo "Please set JAVA_HOME to your JDK installation"
    exit 1
fi

echo "Using JAVA_HOME: $JAVA_HOME"
echo "Build directory: $BUILD_DIR"
echo "Output directory: $DIST_DIR"

# Configure with CMake
cd "$BUILD_DIR"
cmake -DBITZ:STRING=64 "$NATIVE_DIR/udpqueue"

# Build
cmake --build .

echo "Build completed. Library should be at: $DIST_DIR/libudpqueue.so"

# Verify the library was built
if [ -f "$DIST_DIR/libudpqueue.so" ]; then
    echo "✓ Successfully built libudpqueue.so"
    echo "Library info:"
    file "$DIST_DIR/libudpqueue.so"
    ldd "$DIST_DIR/libudpqueue.so" 2>/dev/null || echo "  (static binary or ldd not available)"
else
    echo "✗ Failed to build libudpqueue.so"
    exit 1
fi