include(${CMAKE_CURRENT_LIST_DIR}/../boost/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../fmt/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../c-ares/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../yaml-cpp/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../cryptopp/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../protobuf/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../openssl/check.cmake)

function(Process)
    PrepareDeps(1433623962e6abca03dd23ebd1909f9b1a4fce2a MODULES seastar)
#    execute_process(
#            COMMAND env
#            sudo ./install-dependencies.sh
#            WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
#            RESULT_VARIABLE rc)
    set(CMAKE_CXX_FLAGS "-lstdc++fs -Wno-error ${CMAKE_CXX_FLAGS}")
    set(NINJA_DEFINE -DSeastar_APPS=OFF
            -DSeastar_DEMOS=OFF
            -DSeastar_DOCS=OFF
            -DSeastar_EXCLUDE_TESTS_FROM_ALL=ON
            -DSeastar_NUMA=OFF
            -DSeastar_HWLOC=OFF
            -DSeastar_STD_OPTIONAL_VARIANT_STRINGVIEW=ON
            -DSeastar_TESTING=OFF
            -DProtobuf_USE_STATIC_LIBS=ON
            -DBOOST_ROOT=${BOOST_ROOT}
            -DSeastar_COMPRESS_DEBUG=OFF
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS})
    AddProject(
            GIT_REPOSITORY https://github.com/scylladb/seastar.git
            OSS_FILE seastar-submodule-${_DEP_VER}.tar.gz
            #            CONFIGURE_DEFINE --mod=release
            NINJA_EXTRA_DEFINE ${NINJA_DEFINE}
            #            CONFIGURE
            NINJA
    )
endfunction(Process)
Process()
