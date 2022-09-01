include(${CMAKE_CURRENT_LIST_DIR}/../check.cmake)

function(Process)
    set(TAG 27c3a8dc0e2c9218fe94986d249a12b5ed838f1d)
    PrepareDep(${TAG} MODULES rapidjson)
    DownloadDep(GIT_REPOSITORY https://github.com/Tencent/rapidjson.git
            SPEED_UP_FILE ${_DEP_NAME}-submodule-${_DEP_VER}.tar.gz)
    #    Ninja()
    PostProcess()
endfunction(Process)
Process()
ProcessFindPackage(nlohmann_json)
