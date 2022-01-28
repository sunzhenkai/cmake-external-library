get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
string(TOUPPER ${_DEP_NAME} _DEP_UNAME)

# template variables
set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_NEED_REBUILD TRUE)
set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})

#set(_DEP_VER 1.1.9)
#if (DEFINED ENV{OSS_URL})
#    set(_DEP_URL $ENV{OSS_URL}/${_DEP_NAME}-${_DEP_VER}.tar.gz)
#else ()
#    set(_DEP_URL https://codeload.github.com/google/${_DEP_NAME}/tar.gz/refs/tags/${_DEP_VER})
#endif ()

set(_DEP_VER 2b63814b15a2aaae54b7943f0cd935892fae628f)
set(_DEP_URL https://gitee.com/mirrors/Snappy.git)

SetDepPrefix()
CheckVersion()
message(STATUS "${_DEP_UNAME}: _NEED_REBUILD=${_NEED_REBUILD}, _DEP_PREFIX=${_DEP_PREFIX}, "
        "CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}")

ExistsLib()
if ((${_NEED_REBUILD}) OR (${_LIB_DOES_NOT_EXISTS}))
    GitClone()
    ExtractDep()
    set(_CMAKE_BUILD_EXTRA_DEFINE
            -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -Wno-error
            -DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE} -Wno-error
            )
    set(_EXTRA_DEFINE -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_STATIC_LINKER_FLAGS=${CMAKE_STATIC_LINKER_FLAGS} -Wno-error -Wno-attributes
            -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -Wno-error -Wno-attributes
            )
    set(_PIC_OFF ON)
    CMakeNinja()
    NinjaBuild()
    NinjaInstall()
endif ()

SetDepPath()
AppendCMakePrefix()

message(STATUS "Find snappy. [CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}]")
find_package(Snappy REQUIRED)
#include_directories(${Snappy_INCLUDE_DIRS})
#find_library(snappy snappy REQUIRED)
#find_path(Snappy_INCLUDE_DIR NAMES snappy.h
#        PATHS ${SNAPPY_ROOT_DIR} ${SNAPPY_ROOT_DIR}/include)
#
#find_library(Snappy_LIBRARIES NAMES snappy
#        PATHS ${SNAPPY_ROOT_DIR} ${SNAPPY_ROOT_DIR}/lib)
#
#include(FindPackageHandleStandardArgs)
#find_package_handle_standard_args(Snappy DEFAULT_MSG Snappy_INCLUDE_DIR Snappy_LIBRARIES)
message(STATUS "Find snappy result, external. [Snappy_FOUND=${Snappy_FOUND}, Snappy_INCLUDE_DIRS=${Snappy_INCLUDE_DIRS},"
        "Snappy_LIBRARIES=${Snappy_LIBRARIES}]")
if (NOT Snappy_FOUND)
    message(FATAL_ERROR "Snappy not found.")
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
unset(_CMAKE_BUILD_EXTRA_DEFINE)
unset(_PIC_OFF)