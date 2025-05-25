# Building with musl-libc Support

This library now supports musl-libc (Alpine Linux) in addition to the existing platforms (Windows, macOS, Linux with glibc).

## Quick Start (Docker Method - Recommended)

The easiest way to build the musl variant is using the provided Docker setup:

```bash
# Make the build script executable
chmod +x build-musl.sh

# Run the build
./build-musl.sh
```

This will:
1. Build a Docker image with Alpine Linux and all required build tools
2. Compile the native library for musl-libc
3. Copy the resulting `libudpqueue.so` to the appropriate location
4. Verify the build was successful

## Manual Build on Alpine Linux

If you're already running on Alpine Linux (or have a musl toolchain), you can build directly:

```bash
# Install dependencies (on Alpine)
apk add cmake make gcc g++ musl-dev linux-headers openjdk8

# Build the project
./gradlew :udp-queue-natives:compileNatives
```

## Output Location

The musl library will be built to:
- Native build: `udp-queue-natives/dist/linux-x86-64-musl/libudpqueue.so`
- Java resources: `udp-queue/src/main/resources/natives/linux-x86-64-musl/libudpqueue.so`

## Platform Detection

The build system automatically detects musl by:
1. Checking for Alpine Linux in `/etc/os-release`
2. Checking `ldd --version` output for musl signatures

When musl is detected, the library identifier becomes `linux-x86-64-musl` instead of `linux-x86-64`.

## Usage in Java Applications

The Java code automatically loads the correct native library based on the platform. No code changes are required - the same JAR will work on both glibc and musl systems.

## Troubleshooting

### Library not found
If you get "library not found" errors, verify the musl library was built:
```bash
find . -name "libudpqueue.so" -path "*/linux-x86-64-musl/*"
```

### Docker build issues
If the Docker build fails, try:
```bash
# Clean build
docker system prune -f
./build-musl.sh
```

### Verification
To verify the library was built correctly for musl:
```bash
# Check the library type
file udp-queue-natives/dist/linux-x86-64-musl/libudpqueue.so

# Check dependencies (should show musl)
ldd udp-queue-natives/dist/linux-x86-64-musl/libudpqueue.so
```

## Build Requirements

### Docker Method
- Docker installed and running
- Internet connection (for pulling Alpine image)

### Manual Method (Alpine Linux)
- Alpine Linux 3.12+ (or equivalent musl-based system)
- OpenJDK 8+
- CMake 3.0+
- GCC/G++ compiler
- musl development headers