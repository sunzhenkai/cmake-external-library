function(CheckVars)
    foreach (_V IN LISTS _VARS)
        if (NOT DEFINED ${_V})
            message(FATAL_ERROR "CheckVars: not found variable ${_V}")
        else ()
            message(STATUS "CheckVars: found variable ${_V}=${${_V}}")
        endif ()
    endforeach ()
endfunction()

function(CheckVersion)
    set(_VARS _DEP_VER _DEP_NAME _DEP_PREFIX _NEED_REBUILD)
    CheckVars()

    if (DEFINED _DEP_VER)
        set(NEW_VERSION ${_DEP_VER})
    else ()
        message(FATAL_ERROR "Variable _DE_VER not found")
    endif ()
    if (NOT EXISTS ${_DEP_PREFIX}/VERSION)
        message(STATUS "VERSION file not found under dir ${_DEP_PREFIX}, rebuilding ${_DEP_NAME}")
        set(NEED_REBUILD TRUE)
    else ()
        file(STRINGS ${_DEP_PREFIX}/VERSION BUILD_VERSION)
        if ("${BUILD_VERSION}" STREQUAL "${NEW_VERSION}")
            set(NEED_REBUILD FALSE)
        else ()
            message(STATUS "Found new version ${NEW_VERSION} against old version ${BUILD_VERSION} from dir "
                    "${_DEP_PREFIX}, rebuilding ${_DEP_NAME}")
            set(NEED_REBUILD TRUE)
        endif ()
    endif ()
    set(_NEED_REBUILD FALSE PARENT_SCOPE)
    file(WRITE ${_DEP_PREFIX}/VERSION ${NEW_VERSION})
endfunction(CheckVersion)

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
    message(STATUS "Empty check, _DIR_TO_CHECK=${_DIR_TO_CHECK}, _DIR_TO_CHECK_SIZE=${_DIR_TO_CHECK_SIZE}")
endfunction()

function(SetDepPath)
    set(_VARS _DEP_UNAME _DEP_PREFIX)
    CheckVars()

    if (EXISTS ${_DEP_PREFIX}/bin)
        set(_DEP_BIN_DIR ${_DEP_PREFIX}/bin PARENT_SCOPE)
        set(${_DEP_UNAME}_BIN_DIR ${_DEP_BIN_DIR} PARENT_SCOPE)
    endif ()
    if (EXISTS ${_DEP_PREFIX}/lib)
        set(_DEP_LIB_DIR ${_DEP_PREFIX}/lib PARENT_SCOPE)
        set(${_DEP_UNAME}_LIB_DIR ${_DEP_LIB_DIR} PARENT_SCOPE)
    endif ()
    if (EXISTS ${_DEP_PREFIX}/lib64)
        set(_DEP_LIB_DIR ${_DEP_PREFIX}/lib64 PARENT_SCOPE)
        set(${_DEP_UNAME}_LIB_DIR ${_DEP_LIB_DIR} PARENT_SCOPE)
    endif ()
    if (EXISTS ${_DEP_PREFIX}/include)
        set(_DEP_INCLUDE_DIR ${_DEP_PREFIX}/include PARENT_SCOPE)
        set(${_DEP_UNAME}_INCLUDE_DIR ${_DEP_INCLUDE_DIR} PARENT_SCOPE)
    endif ()
endfunction()

function(AppendCMakePrefix)
    list(FIND CMAKE_PREFIX_PATH ${_DEP_PREFIX} _DEP_INDEX)
    if (_DEP_INDEX EQUAL -1)
        list(APPEND CMAKE_PREFIX_PATH ${_DEP_PREFIX})
        set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE)
    endif ()
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

    AppendCMakePrefix()
    set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE)

    message(STATUS "Try to add library ${_FIND_DEP_NAME}::${_DEP_NAME_SPACE}")
    if (NOT TARGET ${_FIND_DEP_NAME}::${_DEP_NAME_SPACE} AND EXISTS ${_DEP_LIB_DIR}/lib${_DEP_NAME_SPACE}.a)
        message(STATUS "Add library ${_FIND_DEP_NAME}::${_DEP_NAME_SPACE}")
        add_library(${_FIND_DEP_NAME}::${_DEP_NAME_SPACE} STATIC IMPORTED GLOBAL)
        set_target_properties(${_FIND_DEP_NAME}::${_DEP_NAME_SPACE} PROPERTIES
                IMPORTED_LOCATION "${_DEP_LIB_DIR}/lib${_DEP_NAME_SPACE}.a"
                INTERFACE_INCLUDE_DIRECTORIES "${_DEP_INCLUDE_DIR}")
    endif ()
endfunction()

function(DownloadDep)
    set(_VARS _DEP_NAME _DEP_CUR_DIR _DEP_URL)
    CheckVars()

    if (NOT EXISTS ${_DEP_CUR_DIR}/packages/${_DEP_NAME}.tar.gz)
        file(MAKE_DIRECTORY ${_DEP_CUR_DIR}/packages)
        set(_DEST ${CMAKE_CURRENT_LIST_DIR}/packages/${_DEP_NAME}.tar.gz)
        message(STATUS "Downloading ${_DEP_NAME}:${_DEP_URL}, DEST=${_DEST}")
        execute_process(
                COMMAND wget -O ${_DEST} ${_DEP_URL}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Downloading ${_DEP_NAME}: ${_DEP_URL} - FAIL")
        endif ()
        message(STATUS "Downloading ${_DEP_NAME}: ${_DEP_URL} - done")
    endif ()
endfunction()

function(ExtractDep)
    set(_VARS _DEP_NAME _DEP_CUR_DIR)
    CheckVars()

    set(_DIR_TO_CHECK ${_DEP_CUR_DIR}/src)
    IsEmpty()
    if (_DIR_TO_CHECK_SIZE EQUAL 0)
        file(MAKE_DIRECTORY ${_DEP_CUR_DIR}/src)
        message(STATUS "Extracting ${_DEP_NAME}")
        execute_process(
                COMMAND tar -xf ${_DEP_CUR_DIR}/packages/${_DEP_NAME}.tar.gz
                --strip-components 1 -C ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Extracting ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Extracting ${_DEP_NAME} - done")
    endif ()
endfunction()

function(CMakeNinja)
    set(_VARS _DEP_NAME _DEP_CUR_DIR _DEP_PREFIX)
    CheckVars()

    set(_DIR_TO_CHECK ${_DEP_CUR_DIR}/build)
    IsEmpty()
    if (_DIR_TO_CHECK_SIZE EQUAL 0)
        file(MAKE_DIRECTORY ${_DEP_CUR_DIR}/build)
        message(STATUS "Configuring ${_DEP_NAME}")
        execute_process(
                COMMAND ${CMAKE_COMMAND}
                -G Ninja
                -DCMAKE_BUILD_TYPE=Release
                -DCMAKE_INSTALL_PREFIX=${_DEP_PREFIX}
                -DBUILD_SHARED_LIBS=OFF
                -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
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

    if (NOT EXISTS ${_DEP_CUR_DIR}/build/lib/${_DEP_NAME_BUILD_CHECK})
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

function(NinjaInstall)
    set(_VARS _DEP_NAME _DEP_PREFIX _DEP_CUR_DIR)
    CheckVars()

    if (${_PERMISSION})
        set(_PERMISSION_ROLE "sudo")
    endif ()

    if (NOT DEFINED _DEP_NAME_INSTALL_CHECK)
        set(_DEP_NAME_INSTALL_CHECK lib${_DEP_NAME}.a)
    endif ()

    if (NOT EXISTS ${_DEP_CUR_DIR}/lib/${_DEP_NAME_INSTALL_CHECK})
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

function(Configure)
    set(_VARS _DEP_NAME _DEP_CUR_DIR)
    CheckVars()

    if (NOT EXISTS ${_DEP_CUR_DIR}/src/PHASE_CONFIGURE)
        message(STATUS "Configuring ${_DEP_NAME}")
        execute_process(
                COMMAND env
                CC=${CMAKE_C_COMPILER}
                CXX=${CMAKE_CXX_COMPILER}
                CFLAGS=-fPIC
                CXXFLAGS=-fPIC
                ./configure
                --prefix=${_DEP_PREFIX}
                --enable-shared=no
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Configuring ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Configuring ${_DEP_NAME} - done")
        file(WRITE ${_DEP_CUR_DIR}/src/PHASE_CONFIGURE "done")
    endif ()
endfunction()

function(MakeBuild)
    set(_VARS _DEP_NAME _DEP_CUR_DIR)
    CheckVars()

    if (NOT EXISTS ${_DEP_CUR_DIR}/src/src/.libs/lib${_DEP_NAME}.a)
        message(STATUS "Building ${_DEP_NAME}")
        include(ProcessorCount)
        ProcessorCount(cpus)
        execute_process(
                COMMAND env
                CC=${CMAKE_C_COMPILER}
                CXX=${CMAKE_CXX_COMPILER}
                make
                -j${cpus}
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Building ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Building ${_DEP_NAME} - done")
    endif ()
endfunction()

function(MakeInstall)
    set(_VARS _DEP_NAME _DEP_CUR_DIR _DEP_PREFIX)
    CheckVars()

    if (NOT EXISTS ${_DEP_PREFIX}/lib/lib${_DEP_NAME}.a)
        message(STATUS "Installing ${_DEP_NAME}")
        execute_process(
                COMMAND env
                CC=${CMAKE_C_COMPILER}
                CXX=${CMAKE_CXX_COMPILER}
                make
                install
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Installing ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Installing ${_DEP_NAME} - done")
    endif ()
endfunction()