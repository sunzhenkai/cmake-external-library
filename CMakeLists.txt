PROJECT(cmake-external-library)
CMAKE_MINIMUM_REQUIRED(VERSION 3.16)

IF (NOT CMAKE_BUILD_TYPE)
    SET(CMAKE_BUILD_TYPE RelWithDebInfo
            CACHE STRING "Choose the type of build : None Debug Release RelWithDebInfo Asan Pprof."
            FORCE)
ENDIF (NOT CMAKE_BUILD_TYPE)

SET(CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE}" CACHE STRING
        "Choose the type of build, options are: None Debug Release RelWithDebInfo Asan Pprof."
        FORCE)
message("* Current build type is : ${CMAKE_BUILD_TYPE}")

SET(CMAKE_CXX_FLAGS_ASAN "-O2 -g -fsanitize=address -fno-omit-frame-pointer" CACHE STRING
        "Flags used by the C++ compiler during asan builds."
        FORCE)
SET(CMAKE_C_FLAGS_ASAN "-O2 -g -fsanitize=address -fno-omit-frame-pointer" CACHE STRING
        "Flags used by the C compiler during asan builds."
        FORCE)
SET(CMAKE_EXE_LINKER_FLAGS_ASAN
        "-static-libasan" CACHE STRING
        "Flags used for linking binaries during asan builds."
        FORCE)
MARK_AS_ADVANCED(
        CMAKE_CXX_FLAGS_ASAN
        CMAKE_C_FLAGS_ASAN
        CMAKE_EXE_LINKER_FLAGS_ASAN)

#set(CMAKE_CXX_STANDARD 17)
#set(CMAKE_CXX_STANDARD_REQUIRED ON)
#SET(CMAKE_CXX_FLAGS "-fPIC -w -g -pthread -std=gnu++17 -fno-omit-frame-pointer")
#SET(CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS})
#SET(CMAKE_CXX_FLAGS_RELEASE "-fPIC -w -g -pthread -O2 -std=gnu++17 -fno-omit-frame-pointer")

include(${CMAKE_CURRENT_LIST_DIR}/utils.cmake)
set(CHECK_FILE "check.cmake")
set(LIBRARIES
        fmt
        protobuf
        boost
        yaml-cpp
        openssl
        cryptopp
        c-ares
        lz4
        #        valgrind
        seastar
        gflags
        leveldb
        libevent
        thrift
        flatbuffers
        snappy
        brpc
        curl
        spdlog
        )

set(BUILD_EXTERNAL_LIBRARY FALSE)

include(${CMAKE_CURRENT_LIST_DIR}/openssl/${CHECK_FILE})
include(${CMAKE_CURRENT_LIST_DIR}/spdlog/${CHECK_FILE})
include(${CMAKE_CURRENT_LIST_DIR}/curl/${CHECK_FILE})


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