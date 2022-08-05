include(${CMAKE_CURRENT_LIST_DIR}/../check.cmake)

function(Process)
    PrepareDep(3.10.5 FIND_BY_HEADER FIND_SUFFIX include/nlohmann MODULES json)
    DownloadDep(AUTHOR nlohmann TAG v${_DEP_VER} SPEED_UP_FILE ${_DEP_NAME}-${_DEP_VER}.tar.gz)
    Ninja()
    PostProcess()
endfunction(Process)
Process()
ProcessFindPackage(nlohmann_json)

# link nlohmann_json::nlohmann_json