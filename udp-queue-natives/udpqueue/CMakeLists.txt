cmake_minimum_required(VERSION 3.0)
project(udpqueue C)

# Set output directories
if (DEFINED ENV{DIST_DIR})
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "$ENV{DIST_DIR}")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "$ENV{DIST_DIR}")
endif()

# Platform-specific settings
if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	include_directories("$ENV{JAVA_HOME}/include/win32")
	set(SYSNAME "win")
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
	include_directories("$ENV{JAVA_HOME}/include/linux")
	set(SYSNAME "linux")

	# Set compiler flags for musl compatibility
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_GNU_SOURCE -D__MUSL__")

	# For musl libc, ensure we're linking properly
	if(DEFINED MUSL_BUILD)
	  # Don't use -static-libgcc when building shared library
	  # set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static-libgcc")
	endif()
else()
	include_directories("$ENV{JAVA_HOME}/include/darwin")
	set(SYSNAME "darwin")
endif()

# MSVC specific settings
if ("${CMAKE_C_COMPILER_ID}" STREQUAL "MSVC")
	add_definitions(-Dinline=__inline)
	set(CMAKE_C_FLAGS_RELEASE "/MT")
endif()

# Include Java headers
include_directories("$ENV{JAVA_HOME}/include/")

# Add library target
add_library(udpqueue SHARED
  udpqueue.c
  hashmap.c hashmap.h
  linked.c linked.h
  timing.h mutex.h
  ${SYSNAME}/timing.c
  ${SYSNAME}/mutex.c
)

# Link with winsock2 on Windows
if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	target_link_libraries(udpqueue ws2_32)
endif()

# For Linux with musl, add additional options
if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  # Add any specific musl linking options here if needed
  target_link_libraries(udpqueue pthread)  # Ensure pthread is linked
endif()
