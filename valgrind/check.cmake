include(${CMAKE_CURRENT_LIST_DIR}/../check.cmake)
function(Process)
    PrepareDep(3.18.1 FIND_BY_HEADER FIND_SUFFIX include/valgrind MODULES valgrind)
    DownloadDep(
            DEP_URL https://sourceware.org/pub/${_DEP_NAME}/${_DEP_NAME}-${_DEP_VER}.tar.bz2
            SPEED_UP_FILE ${_DEP_NAME}-${_DEP_VER}.tar.bz2)
    Autogen()
    Configure()
    MakeBuild()
    MakeInstall()
    PostProcess()
endfunction(Process)
Process()
FindPkgConfig(valgrind)
PrintTargetProperties(valgrind::valgrind)

# link valgrind::valgrind