function(Process)
    PrepareDeps(1_1_1k MODULES ssl crypto)
    AddProject(
            DEP_AUTHOR ${_DEP_NAME}
            DEP_PROJECT ${_DEP_NAME}
            DEP_TAG OpenSSL_${_DEP_VER}
            OSS_FILE ${_DEP_NAME}-OpenSSL_${_DEP_VER}.tar.gz
            CONFIGURE MAKE INSTALL)
endfunction(Process)
Process()
ProcessAddLibrary()
