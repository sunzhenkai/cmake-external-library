include(${CMAKE_CURRENT_LIST_DIR}/../check.cmake)
function(Process)
    PrepareDep(7.81.0)
    DownloadDep(TAG ${_DEP_NAME}-${_DEP_VER_} SPEED_UP_FILE ${_DEP_NAME}-${_DEP_NAME}-${_DEP_VER_}.tar.gz)
    AutoReconf()
    Configure(ARGS --with-openssl --enable-shared=no --disable-ldap --disable-ldaps --without-brotli
            --without-libidn --without-libidn2)
    MakeBuild()
    MakeInstall()
    #    AddProject(
    #            DEP_AUTHOR ${_DEP_NAME}
    #            DEP_PROJECT ${_DEP_NAME}
    #            DEP_TAG ${_DEP_NAME}-${_DEP_VER_}
    #            SPEED_UP_FILE ${_DEP_NAME}-${_DEP_NAME}-${_DEP_VER_}.tar.gz
    #            CONFIGURE_DEFINE --with-openssl --enable-shared=no --disable-ldap --disable-ldaps --without-brotli --without-libidn --without-libidn2
    #            AUTO_RE_CONF CONFIGURE MAKE INSTALL)
endfunction(Process)
Process()
ProcessAddLibrary()
