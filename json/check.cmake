function(Process)
    PrepareDeps(3.10.5 FindByHeader
            FindPathSuffix include/nlohmann
            MODULES json)
    AddProject(
            DEP_AUTHOR nlohmann
            DEP_PROJECT ${_DEP_NAME}
            DEP_TAG v${_DEP_VER}
            OSS_FILE ${_DEP_NAME}-${_DEP_VER}.tar.gz
            NINJA)
endfunction(Process)
Process()
ProcessFindPackage(nlohmann_json)