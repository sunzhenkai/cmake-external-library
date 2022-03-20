function(Process)
    PrepareDeps(7.81.0 MODULES curl)
    AddProject(
            DEP_AUTHOR ${_DEP_NAME}
            DEP_PROJECT ${_DEP_NAME}
            DEP_TAG ${_DEP_NAME}-${_DEP_VER_}
            OSS_FILE ${_DEP_NAME}-${_DEP_NAME}-${_DEP_VER_}.tar.gz
            CONFIGURE_DEFINE --with-openssl --enable-shared=no
            AUTO_RE_CONF MAKE INSTALL)
endfunction(Process)
Process()
ProcessAddLibrary()
