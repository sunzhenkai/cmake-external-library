PROJECT(cmake-external-library)
CMAKE_MINIMUM_REQUIRED(VERSION 3.16)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_CXX_FLAGS "-fPIC -w -g -pthread -std=gnu++17 -fno-omit-frame-pointer")
SET(CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS})
SET(CMAKE_CXX_FLAGS_RELEASE "-fPIC -w -g -pthread -O2 -std=gnu++17 -fno-omit-frame-pointer")

include(${CMAKE_CURRENT_LIST_DIR}/utils.cmake)
set(CHECK_FILE "check.cmake")
set(LIBRARIES
        fmt
        protobuf
        boost
        yaml-cpp
        openssl
        cryptopp
        seastar
        gflags
        leveldb
        libevent
        thrift
        flatbuffers
        brpc
        )

set(BUILD_EXTERNAL_LIBRARY TRUE)

# disable build library
set(BUILD_DPDK FALSE)

message(STATUS "OSS speed up url: $ENV{OSS_URL}")

if (${BUILD_EXTERNAL_LIBRARY})
    message(STATUS "build external library")
    foreach (LIBRARY IN LISTS LIBRARIES)
        string(TOUPPER ${LIBRARY} UPPER_LIBRARY)
        if ((NOT DEFINED BUILD_${UPPER_LIBRARY}) OR (${BUILD_${UPPER_LIBRARY}}))
            message(STATUS "begin to build library ${LIBRARY}")
            include(${CMAKE_CURRENT_LIST_DIR}/${LIBRARY}/${CHECK_FILE})
        else ()
            message(STATUS "skip build library ${LIBRARY}")
        endif ()
    endforeach ()
endif ()