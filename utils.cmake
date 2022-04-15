function(CheckVars)
    foreach (_V IN LISTS _VARS)
        if (NOT DEFINED ${_V})
            message(FATAL_ERROR "CheckVars: not found variable ${_V}")
        endif ()
    endforeach ()
endfunction(CheckVars)

function(CheckVarsV2)
    foreach (_V IN LISTS ARGV)
        if (NOT DEFINED ${_V})
            message(FATAL_ERROR "CheckVars: not found variable ${_V}")
        endif ()
    endforeach ()
endfunction()

function(CleanDep)
    set(_VARS _DEP_CUR_DIR _DEP_PREFIX)
    CheckVars()

    if (NOT ${_DEP_CUR_DIR} STREQUAL "")
        file(REMOVE_RECURSE ${_DEP_PREFIX}/bin)
        file(REMOVE_RECURSE ${_DEP_PREFIX}/lib)
        file(REMOVE_RECURSE ${_DEP_PREFIX}/lib64)
        file(REMOVE_RECURSE ${_DEP_PREFIX}/include)
        file(REMOVE_RECURSE ${_DEP_PREFIX}/share)
        file(REMOVE_RECURSE ${_DEP_PREFIX}/doc)
        file(REMOVE_RECURSE ${_DEP_CUR_DIR}/src)
        file(REMOVE_RECURSE ${_DEP_CUR_DIR}/build)
    endif ()
endfunction()

function(CheckVersion)
    set(_VARS _DEP_VER _DEP_NAME _DEP_PREFIX _NEED_REBUILD _DEP_CUR_DIR)
    CheckVars()

    if (DEFINED _DEP_VER)
        set(NEW_VERSION ${_DEP_VER})
    else ()
        message(FATAL_ERROR "Variable _DE_VER not found")
    endif ()

    if (NOT EXISTS ${_DEP_PREFIX}/VERSION)
        message(STATUS "VERSION file not found under dir ${_DEP_PREFIX}, rebuilding ${_DEP_NAME}")
        set(_NEED_REBUILD TRUE)
    else ()
        file(STRINGS ${_DEP_PREFIX}/VERSION BUILD_VERSION)
        if ("${BUILD_VERSION}" STREQUAL "${NEW_VERSION}")
            set(_NEED_REBUILD FALSE)
        else ()
            message(STATUS "Found new version ${NEW_VERSION} against old version ${BUILD_VERSION} from dir "
                    "${_DEP_PREFIX}, rebuilding ${_DEP_NAME}")
            set(_NEED_REBUILD TRUE)
        endif ()
    endif ()
    set(_NEED_REBUILD ${_NEED_REBUILD} PARENT_SCOPE)
    if (${_NEED_REBUILD})
        CleanDep()
    endif ()
    WriteVersion()
endfunction(CheckVersion)

function(CheckVersionV2)
    CheckVarsV2(_DEP_VER _DEP_NAME _DEP_PREFIX _NEED_REBUILD _DEP_CUR_DIR)

    if (DEFINED ${${_DEP_NAME}_VERSION})
        set(_DEP_VER ${${_DEP_NAME}_VERSION})
    endif ()

    if (DEFINED _DEP_VER)
        set(NEW_VERSION ${_DEP_VER})
    else ()
        message(FATAL_ERROR "Variable _DE_VER not found")
    endif ()

    if (NOT EXISTS ${_DEP_PREFIX}/VERSION)
        message(STATUS "VERSION file not found under dir ${_DEP_PREFIX}, rebuilding ${_DEP_NAME}")
        set(_NEED_REBUILD TRUE)
    else ()
        file(STRINGS ${_DEP_PREFIX}/VERSION BUILD_VERSION)
        if ("${BUILD_VERSION}" STREQUAL "${NEW_VERSION}")
            set(_NEED_REBUILD FALSE)
        else ()
            message(STATUS "Found new version ${NEW_VERSION} against old version ${BUILD_VERSION} from dir "
                    "${_DEP_PREFIX}, rebuilding ${_DEP_NAME}")
            set(_NEED_REBUILD TRUE)
        endif ()
    endif ()
    set(_NEED_REBUILD ${_NEED_REBUILD} PARENT_SCOPE)
    if (${_NEED_REBUILD})
        CleanDep()
    endif ()
    WriteVersion()
endfunction(CheckVersionV2)

function(WriteVersion)
    set(_VARS _DEP_PREFIX _DEP_VER)
    CheckVars()

    message(STATUS "Write VERSION file. VERSION=${_DEP_VER} FILE=${_DEP_PREFIX}/VERSION")
    file(WRITE ${_DEP_PREFIX}/VERSION ${_DEP_VER})
endfunction()

function(SetDepPrefix)
    set(_VARS _DEP_UNAME _DEP_CUR_DIR _DEP_PREFIX)
    CheckVars()

    set(_DEP_PREFIX ${${_DEP_UNAME}_PREFIX})
    if ("${_DEP_PREFIX}" STREQUAL "")
        if ("${DEPS_DIR}" STREQUAL "")
            set(_DEP_PREFIX ${_DEP_CUR_DIR})
        else ()
            set(_DEP_PREFIX ${DEPS_DIR}/${_DEP_NAME})
        endif ()
        set(${_DEP_UNAME}_PREFIX ${_DEP_PREFIX})
    endif ()
    message(STATUS "${_DEP_UNAME}_PREFIX: ${_DEP_PREFIX}")
    set(_DEP_PREFIX ${_DEP_PREFIX} PARENT_SCOPE)
endfunction()

function(IsEmpty)
    set(_VARS _DIR_TO_CHECK)
    CheckVars()

    set(_DIR_TO_CHECK_SIZE 0)
    if (EXISTS ${_DIR_TO_CHECK})
        file(GLOB _SRC_DIR "${_DIR_TO_CHECK}/*")
        list(LENGTH _SRC_DIR _DIR_TO_CHECK_SIZE)
    endif ()
    set(_DIR_TO_CHECK_SIZE ${_DIR_TO_CHECK_SIZE} PARENT_SCOPE)
    #    message(STATUS "Empty check, _DIR_TO_CHECK=${_DIR_TO_CHECK}, _DIR_TO_CHECK_SIZE=${_DIR_TO_CHECK_SIZE}")
endfunction()

function(ExistsLib)
    set(_VARS _DEP_PREFIX _DEP_NAME)
    CheckVars()

    if (NOT DEFINED _DEP_NAME_INSTALL_CHECK)
        set(_DEP_NAME_INSTALL_CHECK lib${_DEP_NAME}.a)
    endif ()

    set(_T_LIB_FILE "${_DEP_PREFIX}/lib/${_DEP_NAME_INSTALL_CHECK}")
    set(_T_LIB64_FILE "${_DEP_PREFIX}/lib64/${_DEP_NAME_INSTALL_CHECK}")
    if ((EXISTS ${_T_LIB_FILE}) OR (EXISTS ${_T_LIB64_FILE}))
        set(_LIB_DOES_EXISTS TRUE PARENT_SCOPE)
        set(_LIB_DOES_NOT_EXISTS FALSE PARENT_SCOPE)
    else ()
        set(_LIB_DOES_EXISTS FALSE PARENT_SCOPE)
        set(_LIB_DOES_NOT_EXISTS TRUE PARENT_SCOPE)
    endif ()
endfunction()

function(CheckLibExists)
    CheckVars(_DEP_PREFIX _DEP_NAME)

    if (NOT DEFINED _DEP_NAME_INSTALL_CHECK)
        set(_DEP_NAME_INSTALL_CHECK lib${_DEP_NAME}.a)
    endif ()

    set(_FILES_TO_CHECK
            "${_DEP_PREFIX}/lib/${_DEP_NAME_INSTALL_CHECK}"
            "${_DEP_PREFIX}/lib64/${_DEP_NAME_INSTALL_CHECK}")

    set(_LIB_DOES_EXISTS FALSE)
    set(_LIB_DOES_NOT_EXISTS TRUE PARENT_SCOPE)

    foreach (_FILE_TO_CHECK IN LISTS _FILES_TO_CHECK)
        message(STATUS "[CheckLibExists] checking file ${_FILE_TO_CHECK}")
        if (EXISTS ${_FILE_TO_CHECK})
            set(_LIB_DOES_EXISTS TRUE)
            set(_LIB_DOES_NOT_EXISTS FALSE PARENT_SCOPE)
        endif ()
    endforeach ()
endfunction()

function(SetDepPath)
    set(_VARS _DEP_UNAME _DEP_PREFIX)
    CheckVars()

    set(${_DEP_UNAME}_PREFIX ${_DEP_PREFIX} PARENT_SCOPE)
    if (EXISTS ${_DEP_PREFIX}/bin)
        set(_DEP_BIN_DIR ${_DEP_PREFIX}/bin)
        set(_DEP_BIN_DIR ${_DEP_PREFIX}/bin PARENT_SCOPE)
        set(${_DEP_UNAME}_BIN_DIR ${_DEP_BIN_DIR} PARENT_SCOPE)
        list(APPEND _EXTERNAL_VARS ${_DEP_UNAME}_BIN_DIR)
    endif ()
    if (EXISTS ${_DEP_PREFIX}/lib)
        set(_DEP_LIB_DIR ${_DEP_PREFIX}/lib)
        set(_DEP_LIB_DIR ${_DEP_PREFIX}/lib PARENT_SCOPE)
        set(${_DEP_UNAME}_LIB_DIR ${_DEP_LIB_DIR})
        set(${_DEP_UNAME}_LIB_DIR ${_DEP_LIB_DIR} PARENT_SCOPE)
        list(APPEND _EXTERNAL_VARS ${_DEP_UNAME}_LIB_DIR)
    endif ()
    if (EXISTS ${_DEP_PREFIX}/lib64)
        set(_DEP_LIB_DIR ${_DEP_PREFIX}/lib64)
        set(_DEP_LIB_DIR ${_DEP_PREFIX}/lib64 PARENT_SCOPE)
        set(${_DEP_UNAME}_LIB_DIR ${_DEP_LIB_DIR} PARENT_SCOPE)
        list(APPEND _EXTERNAL_VARS ${_DEP_UNAME}_LIB_DIR)
    endif ()
    if (EXISTS ${_DEP_PREFIX}/include)
        set(_DEP_INCLUDE_DIR ${_DEP_PREFIX}/include)
        set(_DEP_INCLUDE_DIR ${_DEP_PREFIX}/include PARENT_SCOPE)
        set(${_DEP_UNAME}_INCLUDE_DIR ${_DEP_INCLUDE_DIR} PARENT_SCOPE)
        list(APPEND _EXTERNAL_VARS ${_DEP_UNAME}_INCLUDE_DIR)
    endif ()
    set(_EXTERNAL_VARS ${_EXTERNAL_VARS} PARENT_SCOPE)
endfunction()

function(AppendCMakePrefix)
    set(_VARS _DEP_UNAME _DEP_PREFIX)
    CheckVars()

    list(FIND CMAKE_PREFIX_PATH ${_DEP_PREFIX} _DEP_INDEX)
    if (_DEP_INDEX EQUAL -1)
        list(APPEND CMAKE_PREFIX_PATH ${_DEP_PREFIX})
        set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE)
        list(APPEND _EXTERNAL_VARS CMAKE_PREFIX_PATH)
    endif ()

    # set pkg service
    if (EXISTS ${_DEP_PREFIX}/lib/pkgconfig/)
        set(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:${_DEP_PREFIX}/lib/pkgconfig/")
    elseif (EXISTS ${_DEP_PREFIX}/lib64/pkgconfig/)
        set(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:${_DEP_PREFIX}/lib64/pkgconfig/")
    endif ()
    set(${_DEP_UNAME}_PKG_CONFIG_PATH ${_DEP_PREFIX}/lib/pkgconfig/ PARENT_SCOPE)
    list(APPEND _EXTERNAL_VARS ${_DEP_UNAME}_PKG_CONFIG_PATH)
    set(_EXTERNAL_VARS ${_EXTERNAL_VARS} PARENT_SCOPE)
endfunction()

function(FindStaticLibrary)
    set(_VARS _DEP_NAME _DEP_LIB_DIR _DEP_INCLUDE_DIR)
    CheckVars()
    if (NOT DEFINED _DEP_NAME_SPACE)
        set(_DEP_NAME_SPACE ${_DEP_NAME})
    endif ()
    if (NOT DEFINED _FIND_DEP_NAME)
        set(_FIND_DEP_NAME ${_DEP_NAME})
    endif ()

    if (${_NO_SPACE})
        set(_FINAL_FIND_DEP_NAME ${_DEP_NAME})
    else ()
        set(_FINAL_FIND_DEP_NAME ${_FIND_DEP_NAME}::${_DEP_NAME_SPACE})
    endif ()

    AppendCMakePrefix()
    set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE)

    message(STATUS "Try to add library: ${_FINAL_FIND_DEP_NAME}")
    if (NOT TARGET ${_FINAL_FIND_DEP_NAME} AND EXISTS ${_DEP_LIB_DIR}/lib${_DEP_NAME_SPACE}.a)
        message(STATUS "Add library ${_FINAL_FIND_DEP_NAME}")
        add_library(${_FINAL_FIND_DEP_NAME} STATIC IMPORTED GLOBAL)
        set_target_properties(${_FINAL_FIND_DEP_NAME} PROPERTIES
                IMPORTED_LOCATION "${_DEP_LIB_DIR}/lib${_DEP_NAME_SPACE}.a"
                ${_FIND_STATIC_LIBRARY_EXTRA}
                INTERFACE_INCLUDE_DIRECTORIES "${_DEP_INCLUDE_DIR}")
    endif ()
    message(STATUS "${${_FINAL_FIND_DEP_NAME}} ${_DEP_LIB_DIR}/lib${_DEP_NAME_SPACE}.a")
endfunction()

function(DownloadDep)
    set(_VARS _DEP_NAME _DEP_VER _DEP_CUR_DIR _DEP_URL)
    CheckVars()

    if (NOT EXISTS ${_DEP_CUR_DIR}/packages/${_DEP_NAME}-${_DEP_VER}.tar.gz)
        file(MAKE_DIRECTORY ${_DEP_CUR_DIR}/packages)
        set(_DEST_DOWNLOADING ${_DEP_CUR_DIR}/packages/${_DEP_NAME}-${_DEP_VER}.downloading)
        set(_DEST ${_DEP_CUR_DIR}/packages/${_DEP_NAME}-${_DEP_VER}.tar.gz)
        message(STATUS "Downloading ${_DEP_NAME}:${_DEP_URL}, DEST=${_DEST_DOWNLOADING}")
        execute_process(
                COMMAND wget -O ${_DEST_DOWNLOADING} ${_DEP_URL}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Downloading ${_DEP_NAME}: ${_DEP_URL} - FAIL")
        endif ()
        execute_process(
                COMMAND mv ${_DEST_DOWNLOADING} ${_DEST}
                RESULT_VARIABLE rc)
        message(STATUS "Download ${_DEP_NAME}: ${_DEP_URL} - done")
    endif ()
endfunction()

function(DownloadDepV2 _GIT_USER)
    CheckVarsV2(_DEP_NAME _DEP_VER _DEP_CUR_DIR)

    if (DEFINED ENV{OSS_URL})
        set(DEP_URL $ENV{OSS_URL}/${_DEP_NAME}-${_DEP_VER}.tar.gz)
    else ()
        set(DEP_URL https://codeload.github.com/${_GIT_USER}/${_DEP_NAME}/tar.gz/refs/tags/v${_DEP_VER})
    endif ()

    if (NOT EXISTS ${_DEP_CUR_DIR}/packages/${_DEP_NAME}-${_DEP_VER}.tar.gz)
        file(MAKE_DIRECTORY ${_DEP_CUR_DIR}/packages)
        set(_DEST_DOWNLOADING ${_DEP_CUR_DIR}/packages/${_DEP_NAME}-${_DEP_VER}.downloading)
        set(_DEST ${_DEP_CUR_DIR}/packages/${_DEP_NAME}-${_DEP_VER}.tar.gz)
        message(STATUS "Downloading ${_DEP_NAME}:${DEP_URL}, DEST=${_DEST_DOWNLOADING}")
        execute_process(
                COMMAND wget -O ${_DEST_DOWNLOADING} ${DEP_URL}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Downloading ${_DEP_NAME}: ${DEP_URL} - FAIL")
        endif ()
        execute_process(
                COMMAND mv ${_DEST_DOWNLOADING} ${_DEST}
                RESULT_VARIABLE rc)
        message(STATUS "Download ${_DEP_NAME}: ${DEP_URL} - done")
    endif ()
endfunction(DownloadDepV2)

function(DownloadDepV3 version url)
    CheckVarsV2(_DEP_NAME _DEP_CUR_DIR)

    if (NOT EXISTS ${_DEP_CUR_DIR}/packages/${_DEP_NAME}-${version}.tar.gz)
        file(MAKE_DIRECTORY ${_DEP_CUR_DIR}/packages)
        set(_DEST_DOWNLOADING ${_DEP_CUR_DIR}/packages/${_DEP_NAME}-${version}.downloading)
        set(_DEST ${_DEP_CUR_DIR}/packages/${_DEP_NAME}-${version}.tar.gz)
        message(STATUS "Downloading ${_DEP_NAME}:${url}, DEST=${_DEST_DOWNLOADING}")
        execute_process(
                COMMAND wget -O ${_DEST_DOWNLOADING} ${url}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Downloading ${_DEP_NAME}: ${url} - FAIL")
        endif ()
        execute_process(
                COMMAND mv ${_DEST_DOWNLOADING} ${_DEST}
                RESULT_VARIABLE rc)
        message(STATUS "Download ${_DEP_NAME}: ${url} - done")
    endif ()
endfunction(DownloadDepV3)

function(GitClone)
    set(_VARS _DEP_NAME _DEP_VER _DEP_CUR_DIR _DEP_URL)
    CheckVars()

    find_package(Git REQUIRED)

    set(_DIR_TO_CHECK ${_DEP_CUR_DIR}/src)
    IsEmpty()
    if (_DIR_TO_CHECK_SIZE EQUAL 0)
        message(STATUS "Cloning ${_DEP_NAME}: ${_DEP_URL}")
        execute_process(
                COMMAND "${GIT_EXECUTABLE}" clone --recurse-submodules ${_DEP_URL} src
                WORKING_DIRECTORY "${_DEP_CUR_DIR}"
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Cloning ${_DEP_NAME}: ${_DEP_URL} - FAIL")
        endif ()
        message(STATUS "Cloning ${_DEP_NAME}: ${_DEP_URL} - done")
    endif ()

    # check out commit
    message(STATUS "Checking out ${_DEP_NAME}: ${_DEP_VER}")
    execute_process(
            COMMAND git checkout ${_DEP_VER}
            WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
            RESULT_VARIABLE rc)
    if (NOT "${rc}" STREQUAL "0")
        message(FATAL_ERROR "Checking out ${_DEP_NAME}: ${_DEP_VER} - FAIL")
    endif ()
    message(STATUS "Checking out ${_DEP_NAME}: ${_DEP_VER} - done")
endfunction()

function(GitCloneV2 repository version)
    CheckVars(_DEP_NAME _DEP_CUR_DIR)

    find_package(Git REQUIRED)

    set(_DIR_TO_CHECK ${_DEP_CUR_DIR}/src)
    IsEmpty()
    if (_DIR_TO_CHECK_SIZE EQUAL 0)
        message(STATUS "Cloning ${_DEP_NAME}: ${repository}")
        execute_process(
                COMMAND "${GIT_EXECUTABLE}" clone --recurse-submodules ${repository} src
                WORKING_DIRECTORY "${_DEP_CUR_DIR}"
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Cloning ${_DEP_NAME}: ${repository} - FAIL")
        endif ()
        message(STATUS "Cloning ${_DEP_NAME}: ${repository} - done")
    endif ()

    # check out commit
    message(STATUS "Checking out ${_DEP_NAME}: ${version}")
    execute_process(
            COMMAND git checkout ${version}
            WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
            RESULT_VARIABLE rc)
    if (NOT "${rc}" STREQUAL "0")
        message(FATAL_ERROR "Checking out ${_DEP_NAME}: ${version} - FAIL")
    endif ()
    message(STATUS "Checking out ${_DEP_NAME}: ${version} - done")
endfunction(GitCloneV2)

function(ExtractDep)
    set(_VARS _DEP_NAME _DEP_VER _DEP_CUR_DIR)
    CheckVars()

    set(_DIR_TO_CHECK ${_DEP_CUR_DIR}/src)
    IsEmpty()
    if (_DIR_TO_CHECK_SIZE EQUAL 0)
        file(MAKE_DIRECTORY ${_DEP_CUR_DIR}/src)
        message(STATUS "Extracting ${_DEP_NAME}")
        execute_process(
                COMMAND tar -xf ${_DEP_CUR_DIR}/packages/${_DEP_NAME}-${_DEP_VER}.tar.gz
                --strip-components 1 -C ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Extracting ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Extracting ${_DEP_NAME} - done")
    endif ()
endfunction()

function(ExtractDepV2 version)
    set(_VARS _DEP_NAME _DEP_CUR_DIR)
    CheckVars()

    set(_DIR_TO_CHECK ${_DEP_CUR_DIR}/src)
    IsEmpty()
    if (_DIR_TO_CHECK_SIZE EQUAL 0)
        file(MAKE_DIRECTORY ${_DEP_CUR_DIR}/src)
        message(STATUS "Extracting ${_DEP_NAME}")
        execute_process(
                COMMAND tar -xf ${_DEP_CUR_DIR}/packages/${_DEP_NAME}-${version}.tar.gz
                --strip-components 1 -C ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Extracting ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Extracting ${_DEP_NAME} - done")
    endif ()
endfunction(ExtractDepV2)

function(CMakeNinja)
    set(_VARS _DEP_NAME _DEP_CUR_DIR _DEP_PREFIX)
    CheckVars()

    if (NOT DEFINED _BUILD_TYPE)
        set(_BUILD_TYPE Release)
    endif ()

    if (_PIC_OFF)
        set(_PIC_FLAG "-DCMAKE_POSITION_INDEPENDENT_CODE=OFF")
    else ()
        set(_PIC_FLAG "-DCMAKE_POSITION_INDEPENDENT_CODE=ON")
    endif ()
    if (NOT EXISTS ${_DEP_CUR_DIR}/build/build.ninja)
        file(MAKE_DIRECTORY ${_DEP_CUR_DIR}/build)
        string(REPLACE ";" "\\;" CMAKE_PREFIX_PATH_STR "${CMAKE_PREFIX_PATH}")
        message(STATUS "Configuring ${_DEP_NAME}, CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH}, "
                "CMAKE_PREFIX_PATH_STR ${CMAKE_PREFIX_PATH_STR}")
        execute_process(
                COMMAND ${CMAKE_COMMAND}
                -G Ninja
                -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
                -DCMAKE_BUILD_TYPE=${_BUILD_TYPE}
                -DCMAKE_INSTALL_PREFIX=${_DEP_PREFIX}
                -DBUILD_SHARED_LIBS=OFF
                -DCMAKE_INSTALL_LIBDIR=lib
                -DCMAKE_INSTALL_BINDIR=bin
                -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_STR}
                ${_PIC_FLAG}
                ${_EXTRA_DEFINE}
                ${_DEP_CUR_DIR}/src
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/build
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Configuring ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Configuring ${_DEP_NAME} - done")
    endif ()
endfunction()

function(CMakeNinjaV2)
    CheckVars(_DEP_NAME _DEP_CUR_DIR _DEP_PREFIX)
    set(options NoneOptions)
    set(oneValueArgs NoneArg)
    set(multiValueArgs NINJA_EXTRA_DEFINE)
    cmake_parse_arguments(P "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (NOT DEFINED _BUILD_TYPE)
        set(_BUILD_TYPE Release)
    endif ()

    if (_PIC_OFF)
        set(_PIC_FLAG "-DCMAKE_POSITION_INDEPENDENT_CODE=OFF")
    else ()
        set(_PIC_FLAG "-DCMAKE_POSITION_INDEPENDENT_CODE=ON")
    endif ()
    if (NOT EXISTS ${_DEP_CUR_DIR}/build/build.ninja)
        file(MAKE_DIRECTORY ${_DEP_CUR_DIR}/build)
        string(REPLACE ";" "\\;" CMAKE_PREFIX_PATH_STR "${CMAKE_PREFIX_PATH}")
        message(STATUS "Configuring ${_DEP_NAME}, CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH}, "
                "CMAKE_PREFIX_PATH_STR ${CMAKE_PREFIX_PATH_STR}")
        execute_process(
                COMMAND ${CMAKE_COMMAND}
                -G Ninja
                -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
                -DCMAKE_BUILD_TYPE=${_BUILD_TYPE}
                -DCMAKE_INSTALL_PREFIX=${_DEP_PREFIX}
                -DBUILD_SHARED_LIBS=OFF
                -DCMAKE_INSTALL_LIBDIR=lib
                -DCMAKE_INSTALL_BINDIR=bin
                -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_STR}
                ${_PIC_FLAG}
                ${P_NINJA_EXTRA_DEFINE}
                ${_DEP_CUR_DIR}/src
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/build
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Configuring ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Configuring ${_DEP_NAME} - done")
    endif ()
endfunction(CMakeNinjaV2)

function(MesonNinja)
    set(_VARS _DEP_NAME _DEP_CUR_DIR _DEP_PREFIX)
    CheckVars()

    set(_DIR_TO_CHECK ${_DEP_CUR_DIR}/build)
    IsEmpty()
    if (_DIR_TO_CHECK_SIZE EQUAL 0)
        file(MAKE_DIRECTORY ${_DEP_CUR_DIR}/build)
        message(STATUS "Configuring ${_DEP_NAME}")
        execute_process(
                COMMAND meson --prefix=${_DEP_PREFIX} ${_DEP_CUR_DIR}/build
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Configuring ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Configuring ${_DEP_NAME} - done")
    endif ()
endfunction()

function(NinjaBuild)
    set(_VARS _DEP_NAME _DEP_CUR_DIR)
    CheckVars()

    if (NOT DEFINED _DEP_NAME_BUILD_CHECK)
        set(_DEP_NAME_BUILD_CHECK lib${_DEP_NAME}.a)
    endif ()

    set(_DEP_LIB_DIR_ ${_DEP_CUR_DIR}/build/lib/${_DEP_NAME_BUILD_CHECK})
    set(_DEP_LIB64_DIR_ ${_DEP_CUR_DIR}/build/lib64/${_DEP_NAME_BUILD_CHECK})

    if ((NOT EXISTS _DEP_LIB_DIR_) AND (NOT EXISTS _DEP_LIB64_DIR_))
        message(STATUS "Building ${_DEP_NAME}")
        execute_process(
                COMMAND ninja
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/build
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Building ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Building ${_DEP_NAME} - done")
    else ()
        message(STATUS "Skip ninja build for ${_DEP_NAME}")
    endif ()
endfunction()

function(NinjaBuildV2)
    CheckVars(_DEP_NAME _DEP_CUR_DIR _DEP_BUILD_DONE)

    if (NOT DEFINED _DEP_NAME_BUILD_CHECK)
        set(_DEP_NAME_BUILD_CHECK lib${_DEP_NAME}.a)
    endif ()

    set(_DEP_LIB_DIR_ ${_DEP_CUR_DIR}/build/lib/${_DEP_NAME_BUILD_CHECK})
    set(_DEP_LIB64_DIR_ ${_DEP_CUR_DIR}/build/lib64/${_DEP_NAME_BUILD_CHECK})

    if (NOT ${_DEP_INSTALL_DONE})
        message(STATUS "Building ${_DEP_NAME}")
        execute_process(
                COMMAND ninja
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/build
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Building ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Building ${_DEP_NAME} - done")
    else ()
        message(STATUS "Skip ninja build for ${_DEP_NAME}")
    endif ()
endfunction(NinjaBuildV2)

function(NinjaInstall)
    set(_VARS _DEP_NAME _DEP_PREFIX _DEP_CUR_DIR)
    CheckVars()

    if (${_PERMISSION})
        set(_PERMISSION_ROLE "sudo")
    endif ()

    if (NOT DEFINED _DEP_NAME_INSTALL_CHECK)
        set(_DEP_NAME_INSTALL_CHECK lib${_DEP_NAME}.a)
    endif ()

    ExistsLib()
    if (${_LIB_DOES_NOT_EXISTS})
        #    if (NOT EXISTS ${_DEP_CUR_DIR}/lib/${_DEP_NAME_INSTALL_CHECK})
        message(STATUS "Installing ${_DEP_NAME}")
        execute_process(
                COMMAND ${_PERMISSION_ROLE} ninja install
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/build
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Installing ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Installing ${_DEP_NAME} - done")
    else ()
        message(STATUS "Skip ninja install for ${_DEP_NAME}")
    endif ()
endfunction()

function(NinjaInstallV2)
    CheckVars(_DEP_NAME _DEP_PREFIX _DEP_CUR_DIR)

    if (${_PERMISSION})
        set(_PERMISSION_ROLE "sudo")
    endif ()

    if (NOT ${_DEP_INSTALL_DONE})
        message(STATUS "Installing ${_DEP_NAME}")
        execute_process(
                COMMAND ${_PERMISSION_ROLE} ninja install
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/build
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Installing ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Installing ${_DEP_NAME} - done")
    else ()
        message(STATUS "Skip ninja install for ${_DEP_NAME}")
    endif ()
endfunction(NinjaInstallV2)

function(Autogen)
    set(_VARS _DEP_NAME _DEP_CUR_DIR)
    CheckVars()

    if (NOT EXISTS ${_DEP_CUR_DIR}/src/PHASE_AUTOGEN)
        message(STATUS "Autogen ${_DEP_NAME}")
        execute_process(
                COMMAND env
                CC=${CMAKE_C_COMPILER}
                CXX=${CMAKE_CXX_COMPILER}
                CFLAGS=-fPIC
                CXXFLAGS=-fPIC
                ./autogen.sh
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Autogen ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Autogen ${_DEP_NAME} - done")
        file(WRITE ${_DEP_CUR_DIR}/src/PHASE_AUTOGEN "done")
    endif ()
endfunction()

function(BuildConf)
    set(_VARS _DEP_CUR_DIR)
    CheckVars()

    execute_process(
            COMMAND env
            ./buildconf
            WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
            RESULT_VARIABLE rc)

    if (NOT "${rc}" STREQUAL "0")
        message(FATAL_ERROR "Build config ${_DEP_NAME} - FAIL")
    else ()
        message(STATUS "Build config ${_DEP_NAME} - done")
    endif ()
endfunction()

function(AutoReconf)
    set(_VARS _DEP_CUR_DIR)
    CheckVars()

    execute_process(
            COMMAND env
            autoreconf -fi
            WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
            RESULT_VARIABLE rc)

    if (NOT "${rc}" STREQUAL "0")
        message(FATAL_ERROR "Auto reconf ${_DEP_NAME} - FAIL")
    else ()
        message(STATUS "Auto reconf ${_DEP_NAME} - done")
    endif ()
endfunction()

function(AutoReConfV2)
    CheckVarsV2(_DEP_CUR_DIR)

    if (NOT EXISTS ${_DEP_CUR_DIR}/src/PHASE_AUTO_RE_CONF)
        execute_process(
                COMMAND env
                autoreconf -fi
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)

        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Auto re-conf ${_DEP_NAME} - FAIL")
        else ()
            file(WRITE ${_DEP_CUR_DIR}/src/PHASE_AUTO_RE_CONF "done")
            message(STATUS "Auto re-conf ${_DEP_NAME} - done")
        endif ()
    endif ()
endfunction(AutoReConfV2)

function(Configure)
    set(_VARS _DEP_NAME _DEP_CUR_DIR)
    CheckVars()

    if (EXISTS ${_DEP_CUR_DIR}/src/configure)
        set(CONFIG_CMD configure)
    elseif (EXISTS ${_DEP_CUR_DIR}/src/config)
        set(CONFIG_CMD config)
    else ()
        message(FATAL_ERROR "Config command (configure or config) not found")
    endif ()

    if (NOT EXISTS ${_DEP_CUR_DIR}/src/PHASE_CONFIGURE)
        message(STATUS "Configuring ${_DEP_NAME}")
        execute_process(
                COMMAND env
                CC=${CMAKE_C_COMPILER}
                CXX=${CMAKE_CXX_COMPILER}
                CFLAGS=-fPIC
                CXXFLAGS=-fPIC
                ./${CONFIG_CMD}
                --prefix=${_DEP_PREFIX}
                ${_EXTRA_DEFINE}
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Configuring ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Configuring ${_DEP_NAME} - done")
        file(WRITE ${_DEP_CUR_DIR}/src/PHASE_CONFIGURE "done")
    endif ()
endfunction()

function(ConfigureV2)
    set(options NoneOpt)
    set(oneValueArgs CONFIGURE_COMMAND)
    set(multiValueArgs NoneMulti EXTRA_DEFINE)
    cmake_parse_arguments(P "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    CheckVars(_DEP_NAME _DEP_CUR_DIR)

    if (EXISTS ${_DEP_CUR_DIR}/src/configure)
        set(CONFIG_CMD configure)
    elseif (EXISTS ${_DEP_CUR_DIR}/src/config)
        set(CONFIG_CMD config)
    endif ()

    if ("${CONFIGURE_COMMAND}" STREQUAL "")
        set(CONFIGURE_COMMAND ${CONFIG_CMD} --prefix=${_DEP_PREFIX})
    endif ()

    if (DEFINED CONFIG_CMD AND DEFINED CONFIG_CMD AND NOT EXISTS ${_DEP_CUR_DIR}/src/PHASE_CONFIGURE)
        message(STATUS "Configuring ${_DEP_NAME} with command ${CONFIGURE_COMMAND} EXTRA_DEFINE=${P_EXTRA_DEFINE}")
        execute_process(
                COMMAND env
                CC=${CMAKE_C_COMPILER}
                CXX=${CMAKE_CXX_COMPILER}
                CFLAGS=-fPIC
                CXXFLAGS=-fPIC
                ./${CONFIGURE_COMMAND} ${P_EXTRA_DEFINE}
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Configuring ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Configuring ${_DEP_NAME} - done")
        file(WRITE ${_DEP_CUR_DIR}/src/PHASE_CONFIGURE "done")
    endif ()
endfunction()

function(CMakeBuild)
    set(_VARS _DEP_PREFIX _DEP_CUR_DIR)
    CheckVars()

    make_directory(${_DEP_CUR_DIR}/build)
    execute_process(
            COMMAND ${CMAKE_COMMAND}
            -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
            -DCMAKE_BUILD_TYPE=${_BUILD_TYPE}
            -DCMAKE_INSTALL_PREFIX=${_DEP_PREFIX}
            -DBUILD_SHARED_LIBS=OFF
            -DCMAKE_INSTALL_LIBDIR=lib
            -DCMAKE_INSTALL_BINDIR=bin
            -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
            -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
            -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH_STR}
            ${_CMAKE_BUILD_EXTRA_DEFINE}
            ${_DEP_CUR_DIR}/src
            WORKING_DIRECTORY ${_DEP_CUR_DIR}/build
            RESULT_VARIABLE rc)
    if (NOT "${rc}" STREQUAL "0")
        message(FATAL_ERROR "Cmake build ${_DEP_NAME} - FAIL")
    endif ()
endfunction()

function(MakeBuild)
    set(_VARS _DEP_NAME _DEP_CUR_DIR)
    CheckVars()

    set(_DIR_TO_CHECK ${_DEP_CUR_DIR}/build)
    IsEmpty()
    if (_DIR_TO_CHECK_SIZE EQUAL 0)
        set(_CHECK_LIB_FIFE ${_DEP_CUR_DIR}/src/src/{_BUILD_LIB_DIR}/lib${_DEP_NAME}.a)
        set(_WORK_DIR ${_DEP_CUR_DIR}/src)
    else ()
        set(_CHECK_LIB_FIFE ${_DEP_CUR_DIR}/build/{_BUILD_LIB_DIR}/lib${_DEP_NAME}.a)
        set(_WORK_DIR ${_DEP_CUR_DIR}/build)
    endif ()

    if (NOT EXISTS ${_CHECK_LIB_FIFE})
        message(STATUS "Building ${_DEP_NAME}")
        include(ProcessorCount)
        ProcessorCount(cpus)
        execute_process(
                COMMAND env
                CC=${CMAKE_C_COMPILER}
                CXX=${CMAKE_CXX_COMPILER}
                make
                PREFIX=${_DEP_PREFIX}
                -j${cpus}
                ${_MAKE_BUILD_EXTRA_DEFINE}
                WORKING_DIRECTORY ${_WORK_DIR}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Building ${_DEP_NAME} - FAIL _WORK_DIR=${_WORK_DIR}")
        endif ()
        message(STATUS "Building ${_DEP_NAME} - done")
    endif ()
endfunction()

function(MakeBuildV2)
    CheckVars(_DEP_NAME _DEP_CUR_DIR _DEP_BUILD_DONE)
    set(_DIR_TO_CHECK ${_DEP_CUR_DIR}/build)
    IsEmpty()
    if (_DIR_TO_CHECK_SIZE EQUAL 0)
        set(_CHECK_LIB_FIFE ${_DEP_CUR_DIR}/src/src/{_BUILD_LIB_DIR}/lib${_DEP_NAME}.a)
        set(_WORK_DIR ${_DEP_CUR_DIR}/src)
    else ()
        set(_CHECK_LIB_FIFE ${_DEP_CUR_DIR}/build/{_BUILD_LIB_DIR}/lib${_DEP_NAME}.a)
        set(_WORK_DIR ${_DEP_CUR_DIR}/build)
    endif ()

    if (NOT ${_DEP_BUILD_DONE})
        message(STATUS "Building ${_DEP_NAME}")
        include(ProcessorCount)
        ProcessorCount(cpus)
        execute_process(
                COMMAND env
                CC=${CMAKE_C_COMPILER}
                CXX=${CMAKE_CXX_COMPILER}
                make
                PREFIX=${_DEP_PREFIX}
                -j${cpus}
                ${_MAKE_BUILD_EXTRA_DEFINE}
                WORKING_DIRECTORY ${_WORK_DIR}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Building ${_DEP_NAME} - FAIL _WORK_DIR=${_WORK_DIR}")
        endif ()
        message(STATUS "Building ${_DEP_NAME} - done")
    endif ()
endfunction(MakeBuildV2)

function(MakeInstall)
    set(_VARS _DEP_NAME _DEP_CUR_DIR _DEP_PREFIX)
    CheckVars()

    set(_DIR_TO_CHECK ${_DEP_CUR_DIR}/build)
    IsEmpty()
    if (_DIR_TO_CHECK_SIZE EQUAL 0)
        set(_WORK_DIR ${_DEP_CUR_DIR}/src)
    else ()
        set(_WORK_DIR ${_DEP_CUR_DIR}/build)
    endif ()

    if (NOT EXISTS ${_DEP_PREFIX}/lib/lib${_DEP_NAME}.a)
        message(STATUS "Installing ${_DEP_NAME}")
        execute_process(
                COMMAND env
                CC=${CMAKE_C_COMPILER}
                CXX=${CMAKE_CXX_COMPILER}
                make
                install
                PREFIX=${_DEP_PREFIX}
                ${_CMAKE_INSTALL_EXTRA_DEFINE}
                WORKING_DIRECTORY ${_WORK_DIR}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Installing ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Installing ${_DEP_NAME} - done")
    endif ()
endfunction()

function(MakeInstallV2)
    CheckVars(_DEP_NAME _DEP_CUR_DIR _DEP_PREFIX _DEP_INSTALL_DONE)

    set(_DIR_TO_CHECK ${_DEP_CUR_DIR}/build)
    IsEmpty()
    if (_DIR_TO_CHECK_SIZE EQUAL 0)
        set(_WORK_DIR ${_DEP_CUR_DIR}/src)
    else ()
        set(_WORK_DIR ${_DEP_CUR_DIR}/build)
    endif ()

    if (NOT ${_DEP_INSTALL_DONE})
        message(STATUS "Installing ${_DEP_NAME}")
        execute_process(
                COMMAND env
                CC=${CMAKE_C_COMPILER}
                CXX=${CMAKE_CXX_COMPILER}
                make
                install
                PREFIX=${_DEP_PREFIX}
                ${_CMAKE_INSTALL_EXTRA_DEFINE}
                WORKING_DIRECTORY ${_WORK_DIR}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Installing ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Installing ${_DEP_NAME} - done")
    else ()
        message(STATUS "Already Installed ${_DEP_NAME}")
    endif ()
endfunction(MakeInstallV2)

function(Bootstrap)
    set(_VARS _DEP_NAME _DEP_CUR_DIR)
    CheckVars()

    if (NOT EXISTS ${_DEP_CUR_DIR}/src/PHASE_BOOTSTRAP)
        message(STATUS "Bootstrap ${_DEP_NAME}")
        execute_process(
                COMMAND ./bootstrap.sh ${_BOOTSTRAP_OPTIONS}
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Bootstrap ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Bootstrap ${_DEP_NAME} - done")
        file(WRITE ${_DEP_CUR_DIR}/src/PHASE_BOOTSTRAP "done")
    endif ()
endfunction()

macro(SetExternalVars)
    CheckVarsV2(_EXTERNAL_VARS)
    foreach (_V IN LISTS _EXTERNAL_VARS)
        set(${_V} ${${_V}} PARENT_SCOPE)
    endforeach ()
endmacro(SetExternalVars)

macro(SetDepPrefixV2)
    CheckVarsV2(_DEP_UNAME _DEP_CUR_DIR)

    set(_DEP_PREFIX ${${_DEP_UNAME}_PREFIX})
    if ("${_DEP_PREFIX}" STREQUAL "")
        if ("${DEPS_DIR}" STREQUAL "")
            set(_DEP_PREFIX ${_DEP_CUR_DIR})
        else ()
            set(_DEP_PREFIX ${DEPS_DIR}/${_DEP_NAME})
        endif ()
        set(${_DEP_UNAME}_PREFIX ${_DEP_PREFIX})
    endif ()
endmacro(SetDepPrefixV2)

macro(PrepareDeps version)
    set(options NoneOpt)
    set(oneValueArgs NoneOneArgs)
    set(multiValueArgs MODULES)
    cmake_parse_arguments(P "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
    string(TOUPPER ${_DEP_NAME} _DEP_UNAME)
    set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
    set(_NEED_REBUILD TRUE)
    set(_EXTERNAL_VARS)
    set(_DEP_VER ${version})
    set(_DEP_MODULES ${P_MODULES})
    string(REPLACE "." "_" _DEP_VER_ "${_DEP_VER}")

    SetDepPrefixV2()
    CheckVersionV2()

    # check library output
    list(GET _DEP_MODULES 0 _FIRST_DEP_MODULE)
    find_library(build_library_${_DEP_NAME}
            NAMES ${_FIRST_DEP_MODULE} lib${_FIRST_DEP_MODULE}
            PATHS ${_DEP_CUR_DIR}/src ${_DEP_CUR_DIR}/build ${_DEP_CUR_DIR}
            PATH_SUFFIXES src .libs lib lib64 lib/.libs lib64/.libs
            NO_DEFAULT_PATH)
    if ("${build_library_${_DEP_NAME}}" STREQUAL "build_library_${_DEP_NAME}-NOTFOUND")
        set(_DEP_BUILD_DONE FALSE)
    else ()
        set(_DEP_BUILD_DONE TRUE)
    endif ()

    find_library(output_library_${_DEP_NAME}
            NAMES ${_FIRST_DEP_MODULE} lib${_FIRST_DEP_MODULE}
            PATHS ${_DEP_PREFIX}
            PATH_SUFFIXES lib lib64
            NO_DEFAULT_PATH)
    if ("${output_library_${_DEP_NAME}}" STREQUAL "output_library_${_DEP_NAME}-NOTFOUND")
        set(_DEP_INSTALL_DONE FALSE)
    else ()
        set(_DEP_INSTALL_DONE TRUE)
    endif ()
    message(STATUS "[PrepareDeps] prepare done. [DEP=${_DEP_NAME}, MODULES=${P_MODULES}, "
            "BUILD_DONE=${_DEP_BUILD_DONE}, INSTALL_DONE=${_DEP_INSTALL_DONE} ${build_library_${_DEP_NAME}}, "
            "${output_library_${_DEP_NAME}}, DEP_PREFIX=${_DEP_PREFIX} ${output_library_${_DEP_NAME}}]")
endmacro(PrepareDeps)

macro(AddLibrary MODULE)
    set(options NONE)
    set(oneValueArgs PREFIX LINK_LIBRARIES COMPILE_OPTIONS)
    set(multiValueArgs SUBMODULES)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    message(STATUS "[AddLibrary] MODULE=${MODULE} PREFIX=${ARG_PREFIX} DEP=${ARG_DEP} SUBMODULES=${ARG_SUBMODULES}")


    if ("${ARG_PREFIX}" STREQUAL "")
        message(FATAL_ERROR "PREFIX should not be empty")
    endif ()
    foreach (I IN LISTS ARG_SUBMODULES)
        set(TGT ${MODULE}::${I})
        add_library(${TGT} STATIC IMPORTED GLOBAL)
        find_library(add_library_${MODULE}_${I}
                NAMES lib${I}${CMAKE_STATIC_LIBRARY_SUFFIX} ${I}${CMAKE_STATIC_LIBRARY_SUFFIX} ${I}
                PATHS ${ARG_PREFIX}
                PATH_SUFFIXES lib lib64
                NO_DEFAULT_PATH)
        message(STATUS "[AddLibrary] TARGET=${TGT} LIB=${add_library_${MODULE}_${I}}")
        set_target_properties(${TGT} PROPERTIES
                # IMPORTED_LOCATION "${ARG_PREFIX}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${I}${CMAKE_STATIC_LIBRARY_SUFFIX}"
                IMPORTED_LOCATION "${add_library_${MODULE}_${I}}"
                INCLUDE_DIRECTORIES ${ARG_PREFIX}/include
                INTERFACE_INCLUDE_DIRECTORIES ${ARG_PREFIX}/include
                # eg. pthread;z
                INTERFACE_LINK_LIBRARIES "${ARG_LINK_LIBRARIES}"
                # eg. -pthread
                INTERFACE_COMPILE_OPTIONS "${ARG_COMPILE_OPTIONS}")
    endforeach ()
endmacro(AddLibrary)

macro(AddProject)
    set(options MAKE INSTALL NINJA AUTO_RE_CONF CONFIGURE)
    set(oneValueArgs GIT_REPOSITORY GIT_TAG DEP_AUTHOR DEP_PROJECT DEP_TAG OSS_FILE)
    set(multiValueArgs CONFIGURE_DEFINE NINJA_EXTRA_DEFINE)
    cmake_parse_arguments(P "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (NOT ${_DEP_INSTALL_DONE})
        if ("${P_GIT_REPOSITORY}" STREQUAL "")
            if (DEFINED ENV{OSS_URL})
                set(_DEP_URL $ENV{OSS_URL}/${P_OSS_FILE})
            else ()
                set(_DEP_URL https://codeload.github.com/${P_DEP_AUTHOR}/${P_DEP_PROJECT}/tar.gz/refs/tags/${P_DEP_TAG})
            endif ()
            message(STATUS "[AddProject] URL=${_DEP_URL}, VERSION=${_DEP_VER}")
            DownloadDepV3(${_DEP_VER} ${_DEP_URL})
            ExtractDepV2(${_DEP_VER})
        else ()
            message(STATUS "[AddProject] GIT=${P_GIT_REPOSITORY}, TAG=${P_GIT_TAG}")
            GitCloneV2(GIT_TAG)
        endif ()
        if (${P_AUTO_RE_CONF})
            AutoReConfV2()
        endif ()
        if (${P_CONFIGURE})
            ConfigureV2(EXTRA_DEFINE ${P_CONFIGURE_DEFINE})
        endif ()
        if (${P_MAKE})
            MakeBuildV2()
        endif ()
        if (${P_INSTALL})
            MakeInstallV2()
        endif ()
        if (${P_NINJA})
            CMakeNinjaV2()
            NinjaBuildV2()
            NinjaInstallV2()
        endif ()
    endif ()

    SetDepPath()
    AppendCMakePrefix()

    # append external vars
    list(APPEND _EXTERNAL_VARS _DEP_NAME)
    list(APPEND _EXTERNAL_VARS _DEP_PREFIX)
    list(APPEND _EXTERNAL_VARS _DEP_MODULES)

    SetExternalVars()
endmacro(AddProject)

macro(ProcessAddLibrary)
    AddLibrary(${_DEP_NAME} PREFIX ${_DEP_PREFIX} SUBMODULES ${_DEP_MODULES})
    unset(_DEP_NAME)
    unset(_DEP_PREFIX)
    unset(_DEP_MODULES)
endmacro(ProcessAddLibrary)