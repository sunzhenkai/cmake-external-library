include(${CMAKE_CURRENT_LIST_DIR}/../gflags/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../leveldb/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../thrift/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../boost/check.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../snappy/check.cmake)

function(Process)
    PrepareDeps(1.1.0 MODULES brpc)
    AddProject(
            DEP_AUTHOR apache
            DEP_PROJECT ${_DEP_NAME}
            DEP_TAG v${_DEP_VER}
            SPEED_UP_FILE ${_DEP_NAME}-${_DEP_VER}.tar.gz
            NINJA)
endfunction(Process)
Process()
ProcessAddLibrary()