include(${CMAKE_CURRENT_LIST_DIR}/../check.cmake)

function(Process)
    PrepareDep(3.10.5 FindByHeader FindPathSuffix include/nlohmann MODULES json)
    DownloadDep(AUTHOR nlohmann TAG v${_DEP_VER} SPEED_UP_FILE ${_DEP_NAME}-${_DEP_VER}.tar.gz)
    Ninja()
endfunction(Process)
Process()
ProcessFindPackage(nlohmann_json)