cmake_minimum_required(VERSION 3.0)

project(root C)

# Add compiler flags for musl compatibility
if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_GNU_SOURCE -D__MUSL__")
  # We're building a shared library, so don't use static linking
  # set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")
  # set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -static")
endif()

add_subdirectory(udpqueue)
