get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
string(TOUPPER ${_DEP_NAME} _DEP_UNAME)

# template variables
set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_NEED_REBUILD TRUE)
set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})

set(_DEP_VER 1.18.1)
string(REPLACE "." "_" _DEP_VER_ "${_DEP_VER}")
if (DEFINED ENV{OSS_URL})
    set(_DEP_URL $ENV{OSS_URL}/${_DEP_NAME}-cares-${_DEP_VER_}.tar.gz)
else ()
    set(_DEP_URL https://codeload.github.com/${_DEP_NAME}/${_DEP_NAME}/tar.gz/refs/tags/cares-${_DEP_VER_})
endif ()

SetDepPrefix()
CheckVersion()
message(STATUS "${_DEP_UNAME}: _NEED_REBUILD=${_NEED_REBUILD}, _DEP_PREFIX=${_DEP_PREFIX}, "
        "CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}")


set(_DEP_NAME_INSTALL_CHECK "libcares.a")
if ((${_NEED_REBUILD}) OR (NOT EXISTS ${_DEP_PREFIX}/lib/${_DEP_NAME_INSTALL_CHECK}))
    DownloadDep()
    ExtractDep()
    BuildConf()
    set(_EXTRA_DEFINE --enable-shared=no --enable-static=yes)
    Configure()
    MakeBuild()
    MakeInstall()
endif ()

SetDepPath()
message(STATUS "${_DEP_NAME}: ${_DEP_UNAME}_LIB_DIR=${${_DEP_UNAME}_LIB_DIR}, "
        "${_DEP_UNAME}_INCLUDE_DIR=${${_DEP_UNAME}_INCLUDE_DIR}")
AppendCMakePrefix()

set(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:${_DEP_PREFIX}/lib/pkgconfig/")
set(CARES_PKG_CONFIG_PATH ${_DEP_PREFIX}/lib/pkgconfig/)

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