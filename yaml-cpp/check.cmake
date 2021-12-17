get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
string(TOUPPER ${_DEP_NAME} _DEP_UNAME)

# template variables
set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_NEED_REBUILD TRUE)
set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})

set(_DEP_VER 0.6.2)
set(_DEP_URL https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-${_DEP_VER}.tar.gz)

SetDepPrefix()
CheckVersion()
message(STATUS "${_DEP_UNAME}: _NEED_REBUILD=${_NEED_REBUILD}, _DEP_PREFIX=${_DEP_PREFIX}")

set(_DEP_NAME_INSTALL_CHECK "lib${_DEP_NAME}.a")
if ((${_NEED_REBUILD}) OR (NOT EXISTS ${_DEP_PREFIX}/lib/${_DEP_NAME_INSTALL_CHECK}))
    DownloadDep()
    ExtractDep()
    set(_EXTRA_DEFINE -DYAML_CPP_BUILD_TESTS=OFF
            -DYAML_CPP_BUILD_TOOLS=OFF)
    CMakeNinja()
    NinjaBuild()
    NinjaInstall()
endif()

SetDepPath()
set(yaml-cpp_LIBRARY ${_DEP_LIB_DIR}/libyaml-cpp.a CACHE FILEPATH "" FORCE)
set(yaml-cpp_INCLUDE_DIR ${_DEP_INCLUDE_DIR} CACHE PATH "" FORCE)
SetDepPrefix()
find_package(yaml-cpp REQUIRED CONFIG)

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