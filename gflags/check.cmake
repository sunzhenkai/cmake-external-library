get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
string(TOUPPER ${_DEP_NAME} _DEP_UNAME)

#set(_DEP_VER 6.2.1)
set(_DEP_VER 2.2.2)
if (DEFINED ENV{OSS_URL})
    set(_DEP_URL $ENV{OSS_URL}/${_DEP_NAME}-${_DEP_VER}.tar.gz)
else ()
    set(_DEP_URL https://codeload.github.com/${_DEP_NAME}/${_DEP_NAME}/tar.gz/refs/tags/v${_DEP_VER})
endif ()

# template variables
set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_NEED_REBUILD TRUE)
set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})

SetDepPrefix()
CheckVersion()
message(STATUS "${_DEP_UNAME}: _NEED_REBUILD=${_NEED_REBUILD}, _DEP_PREFIX=${_DEP_PREFIX}")

if ((${_NEED_REBUILD}) OR (NOT EXISTS ${_DEP_PREFIX}/lib/lib${_DEP_NAME}.a))
    DownloadDep()
    ExtractDep()
    set(_EXTRA_DEFINE
            -DBUILD_SHARED_LIBS=ON
            -DBUILD_STATIC_LIBS=ON)
    CMakeNinja()
    NinjaBuild()
    NinjaInstall()
endif ()

SetDepPath()
AppendCMakePrefix()

message(STATUS "Find gflags. [CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}]")
find_library(gflags gflags REQUIRED)

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
unset(_EXTRA_DEFINE)