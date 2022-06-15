include(${CMAKE_CURRENT_LIST_DIR}/../gflags/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../leveldb/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../thrift/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../boost/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../snappy/check.cmake)

get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
string(TOUPPER ${_DEP_NAME} _DEP_UNAME)

# template variables
set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_NEED_REBUILD TRUE)
set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})

set(_DEP_VER s.1.0.2)
if (DEFINED ENV{OSS_URL})
    set(_DEP_URL $ENV{OSS_URL}/incubator-${_DEP_NAME}-${_DEP_VER}.tar.gz)
else ()
    set(_DEP_URL https://codeload.github.com/sunzhenkai/incubator-brpc/tar.gz/refs/tags/${_DEP_VER})
#    set(_DEP_URL https://codeload.github.com/apache/incubator-brpc/tar.gz/refs/tags/${_DEP_VER})
endif ()

SetDepPrefix()
CheckVersion()
message(STATUS "${_DEP_UNAME}: _NEED_REBUILD=${_NEED_REBUILD}, _DEP_PREFIX=${_DEP_PREFIX}, "
        "CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}")

ExistsLib()
if ((${_NEED_REBUILD}) OR (${_LIB_DOES_NOT_EXISTS}))
    DownloadDep()
    ExtractDep()
    set(_EXTRA_DEFINE -DWITH_THRIFT=ON -DWITH_BOOST=ON -DTHRIFT_INCLUDE_DIR=${THRIFT_INCLUDE_DIR})
    CMakeNinja()
    NinjaBuild()
    NinjaInstall()
    #    execute_process(
    #            COMMAND bash config_brpc.sh --headers="${THRIFT_PREFIX}/include ${GFLAGS_PREFIX}/include ${LEVELDB_PREFIX}/include" --libs="${THRIFT_PREFIX}/lib ${GFLAGS_PREFIX}/lib ${LEVELDB_PREFIX}/lib"
    #            WORKING_DIRECTORY "${_DEP_CUR_DIR}/src"
    #            RESULT_VARIABLE rc)
    #    MakeBuild()
endif ()

SetDepPath()
AppendCMakePrefix()

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
unset(_MAKE_BUILD_EXTRA_DEFINE)
unset(_CMAKE_INSTALL_EXTRA_DEFINE)