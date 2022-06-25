include(${CMAKE_CURRENT_LIST_DIR}/../check.cmake)
function(Process)
    PrepareDep(1.1.9)
    DownloadDep(GIT_REPOSITORY https://github.com/google/snappy.git
            SPEED_UP_FILE ${_DEP_NAME}-submodule-${_DEP_VER}.tar.gz)
    Ninja(PIC_OFF TRUE)
    PostProcess()
endfunction(Process)
Process()
ProcessAddLibrary()