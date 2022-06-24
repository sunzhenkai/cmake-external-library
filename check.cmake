include(${CMAKE_CURRENT_LIST_DIR}/common.cmake)

function(SetDepPrefix name uname prefix)
    if (${uname}_PREFIX STREQUAL "")
        set(_DEP_PREFIX ${uname}_PREFIX PARENT_SCOPE)
    elseif (DEPS_DIR)
        set(_DEP_PREFIX "${DEPS_DIR}/${name}" PARENT_SCOPE)
    else ()
        set(_DEP_PREFIX ${prefix} PARENT_SCOPE)
    endif ()
endfunction(SetDepPrefix)

macro(CheckLibraryInstall)
    list(GET _DEP_MODULES 0 _FIRST_DEP_MODULE)
    FindLibrary(install_library_${_DEP_NAME} ${_FIRST_DEP_MODULE} ${_DEP_PREFIX})
    set(_DEP_INSTALLED_LIBRARY ${install_library_${_DEP_NAME}})
endmacro(CheckLibraryInstall)

macro(SetTemplateVariable version)
    # _DEP_NAME _DEP_UNAME _DEP_VER _DEP_VER_ _DEP_MODULES
    # _DEP_CUR_DIR _DEP_PREFIX _DEP_BUILD_DIR _DEP_SRC_DIR _DEP_PACKAGE_DIR
    # _NEED_REBUILD _DEP_INSTALLED_LIBRARY

    if (NOT DEFINED _DEP_NAME)
        get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
    endif ()

    string(TOUPPER ${_DEP_NAME} _DEP_UNAME)
    set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
    set(_DEP_BUILD_DIR ${_DEP_CUR_DIR}/build)
    set(_DEP_PACKAGE_DIR ${_DEP_CUR_DIR}/packages)
    set(_DEP_SRC_DIR ${_DEP_CUR_DIR}/src)
    set(_NEED_REBUILD TRUE)
    set(_EXTERNAL_VARS)
    if (DEFINED ${_DEP_UNAME}_VERSION)
        set(_DEP_VER ${${_DEP_UNAME}_VERSION})
    else ()
        set(_DEP_VER ${version})
    endif ()
    set(_DEP_MODULES ${ARG_MODULES})
    string(REPLACE "." "_" _DEP_VER_ "${_DEP_VER}")
    SetDepPrefix(${_DEP_NAME} ${_DEP_UNAME} ${_DEP_CUR_DIR})
    CheckLibraryInstall()

    message(STATUS "[SetTemplateVariable] _DEP_NAME=${_DEP_NAME} _DEP_UNAME=${_DEP_UNAME} "
            "_DEP_CUR_DIR=${_DEP_CUR_DIR} _DEP_PREFIX=${_DEP_PREFIX} _DEP_BUILD_DIR=${_DEP_BUILD_DIR} "
            "_DEP_SRC_DIR=${_DEP_SRC_DIR} _NEED_REBUILD=${_NEED_REBUILD} _DEP_VER=${_DEP_VER} "
            "_DEP_MODULES=${_DEP_MODULES} _DEP_VER_=${_DEP_VER_} _DEP_INSTALLED_LIBRARY=${_DEP_INSTALLED_LIBRARY}")
endmacro(SetTemplateVariable)

function(CleanDep source prefix)
    if (src_dir)
        file(REMOVE_RECURSE ${source}/src)
        file(REMOVE_RECURSE ${source}/build)
    endif ()
    if (prefix_dir)
        file(REMOVE_RECURSE ${prefix}/bin)
        file(REMOVE_RECURSE ${prefix}/lib)
        file(REMOVE_RECURSE ${prefix}/lib64)
        file(REMOVE_RECURSE ${prefix}/include)
        file(REMOVE_RECURSE ${prefix}/share)
        file(REMOVE_RECURSE ${prefix}/doc)
    endif ()
endfunction()

function(WriteVersion version prefix)
    message(STATUS "Write VERSION file. VERSION=${version} FILE=${prefix}/VERSION")
    file(WRITE ${prefix}/VERSION ${version})
endfunction()

function(AppendCMakePrefix)
    list(FIND CMAKE_PREFIX_PATH ${_DEP_PREFIX} _DEP_INDEX)
    if (_DEP_INDEX EQUAL -1)
        list(APPEND CMAKE_PREFIX_PATH ${_DEP_PREFIX})
        set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE)
        list(APPEND _EXTERNAL_VARS CMAKE_PREFIX_PATH)
    endif ()
endfunction(AppendCMakePrefix)

function(AppendPkgConfig)
    if (EXISTS ${_DEP_PREFIX}/lib/pkgconfig/)
        set(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:${_DEP_PREFIX}/lib/pkgconfig/")
    elseif (EXISTS ${_DEP_PREFIX}/lib64/pkgconfig/)
        set(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:${_DEP_PREFIX}/lib64/pkgconfig/")
    endif ()
endfunction(AppendPkgConfig)

function(CheckVersion version source prefix)
    if (NOT EXISTS ${prefix}/VERSION)
        set(_NEED_REBUILD TRUE)
    else ()
        file(STRINGS ${prefix}/VERSION BUILD_VERSION)
        if ("${BUILD_VERSION}" STREQUAL "${version}")
            set(_NEED_REBUILD FALSE)
        else ()
            set(_NEED_REBUILD TRUE)
        endif ()
    endif ()
    set(_NEED_REBUILD ${_NEED_REBUILD} PARENT_SCOPE)
    if (_NEED_REBUILD)
        CleanDep(${source} ${prefix})
        WriteVersion(${version} ${prefix})
    endif ()
endfunction(CheckVersion)

macro(PrepareDep version)
    set(options FindByHeader)
    set(oneValueArgs NoneOneArgs)
    set(multiValueArgs MODULES FindPathSuffix)
    cmake_parse_arguments(ARG ${options} ${oneValueArgs} ${multiValueArgs} ${ARGN})

    SetTemplateVariable(${version})
    CheckVersion(${_DEP_VER} ${_DEP_SRC_DIR} ${_DEP_PREFIX})
endmacro(PrepareDep)

function(DownloadDep)
    set(ARGS GIT_REPOSITORY GIT_TAG DEP_AUTHOR DEP_PROJECT DEP_TAG SPEED_UP_FILE DEP_URL)
    cmake_parse_arguments(ARG "" "${ARGS}" "" ${ARGN})

    if (DEFINED ENV{SPEED_UP_URL} AND ARG_SPEED_UP_FILE)
        set(_DEP_URL $ENV{SPEED_UP_URL}/${ARG_SPEED_UP_FILE})
    else ()
        set(_DEP_URL ${ARG_DEP_URL})
    endif ()

    # external git repo > speed up url > download git release > clone git repo
    set(_EXTERNAL_GIT_REPO ${${_DEP_UNAME}_GIT_REPOSITORY})
    if (_EXTERNAL_GIT_REPO)
        GitClone(${_DEP_NAME} ${_DEP_SRC_DIR} ${_EXTERNAL_GIT_REPO} ${_DEP_VER})
    elseif (_DEP_URL)
        DoDownloadDep(${_DEP_NAME} ${_DEP_PACKAGE_DIR} ${_DEP_VER} ${_DEP_URL})
        ExtractDep(${_DEP_NAME} ${_DEP_SRC_DIR} ${_DEP_PACKAGE_DIR} ${_DEP_VER})
    elseif (NOT ARG_GIT_REPOSITORY AND ARG_DEP_PROJECT)
        set(_DEP_URL https://codeload.github.com/${ARG_DEP_AUTHOR}/${ARG_DEP_PROJECT}/tar.gz/refs/tags/${ARG_DEP_TAG})
        DoDownloadDep(${_DEP_NAME} ${_DEP_PACKAGE_DIR} ${_DEP_VER} ${_DEP_URL})
        ExtractDep(${_DEP_NAME} ${_DEP_SRC_DIR} ${_DEP_PACKAGE_DIR} ${_DEP_VER})
    elseif (ARG_GIT_REPOSITORY)
        GitClone(${_DEP_NAME} ${_DEP_SRC_DIR} ${ARG_GIT_REPOSITORY} ${_DEP_VER})
    endif ()
endfunction(DownloadDep)

macro(SetSrc)
    if (ARG_SRC)
        set(SRC ${ARG_SRC})
    else ()
        set(SRC ${_DEP_SRC_DIR})
    endif ()
endmacro(SetSrc)

macro(CheckDest)
    set(PREFIX ${_DEP_PREFIX})
    if (ARG_DEST AND NOT EXISTS ${PREFIX}/${ARG_DEST})
        set(CHECK_DEST_RESULT FALSE)
    elseif (NOT _DEP_INSTALLED_LIBRARY)
        set(CHECK_DEST_RESULT FALSE)
    else ()
        set(CHECK_DEST_RESULT TRUE)
    endif ()
endmacro(CheckDest)

function(BOOTSTRAP)
    cmake_parse_arguments(ARG "" "SRC;ENV;ARGS" "" ${ARGN})
    SetSrc()
    if (NOT EXISTS ${SRC}/PHASE_BOOTSTRAP)
        message(STATUS "Bootstrap ${_DEP_NAME} SRC=${SRC} ENV=${ARG_ENV} ARGS=${ARGS}. "
                "CC=${CMAKE_C_COMPILER}, CXX=${CMAKE_CXX_COMPILER}.")
        execute_process(
                COMMAND env CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} ${ARG_ENV}
                ./bootstrap.sh ${ARG_ARGS}
                WORKING_DIRECTORY ${SRC}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Bootstrap ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Bootstrap ${_DEP_NAME} - done")
        file(WRITE ${SRC}/PHASE_BOOTSTRAP "done")
    endif ()
endfunction(BOOTSTRAP)

function(B2Build)
    cmake_parse_arguments(ARG "" "SRC;ENV;ARGS" "" ${ARGN})
    SetSrc()

    if (NOT _DEP_INSTALLED_LIBRARY AND NOT EXISTS ${SRC}/PHASE_B2BUILD)
        message(STATUS "B2 compile. DEP=${_DEP_NAME} SRC=${SRC} ENV=${ARG_ENV} ARGS=${ARG_ARGS}")
        ProcessorCount(cpus)
        execute_process(
                COMMAND env CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} ${ARG_ENV}
                b2 --build-dir=${_DEP_BUILD_DIR} ${ARG_ARGS} -j${cpus}
                WORKING_DIRECTORY ${SRC}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "B2 build ${_DEP_NAME} ${rc} - FAIL")
        endif ()
        message(STATUS "B2 compile ${_DEP_NAME} - done")
        file(WRITE ${SRC}/PHASE_B2BUILD "done")
    endif ()
endfunction(B2Build)

function(B2Install)
    cmake_parse_arguments(ARG "" "SRC;ENV;ARGS;DEST" "" ${ARGN})
    SetSrc()
    CheckDest()

    if (NOT CHECK_DEST_RESULT)
        message(STATUS "B2 install. DEP=${_DEP_NAME} SRC=${SRC} PREFIX=${_DEP_PREFIX} "
                "ENV=${ARG_ENV} ARGS=${ARG_ARGS}")
        execute_process(
                COMMAND env CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} ${ARG_ENV}
                b2 --prefix=${_DEP_PREFIX} ${ARG_ARGS} install
                WORKING_DIRECTORY ${SRC}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "B2 install ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "B2 install ${_DEP_NAME} - done")
        file(WRITE ${SRC}/PHASE_B2INSTALL "done")
    endif ()
endfunction(B2Install)

macro(SetExternalVars)
    foreach (_V IN LISTS _EXTERNAL_VARS)
        set(${_V} ${${_V}} PARENT_SCOPE)
    endforeach ()
endmacro(SetExternalVars)

macro(PostProcess)
    AppendCMakePrefix()
    AppendPkgConfig()
    # append external vars
    list(APPEND _EXTERNAL_VARS _DEP_NAME)
    list(APPEND _EXTERNAL_VARS _DEP_PREFIX)
    list(APPEND _EXTERNAL_VARS _DEP_MODULES)

    SetExternalVars()
endmacro(PostProcess)