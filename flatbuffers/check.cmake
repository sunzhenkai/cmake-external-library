function(Process)
    PrepareDeps(2.0.0 MODULES flatbuffers)
    AddProject(
            DEP_AUTHOR google
            DEP_PROJECT ${_DEP_NAME}
            DEP_TAG v${_DEP_VER}
            SPEED_UP_FILE ${_DEP_NAME}-${_DEP_VER}.tar.gz
            NINJA)
endfunction(Process)
Process()
ProcessAddLibrary(EXECUTABLES flatc)

macro(GenerateFlatbuffersMessage target)
    set(options NoneOpt)
    set(oneValueArgs OUTPUT PATH)
    set(multiValueArgs FILES)
    cmake_parse_arguments(P "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

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
endmacro(GenerateFlatbuffersMessage)