get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
string(TOUPPER ${_DEP_NAME} _DEP_UNAME)

# template variables
set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_NEED_REBUILD TRUE)
set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})

set(_DEP_VER 2.1.12)
if (DEFINED ENV{OSS_URL})
    set(_DEP_URL $ENV{OSS_URL}/${_DEP_NAME}-release-${_DEP_VER}-stable.tar.gz)
else ()
    set(_DEP_URL https://codeload.github.com/${_DEP_NAME}/${_DEP_NAME}/tar.gz/refs/tags/release-${_DEP_VER}-stable)
endif ()

SetDepPrefix()
CheckVersion()
message(STATUS "${_DEP_UNAME}: _NEED_REBUILD=${_NEED_REBUILD}, _DEP_PREFIX=${_DEP_PREFIX}, "
        "CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}")

if ((${_NEED_REBUILD}) OR (NOT EXISTS ${_DEP_PREFIX}/lib/lib${_DEP_NAME}.a))
    DownloadDep()
    ExtractDep()
    set(_EXTRA_DEFINE -DEVENT__LIBRARY_TYPE=STATIC)
    CMakeNinja()
    NinjaBuild()
endif ()

SetDepPath()
AppendCMakePrefix()

find_library(libevent REQUIRED)

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