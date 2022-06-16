get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
string(TOUPPER ${_DEP_NAME} _DEP_UNAME)

# template variables
set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
set(_NEED_REBUILD TRUE)
set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})

set(_DEP_VER 1.76.0)
string(REPLACE "." "_" _DEP_VER_ "${_DEP_VER}")
if (DEFINED ENV{SPEED_UP_URL})
    set(_DEP_URL $ENV{SPEED_UP_URL}/${_DEP_NAME}_${_DEP_VER_}.tar.gz)
else ()
    set(_DEP_URL https://boostorg.jfrog.io/artifactory/main/release/${_DEP_VER}/source/${_DEP_NAME}_${_DEP_VER_}.tar.gz)
endif ()

SetDepPrefix()
CheckVersion()
message(STATUS "${_DEP_UNAME}: _NEED_REBUILD=${_NEED_REBUILD}, _DEP_PREFIX=${_DEP_PREFIX}")

set(_DEP_NAME_INSTALL_CHECK "lib${_DEP_NAME}_system.a")
if ((${_NEED_REBUILD}) OR (NOT EXISTS ${_DEP_PREFIX}/lib/${_DEP_NAME_INSTALL_CHECK}))
    DownloadDep()
    ExtractDep()

    # ./bootstrap.sh
    if (NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/src/PHASE_BOOTSTRAP)
        message(STATUS "Bootstrap ${_DEP_NAME}")
        execute_process(
                COMMAND ./bootstrap.sh --without-libraries=mpi,python,graph,graph_parallel
                WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Bootstrap ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Bootstrap ${_DEP_NAME} - done")
        file(WRITE ${CMAKE_CURRENT_LIST_DIR}/src/PHASE_BOOTSTRAP "done")
    endif ()

    # build b2
    if (NOT EXISTS ${_DEP_PREFIX}/bin/b2)
        if (NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/src/tools/build/b2)
            message(STATUS "Building ${_DEP_NAME} b2")
            execute_process(
                    COMMAND env
                    CC=${CMAKE_C_COMPILER}
                    ./bootstrap.sh
                    --with-toolset=cc
                    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src/tools/build
                    RESULT_VARIABLE rc)
            if (NOT "${rc}" STREQUAL "0")
                message(FATAL_ERROR "Building ${_DEP_NAME} b2 - FAIL")
            endif ()
            message(STATUS "Building ${_DEP_NAME} b2 - done")
        endif ()
        # install b2
        message(STATUS "Installing ${_DEP_NAME} b2")
        execute_process(
                COMMAND ./b2 --prefix=${_DEP_PREFIX} install
                WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src/tools/build
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Installing ${_DEP_NAME} b2 - FAIL")
        endif ()
        message(STATUS "Installing ${_DEP_NAME} b2 - done")
    endif ()

    # build
    if (NOT EXISTS ${_DEP_PREFIX}/lib/lib${_DEP_NAME}_system.a)
        message(STATUS "Building ${_DEP_NAME}")
        include(ProcessorCount)
        ProcessorCount(cpus)
        execute_process(
                COMMAND env
                ${_DEP_PREFIX}/bin/b2
                toolset=gcc
                variant=release
                debug-symbols=on
                link=static
                runtime-link=shared
                threadapi=pthread
                threading=multi
                cxxflags=-fPIC
                -j${cpus}
                --without-mpi
                --without-python
                WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Building ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Building ${_DEP_NAME} - done")

        # install
        message(STATUS "Installing ${_DEP_NAME}")
        execute_process(
                COMMAND env
                PATH=${CMAKE_CURRENT_LIST_DIR}/src/cc-wrappers/bin:$ENV{PATH}
                ${_DEP_PREFIX}/bin/b2
                toolset=gcc
                variant=release
                debug-symbols=on
                link=static
                runtime-link=shared
                threadapi=pthread
                threading=multi
                cxxflags=-fPIC
                -j${cpus}
                --without-mpi
                --without-python
                --prefix=${_DEP_PREFIX}
                install
                WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "Installing ${_DEP_NAME} - FAIL")
        endif ()
        message(STATUS "Installing ${_DEP_NAME} - done")
    endif ()
endif ()

SetDepPath()
AppendCMakePrefix()
set(BOOST_ROOT ${_DEP_PREFIX})
set(Boost_NO_SYSTEM_PATHS ON)

find_package(Boost 1.76 COMPONENTS ALL)
# see https://stackoverflow.com/questions/6646405/how-do-you-add-boost-libraries-in-cmakelists-txt
if (${Boost_FOUND})
    message(STATUS "Boost Boost_INCLUDE_DIRS=${Boost_INCLUDE_DIRS}, Boost_LIBRARIES=${Boost_LIBRARIES}")
    include_directories(${Boost_INCLUDE_DIRS})
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