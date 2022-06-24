include(${CMAKE_CURRENT_LIST_DIR}/../check.cmake)
function(Process)
    PrepareDep(1.18.1 MODULES cares)
    DownloadDep(TAG cares-${_DEP_VER_} SPEED_UP_FILE ${_DEP_NAME}-cares-${_DEP_VER_}.tar.gz)
    AutoReconf()
    Configure(ARGS --enable-shared=no --enable-static=yes)
    MakeBuild()
    MakeInstall()
    PostProcess()
endfunction(Process)
Process()
ProcessAddLibrary()
