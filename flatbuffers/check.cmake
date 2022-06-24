include(${CMAKE_CURRENT_LIST_DIR}/../check.cmake)
function(Process)
    PrepareDep(2.0.0)
    DownloadDep(AUTHOR google TAG v${_DEP_VER} SPEED_UP_FILE ${_DEP_NAME}-${_DEP_VER}.tar.gz)
    Ninja()
    PostProcess()
endfunction(Process)
Process()
ProcessAddLibrary(EXECUTABLES flatc)

macro(GenerateFlatbuffersMessage target)
    cmake_parse_arguments(ARG "" "OUTPUT;PATH" "FILES" ${ARGN})

    file(GLOB T_FB_FILES ${P_FILES})
    get_property(flatbuffers_binary TARGET flatbuffers::bin::flatc PROPERTY LOCATION)
    foreach (I ${T_FB_FILES})
        execute_process(COMMAND ${flatbuffers_binary} --cpp --scoped-enums --reflect-names --gen-object-api
                -o ${P_OUTPUT} ${I}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "[GenerateFlatbuffersMessage] generate ${I} cpp code failed. [message=${rc}]")
        endif ()
        execute_process(COMMAND ${flatbuffers_binary} --binary --schema -o ${P_OUTPUT} ${I}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "[GenerateFlatbuffersMessage] generate ${I} binary failed. [message=${rc}]")
        endif ()
    endforeach ()
    set(${target}_include ${P_OUTPUT})
    file(GLOB ${target}_src ${P_OUTPUT}/*.h)
    file(GLOB ${target}_binary ${P_OUTPUT}/*.bfbs)
    include_directories(${${target}_include})

    DoUnset(TARGETS T_FB_FILES ARG_OUTPUT ARG_PATH ARG_FILES proto_binary)
endmacro(GenerateFlatbuffersMessage)