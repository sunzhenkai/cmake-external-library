get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
string(TOUPPER ${_DEP_NAME} _DEP_UNAME)

# template variables
set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_NEED_REBUILD TRUE)
set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})

set(_DEP_VER 1_0_2o)
if (DEFINED ENV{OSS_URL})
    set(_DEP_URL $ENV{OSS_URL}/${_DEP_NAME}-OpenSSL_${_DEP_VER}.tar.gz)
else ()
    set(_DEP_URL https://github.com/${_DEP_NAME}/${_DEP_NAME}/archive/OpenSSL_${_DEP_VER}.tar.gz)
endif ()

SetDepPrefix()
CheckVersion()
message(STATUS "${_DEP_UNAME}: _NEED_REBUILD=${_NEED_REBUILD}, _DEP_PREFIX=${_DEP_PREFIX}, "
        "CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}")

set(_DEP_NAME_INSTALL_CHECK "libcrypto.a")
if ((${_NEED_REBUILD}) OR (NOT EXISTS ${_DEP_PREFIX}/lib/${_DEP_NAME_INSTALL_CHECK}))
    DownloadDep()
    ExtractDep()
    Configure()
    MakeBuild()
    MakeInstall()
endif ()

SetDepPath()
message(STATUS "${_DEP_NAME}: ${_DEP_UNAME}_LIB_DIR=${${_DEP_UNAME}_LIB_DIR}, "
        "${_DEP_UNAME}_INCLUDE_DIR=${${_DEP_UNAME}_INCLUDE_DIR}")
AppendCMakePrefix()
set(OPENSSL_ROOT_DIR ${_DEP_PREFIX})
find_package(OpenSSL)

message(STATUS "Found openssl ${OPENSSL_ROOT_DIR}")
if (NOT DEFINED OPENSSL_ROOT_DIR)
    message(FATAL_ERROR "Openssl not found, CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}")
endif ()

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