function(Process)
    PrepareDeps(5.3.0 MODULES fmt)
    AddProject(
            DEP_AUTHOR fmtlib
            DEP_PROJECT ${_DEP_NAME}
            DEP_TAG v${_DEP_VER}
            SPEED_UP_FILE ${_DEP_NAME}-${_DEP_VER}.tar.gz
            NINJA)
endfunction(Process)
Process()
ProcessAddLibrary()
