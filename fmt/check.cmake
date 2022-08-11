include(${CMAKE_CURRENT_LIST_DIR}/../check.cmake)

function(Process)
    PrepareDep(5.3.0 MODULES fmtd)
    DownloadDep(AUTHOR fmtlib SPEED_UP_FILE ${_DEP_NAME}-${_DEP_VER}.tar.gz)
    Ninja()
    PostProcess()
endfunction(Process)
Process()
ProcessFindPackage(fmt)

# link fmt::fmt