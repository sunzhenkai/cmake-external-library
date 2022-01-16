include(${CMAKE_CURRENT_LIST_DIR}/../boost/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../openssl/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../libevent/check.cmake)

get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
string(TOUPPER ${_DEP_NAME} _DEP_UNAME)

# template variables
set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_NEED_REBUILD TRUE)
set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})

#set(_DEP_VER 0.14.2)
set(_DEP_VER 0.11.0)
#set(_DEP_VER 0.9.3.1)
#set(_DEP_VER 0.15.0)
if (DEFINED ENV{OSS_URL})
    set(_DEP_URL $ENV{OSS_URL}/${_DEP_NAME}-${_DEP_VER}.tar.gz)
else ()
    set(_DEP_URL https://codeload.github.com/apache/${_DEP_NAME}/tar.gz/refs/tags/v${_DEP_VER})
endif ()

SetDepPrefix()
CheckVersion()
message(STATUS "${_DEP_UNAME}: _NEED_REBUILD=${_NEED_REBUILD}, _DEP_PREFIX=${_DEP_PREFIX}, "
        "CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}")

if ((${_NEED_REBUILD}) OR (NOT EXISTS ${_DEP_PREFIX}/lib/lib${_DEP_NAME}.a))
    DownloadDep()
    ExtractDep()
    message(STATUS "Build thrift with LIBEVENT_PREFIX=${LIBEVENT_PREFIX}, OPENSSL_PREFIX=${OPENSSL_PREFIX}, "
            "BOOST_PREFIX=${BOOST_PREFIX}")
    # if you configure with --with-cpp, but don't pass the defines, that won't trigger exception. It's weird.
    set(_EXTRA_DEFINE
            --without-python
            --without-py3
            --with-cpp
            --with-libevent=${LIBEVENT_PREFIX}
            --with-openssl=${OPENSSL_PREFIX}
            --with-boost=${BOOST_PREFIX}
            --enable-shared=no
            --enable-tests=no
            --enable-tutorial=no
            )
    Bootstrap()
    Configure()
    MakeBuild()
    MakeInstall()
endif ()

SetDepPath()
AppendCMakePrefix()

#set(_FIND_STATIC_LIBRARY_EXTRA
#        "INTERFACE_COMPILE_DEFINITIONS \"FORCE_BOOST_SMART_PTR;FORCE_BOOST_FUNCTIONAL\"")
#FindStaticLibrary()
#set(_DEP_NAME_SPACE thriftz)
#FindStaticLibrary()

#find_path(THRIFT_INCLUDE_DIR
#        thrift/Thrift.h
#        HINTS
#        ${_DEP_PREFIX}/include
#        )
#
#find_path(THRIFT_STATIC_LIB_PATH libthrift.a PATHS ${_DEP_LIB_DIR})
#find_library(THRIFT_LIB NAMES thrift HINTS ${_DEP_LIB_DIR})
#
#set(THRIFT_LIBS ${THRIFT_LIB})
#set(THRIFT_STATIC_LIB ${THRIFT_STATIC_LIB_PATH}/libthrift.a)
#add_library(thrift STATIC IMPORTED)
#set_target_properties(thrift PROPERTIES IMPORTED_LOCATION ${THRIFT_STATIC_LIB})
#
#mark_as_advanced(
#        THRIFT_LIB
#        THRIFT_COMPILER
#        THRIFT_INCLUDE_DIR
#        thrift
#)

#if (NOT TARGET Thrift AND EXISTS ${_DEP_LIB_DIR}/libthrift.a)
#    message(STATUS "Add library thrift")
#    add_library(Thrift STATIC IMPORTED)
#    set_target_properties(Thrift PROPERTIES
#            IMPORTED_LOCATION "${_DEP_LIB_DIR}/libthrift.a"
#            INTERFACE_COMPILE_DEFINITIONS "FORCE_BOOST_SMART_PTR;FORCE_BOOST_FUNCTIONAL"
#            INTERFACE_INCLUDE_DIRECTORIES "${_DEP_INCLUDE_DIR}")
#endif ()

#find_path(THRIFT_INCLUDE_DIR
#        NAMES thrift/Thrift.h
#        HINTS ${_DEP_PREFIX}
#        PATH_SUFFIXES include
#        )
#
#find_library(THRIFT_LIBRARIES
#        NAMES thrift libthrift
#        HINTS ${_DEP_PREFIX}
#        PATH_SUFFIXES lib lib64
#        )
#
#find_program(THRIFT_COMPILER
#        NAMES thrift
#        HINTS ${_DEP_PREFIX}
#        PATH_SUFFIXES bin bin64
#        )
#
#if (THRIFT_COMPILER)
#    exec_program(${THRIFT_COMPILER}
#            ARGS -version OUTPUT_VARIABLE __thrift_OUT RETURN_VALUE THRIFT_RETURN)
#    string(REGEX MATCH "[0-9]+.[0-9]+.[0-9]+-[a-z]+$" THRIFT_VERSION_STRING ${__thrift_OUT})
#endif ()
#set(THRIFT_VERSION_STRING ${_DEP_VER})
#include(FindPackageHandleStandardArgs)
#FIND_PACKAGE_HANDLE_STANDARD_ARGS(THRIFT DEFAULT_MSG THRIFT_LIBRARIES THRIFT_INCLUDE_DIR THRIFT_COMPILER)
#mark_as_advanced(THRIFT_LIBRARIES THRIFT_INCLUDE_DIR THRIFT_COMPILER THRIFT_VERSION_STRING)
#set(THRIFT_FILES ${THRIFT})

find_library(thrift REQUIRED CONFIG)
find_library(thriftz thriftz REQUIRED CONFIG)
find_library(thriftnb thriftnb REQUIRED CONFIG)
set(THRIFT_LIB thrift)
set(THRIFTNB_LIB thriftnb)
message(STATUS "check thrift. [thrift=${thrift}, thriftz=${thriftz}, thriftnb=${thriftnb}, "
        "CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}, thrift_INCLUDE_DIR=${thrift_INCLUDE_DIR}, "
        "THRIFT_INCLUDE_DIR=${THRIFT_INCLUDE_DIR}]")

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
unset(_CMAKE_BUILD_EXTRA_DEFINE)
unset(_CMAKE_INSTALL_EXTRA_DEFINE)
unset(_FIND_STATIC_LIBRARY_EXTRA)
