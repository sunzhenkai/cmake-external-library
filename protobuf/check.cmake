get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
string(TOUPPER ${_DEP_NAME} _DEP_UNAME)

# template variables
set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_NEED_REBUILD TRUE)
set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})

set(_DEP_VER 3.9.1)
set(_DEP_URL https://github.com/google/${_DEP_NAME}/releases/download/v${_DEP_VER}/${_DEP_NAME}-all-${_DEP_VER}.tar.gz)

SetDepPrefix()
CheckVersion()
message(STATUS "${_DEP_UNAME}: _NEED_REBUILD=${_NEED_REBUILD}, _DEP_PREFIX=${_DEP_PREFIX}")

set(_DEP_NAME_INSTALL_CHECK "lib${_DEP_NAME}.a")
if ((${_NEED_REBUILD}) OR (NOT EXISTS ${_DEP_PREFIX}/lib/${_DEP_NAME_INSTALL_CHECK}))
    DownloadDep()
    ExtractDep()
    Autogen()
    set(_EXTRA_DEFINE --enable-shared=no)
    Configure()
    set(_BUILD_LIB_DIR ".libs")
    MakeBuild()
    MakeInstall()
endif ()

SetDepPath()
message(STATUS "${_DEP_NAME}: ${_DEP_UNAME}_LIB_DIR=${${_DEP_UNAME}_LIB_DIR}, "
        "${_DEP_UNAME}_INCLUDE_DIR=${${_DEP_UNAME}_INCLUDE_DIR}")

message(STATUS "${_DEP_NAME} LIB_DIR: ${_DEP_LIB_DIR}")

AppendCMakePrefix()
set(Protobuf_USE_STATIC_LIBS ON)
find_package(Protobuf REQUIRED)

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