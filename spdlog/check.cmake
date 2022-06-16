function(Process)
    PrepareDeps(1.9.2 MODULES spdlog)
    AddProject(
            DEP_AUTHOR gabime
            DEP_PROJECT ${_DEP_NAME}
            DEP_TAG v${_DEP_VER}
            SPEED_UP_FILE ${_DEP_NAME}-${_DEP_VER}.tar.gz
            NINJA)
endfunction(Process)
Process()
ProcessAddLibrary()
