include(${CMAKE_CURRENT_LIST_DIR}/../check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../boost/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../fmt/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../c-ares/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../yaml-cpp/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../cryptopp/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../protobuf/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../openssl/check.cmake)

function(Process)
    # 19.06 aa46d84646b381da03dd9126015292686bd078da
    # 20.05 59f7b32d892191bfae336afcdf6a6d4bd236c183
    PrepareDep(aa46d84646b381da03dd9126015292686bd078da MODULES seastar)
    #    execute_process(
    #            COMMAND env
    #            sudo ./install-dependencies.sh
    #            WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
    #            RESULT_VARIABLE rc)
    set(CMAKE_CXX_FLAGS "-lstdc++fs -Wno-error=ignored-qualifiers ${CMAKE_CXX_FLAGS}")
    set(NINJA_DEFINE -DSeastar_APPS=OFF
            -DSeastar_DEMOS=OFF
            -DSeastar_DOCS=OFF
            -DSeastar_EXCLUDE_TESTS_FROM_ALL=ON
            -DSeastar_CXX_DIALECT=c++${CMAKE_CXX_STANDARD}
            -DSeastar_GCC6_CONCEPTS=ON
            -DSeastar_NUMA=OFF
            -DSeastar_HWLOC=OFF
            -DSeastar_STD_OPTIONAL_VARIANT_STRINGVIEW=ON
            -DSeastar_TESTING=OFF
            -DProtobuf_USE_STATIC_LIBS=ON
            -DBOOST_ROOT=${BOOST_ROOT}
            -DSeastar_COMPRESS_DEBUG=OFF
            -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
            -DCMAKE_BUILD_TYPE=RelWithDebInfo)
    DownloadDep(GIT_REPOSITORY https://github.com/scylladb/seastar.git
            SPEED_UP_FILE seastar-submodule-${_DEP_VER}.tar.gz)
    Ninja(BUILD_TYPE RelWithDebInfo ARGS ${NINJA_DEFINE})
    PostProcess()
endfunction(Process)
Process()
ProcessAddLibrary(
        COMPILE_OPTIONS "-std=c++17;-U_FORTIFY_SOURCE;-Wno-maybe-uninitialized;-Wno-error=unused-result"
        LINK_LIBRARIES "Boost::boost;Boost::program_options;Boost::thread;c-ares::c-ares;cryptopp::cryptopp;fmt::fmt;lz4::lz4;\$<LINK_ONLY:dl>;\$<LINK_ONLY:Boost::filesystem>;\$<LINK_ONLY:GnuTLS::gnutls>;\$<LINK_ONLY:StdAtomic::atomic>;\$<LINK_ONLY:StdFilesystem::filesystem>;\$<LINK_ONLY:lksctp-tools::lksctp-tools>;\$<LINK_ONLY:protobuf::libprotobuf>;\$<LINK_ONLY:rt::rt>;\$<LINK_ONLY:yaml-cpp::yaml-cpp>;Concepts::concepts;\$<LINK_ONLY:LinuxMembarrier::membarrier>"
)