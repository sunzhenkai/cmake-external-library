# https://programming.vip/docs/boost-compiler-installation-under-linux.html
function(Process)
    PrepareDeps(1.76.0 MODULES boost_system)
    set(BOOST_BUILD_ARGS toolset=gcc variant=release debug-symbols=on link=static runtime-link=shared
            threadapi=pthread threading=multi cxxflags="-fPIC -std=c++${CMAKE_CXX_STANDARD}"
            --without-mpi --without-python)
    set(B2_DIR ${CMAKE_CURRENT_LIST_DIR}/src/tools/build)
    AddProject(DEP_AUTHOR apache
            DEP_PROJECT ${_DEP_NAME}
            DEP_URL https://boostorg.jfrog.io/artifactory/main/release/${_DEP_VER}/source/${_DEP_NAME}_${_DEP_VER_}.tar.gz
            SPEED_UP_FILE ${_DEP_NAME}_${_DEP_VER_}.tar.gz)
    AddProject(B2INSTALL_ENV PATH=${B2_DIR}:$ENV{PATH}
            BOOTSTRAP_SRC_DIR ${B2_DIR}
            B2INSTALL_SRC_DIR ${B2_DIR}
            BOOTSTRAP_ARGS --with-toolset=cc
            BOOTSTRAP B2INSTALL)
    AddProject(B2INSTALL_ENV PATH=${_DEP_PREFIX}/bin:$ENV{PATH}
            B2BUILD_ENV PATH=${_DEP_PREFIX}/bin:$ENV{PATH}
            BOOTSTRAP_ARGS --with-toolset=gcc --without-libraries=mpi,python,graph,graph_parallel
            B2BUILD_ARGS ${BOOST_BUILD_ARGS}
            B2INSTALL_ARGS ${BOOST_BUILD_ARGS}
            BOOTSTRAP B2BUILD B2INSTALL)
endfunction(Process)
Process()
