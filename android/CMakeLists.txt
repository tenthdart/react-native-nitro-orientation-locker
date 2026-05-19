project(NitroOrientationLocker)
cmake_minimum_required(VERSION 3.9.0)

set(PACKAGE_NAME NitroOrientationLocker)
set(CMAKE_CXX_STANDARD 20)

include(${CMAKE_SOURCE_DIR}/../nitrogen/generated/android/NitroOrientationLocker+autolinking.cmake)

add_library(${PACKAGE_NAME} SHARED ${NitroOrientationLocker_SOURCES_AUTOLINKED})

target_include_directories(${PACKAGE_NAME} PRIVATE ${NitroOrientationLocker_INCLUDES_AUTOLINKED})

target_link_libraries(${PACKAGE_NAME} ${NitroOrientationLocker_LIBS_AUTOLINKED})
