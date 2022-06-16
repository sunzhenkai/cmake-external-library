function(Process)
    PrepareDeps(2.10 MODULES tcmalloc tcmalloc_minimal tcmalloc_and_profiler)
    AddProject(
            DEP_AUTHOR ${_DEP_NAME}
            DEP_PROJECT ${_DEP_NAME}
            DEP_TAG v${_DEP_VER}
            SPEED_UP_FILE ${_DEP_NAME}-${_DEP_VER}.tar.gz
            NINJA)
endfunction(Process)
Process()
ProcessAddLibrary()