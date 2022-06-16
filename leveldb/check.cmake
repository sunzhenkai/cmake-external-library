get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
string(TOUPPER ${_DEP_NAME} _DEP_UNAME)

# template variables
set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_NEED_REBUILD TRUE)
set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})

#set(_DEP_VER 1.23)
#if (DEFINED ENV{SPEED_UP_URL})
#    set(_DEP_URL $ENV{SPEED_UP_URL}/${_DEP_NAME}-${_DEP_VER}.tar.gz)
#else ()
#    set(_DEP_URL https://codeload.github.com/google/${_DEP_NAME}/tar.gz/refs/tags/${_DEP_VER})
#endif ()
set(_DEP_VER 99b3c03b3284f5886f9ef9a4ef703d57373e61be)
set(_DEP_URL https://gitee.com/mirrors/Leveldb.git)

SetDepPrefix()
CheckVersion()
message(STATUS "${_DEP_UNAME}: _NEED_REBUILD=${_NEED_REBUILD}, _DEP_PREFIX=${_DEP_PREFIX}, "
        "CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}")

ExistsLib()
if ((${_NEED_REBUILD}) OR (${_LIB_DOES_NOT_EXISTS}))
    if (DEFINED ENV{SPEED_UP_URL})
        set(_DEP_VER 1.23)
        set(_DEP_URL $ENV{SPEED_UP_URL}/submodule-${_DEP_NAME}-${_DEP_VER}.tar.gz)
        DownloadDep()
        ExtractDep()
    else()
        GitClone()
    endif()
    CMakeNinja()
    NinjaBuild()
    NinjaInstall()
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