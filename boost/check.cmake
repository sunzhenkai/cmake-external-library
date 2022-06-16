# https://programming.vip/docs/boost-compiler-installation-under-linux.html
function(Process)
    PrepareDeps(1.76.0 MODULES boost_system)
    AddProject(DEP_AUTHOR apache
            DEP_URL https://boostorg.jfrog.io/artifactory/main/release/${_DEP_VER}/source/${_DEP_NAME}_${_DEP_VER_}.tar.gz
            SPEED_UP_FILE ${_DEP_NAME}_${_DEP_VER_}.tar.gz)

    ## ./bootstrap.sh
    #if (NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/src/PHASE_BOOTSTRAP)
    #    message(STATUS "Bootstrap ${_DEP_NAME}")
    #    execute_process(
    #            COMMAND ./bootstrap.sh --without-libraries=mpi,python,graph,graph_parallel
    #            WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
    #            RESULT_VARIABLE rc)
    #    if (NOT "${rc}" STREQUAL "0")
    #        message(FATAL_ERROR "Bootstrap ${_DEP_NAME} - FAIL")
    #    endif ()
    #    message(STATUS "Bootstrap ${_DEP_NAME} - done")
    #    file(WRITE ${CMAKE_CURRENT_LIST_DIR}/src/PHASE_BOOTSTRAP "done")
    #endif ()
    #
    ## build b2
    #if (NOT EXISTS ${_DEP_PREFIX}/bin/b2)
    #    if (NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/src/tools/build/b2)
    #        message(STATUS "Building ${_DEP_NAME} b2")
    #        execute_process(
    #                COMMAND env
    #                CC=${CMAKE_C_COMPILER}
    #                ./bootstrap.sh
    #                --with-toolset=cc
    #                WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src/tools/build
    #                RESULT_VARIABLE rc)
    #        if (NOT "${rc}" STREQUAL "0")
    #            message(FATAL_ERROR "Building ${_DEP_NAME} b2 - FAIL")
    #        endif ()
    #        message(STATUS "Building ${_DEP_NAME} b2 - done")
    #    endif ()
    #    # install b2
    #    message(STATUS "Installing ${_DEP_NAME} b2")
    #    execute_process(
    #            COMMAND ./b2 --prefix=${_DEP_PREFIX} install
    #            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src/tools/build
    #            RESULT_VARIABLE rc)
    #    if (NOT "${rc}" STREQUAL "0")
    #        message(FATAL_ERROR "Installing ${_DEP_NAME} b2 - FAIL")
    #    endif ()
    #    message(STATUS "Installing ${_DEP_NAME} b2 - done")
    #endif ()
    #
    ## build
    #if (NOT EXISTS ${_DEP_PREFIX}/lib/lib${_DEP_NAME}_system.a)
    #    message(STATUS "Building ${_DEP_NAME}")
    #    include(ProcessorCount)
    #    ProcessorCount(cpus)
    #    execute_process(
    #            COMMAND env
    #            ${_DEP_PREFIX}/bin/b2
    #            toolset=gcc
    #            variant=release
    #            debug-symbols=on
    #            link=static
    #            runtime-link=shared
    #            threadapi=pthread
    #            threading=multi
    #            cxxflags=-fPIC
    #            -j${cpus}
    #            --without-mpi
    #            --without-python
    #            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src
    #            RESULT_VARIABLE rc)
    #    if (NOT "${rc}" STREQUAL "0")
    #        message(FATAL_ERROR "Building ${_DEP_NAME} - FAIL")
    #    endif ()
    #    message(STATUS "Building ${_DEP_NAME} - done")
    #
    #    # install
    #    message(STATUS "Installing ${_DEP_NAME}")
    #    execute_process(
    #            COMMAND env
    #            PATH=${CMAKE_CURRENT_LIST_DIR}/src/cc-wrappers/bin:$ENV{PATH}
    #            ${_DEP_PREFIX}/bin/b2
    #            toolset=gcc
    #            variant=release
    #            debug-symbols=on
    #            link=static
    #            runtime-link=shared
    #            threadapi=pthread
    #            threading=multi
    #            cxxflags=-fPIC
    #            -j${cpus}
    #            --without-mpi
    #            --without-python
    #            --prefix=${_DEP_PREFIX}
    #            install
    #            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src
    #            RESULT_VARIABLE rc)
    #    if (NOT "${rc}" STREQUAL "0")
    #        message(FATAL_ERROR "Installing ${_DEP_NAME} - FAIL")
    #    endif ()
    #    message(STATUS "Installing ${_DEP_NAME} - done")
    #endif ()
endfunction(Process)
Process()


## ./bootstrap.sh
#if (NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/src/PHASE_BOOTSTRAP)
#    message(STATUS "Bootstrap ${_DEP_NAME}")
#    execute_process(
#            COMMAND ./bootstrap.sh --without-libraries=mpi,python,graph,graph_parallel
#            WORKING_DIRECTORY ${_DEP_CUR_DIR}/src
#            RESULT_VARIABLE rc)
#    if (NOT "${rc}" STREQUAL "0")
#        message(FATAL_ERROR "Bootstrap ${_DEP_NAME} - FAIL")
#    endif ()
#    message(STATUS "Bootstrap ${_DEP_NAME} - done")
#    file(WRITE ${CMAKE_CURRENT_LIST_DIR}/src/PHASE_BOOTSTRAP "done")
#endif ()
#
## build b2
#if (NOT EXISTS ${_DEP_PREFIX}/bin/b2)
#    if (NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/src/tools/build/b2)
#        message(STATUS "Building ${_DEP_NAME} b2")
#        execute_process(
#                COMMAND env
#                CC=${CMAKE_C_COMPILER}
#                ./bootstrap.sh
#                --with-toolset=cc
#                WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src/tools/build
#                RESULT_VARIABLE rc)
#        if (NOT "${rc}" STREQUAL "0")
#            message(FATAL_ERROR "Building ${_DEP_NAME} b2 - FAIL")
#        endif ()
#        message(STATUS "Building ${_DEP_NAME} b2 - done")
#    endif ()
#    # install b2
#    message(STATUS "Installing ${_DEP_NAME} b2")
#    execute_process(
#            COMMAND ./b2 --prefix=${_DEP_PREFIX} install
#            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src/tools/build
#            RESULT_VARIABLE rc)
#    if (NOT "${rc}" STREQUAL "0")
#        message(FATAL_ERROR "Installing ${_DEP_NAME} b2 - FAIL")
#    endif ()
#    message(STATUS "Installing ${_DEP_NAME} b2 - done")
#endif ()
#
## build
#if (NOT EXISTS ${_DEP_PREFIX}/lib/lib${_DEP_NAME}_system.a)
#    message(STATUS "Building ${_DEP_NAME}")
#    include(ProcessorCount)
#    ProcessorCount(cpus)
#    execute_process(
#            COMMAND env
#            ${_DEP_PREFIX}/bin/b2
#            toolset=gcc
#            variant=release
#            debug-symbols=on
#            link=static
#            runtime-link=shared
#            threadapi=pthread
#            threading=multi
#            cxxflags=-fPIC
#            -j${cpus}
#            --without-mpi
#            --without-python
#            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src
#            RESULT_VARIABLE rc)
#    if (NOT "${rc}" STREQUAL "0")
#        message(FATAL_ERROR "Building ${_DEP_NAME} - FAIL")
#    endif ()
#    message(STATUS "Building ${_DEP_NAME} - done")
#
#    # install
#    message(STATUS "Installing ${_DEP_NAME}")
#    execute_process(
#            COMMAND env
#            PATH=${CMAKE_CURRENT_LIST_DIR}/src/cc-wrappers/bin:$ENV{PATH}
#            ${_DEP_PREFIX}/bin/b2
#            toolset=gcc
#            variant=release
#            debug-symbols=on
#            link=static
#            runtime-link=shared
#            threadapi=pthread
#            threading=multi
#            cxxflags=-fPIC
#            -j${cpus}
#            --without-mpi
#            --without-python
#            --prefix=${_DEP_PREFIX}
#            install
#            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/src
#            RESULT_VARIABLE rc)
#    if (NOT "${rc}" STREQUAL "0")
#        message(FATAL_ERROR "Installing ${_DEP_NAME} - FAIL")
#    endif ()
#    message(STATUS "Installing ${_DEP_NAME} - done")
#endif ()

#SetDepPath()
#AppendCMakePrefix()
#set(BOOST_ROOT ${_DEP_PREFIX})
#set(Boost_NO_SYSTEM_PATHS ON)

#find_package(Boost 1.76 COMPONENTS ALL)
## see https://stackoverflow.com/questions/6646405/how-do-you-add-boost-libraries-in-cmakelists-txt
#if (${Boost_FOUND})
#    message(STATUS "Boost Boost_INCLUDE_DIRS=${Boost_INCLUDE_DIRS}, Boost_LIBRARIES=${Boost_LIBRARIES}")
#    include_directories(${Boost_INCLUDE_DIRS})
#endif ()