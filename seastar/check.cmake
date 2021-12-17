include(${CMAKE_CURRENT_LIST_DIR}/../boost/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../fmt/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../protobuf/check.cmake)

get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
string(TOUPPER ${_DEP_NAME} _DEP_UNAME)

# template variables
set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_NEED_REBUILD TRUE)
set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})

set(_DEP_VER 20.05)
set(_DEP_URL https://codeload.github.com/sunzhenkai/seastar/tar.gz/refs/tags/${_DEP_VER})

SetDepPrefix()
CheckVersion()
message(STATUS "${_DEP_UNAME}: _NEED_REBUILD=${_NEED_REBUILD}, _DEP_PREFIX=${_DEP_PREFIX}")

set(_DEP_NAME_INSTALL_CHECK "lib${_DEP_NAME}.a")
if ((${_NEED_REBUILD}) OR (NOT EXISTS ${_DEP_PREFIX}/lib/${_DEP_NAME_INSTALL_CHECK}))
    DownloadDep()
    ExtractDep()
    set(_EXTRA_DEFINE -DSeastar_APPS=OFF
            -DSeastar_DEMOS=OFF
            -DSeastar_DOCS=OFF
            -DSeastar_EXCLUDE_TESTS_FROM_ALL=ON
            -DSeastar_NUMA=OFF
            -DSeastar_HWLOC=OFF
            -DSeastar_STD_OPTIONAL_VARIANT_STRINGVIEW=ON
            -DSeastar_TESTING=OFF
            -DProtobuf_USE_STATIC_LIBS=ON
            -DBOOST_ROOT=${BOOST_ROOT}
            -DSeastar_COMPRESS_DEBUG=OFF)
    CMakeNinja()
    NinjaBuild()
    NinjaInstall()
endif ()

SetDepPath()
message(STATUS "${_DEP_NAME}: ${_DEP_UNAME}_LIB_DIR=${${_DEP_UNAME}_LIB_DIR}, "
        "${_DEP_UNAME}_INCLUDE_DIR=${${_DEP_UNAME}_INCLUDE_DIR}")

set(_FIND_DEP_NAME Seastar)
FindStaticLibrary()

unset(_DEP_NAME)
unset(_DEP_UNAME)
unset(_DEP_VER)
unset(_DEP_PREFIX)
unset(_NEED_REBUILD)
unset(_DEP_CUR_DIR)
unset(_DEP_BIN_DIR)
unset(_DEP_LIB_DIR)
unset(_DEP_INCLUDE_DIR)
unset(_DEP_NAME_SPACE)
unset(_DEP_NAME_INSTALL_CHECK)
unset(_EXTRA_DEFINE)