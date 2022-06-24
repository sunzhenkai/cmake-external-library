include(${CMAKE_CURRENT_LIST_DIR}/../check.cmake)
# WARNING dependencies: autoconf automake libtool curl make g++ unzip
function(Process)
    PrepareDep(3.20.0 MODULES protobuf)
    DownloadDep(AUTHOR protocolbuffers TAG v${_DEP_VER} SPEED_UP_FILE ${_DEP_NAME}-all-${_DEP_VER}.tar.gz)
    Autogen()
    Configure(ARGS --enable-shared=no)
    MakeBuild()
    MakeInstall()
    PostProcess()
endfunction(Process)
Process()
ProcessAddLibrary(EXECUTABLES protoc)

macro(GenerateProtobufMessage target)
    cmake_parse_arguments(ARG "" "OUTPUT;PATH" "FILES" ${ARGN})

    file(GLOB T_PROTO_FILES ${ARG_FILES})
    get_property(proto_binary TARGET protobuf::bin::protoc PROPERTY LOCATION)
    foreach (I ${T_PROTO_FILES})
        execute_process(COMMAND ${proto_binary} -I ${ARG_PATH} --cpp_out=${ARG_OUTPUT} ${I}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "[GenerateProtobufMessage] generate ${I} failed. [message=${rc}]")
        endif ()
    endforeach ()
    set(${target}_include ${ARG_OUTPUT})
    file(GLOB ${target}_src ${ARG_OUTPUT}/*.cc)
    include_directories(${${target}_include})

    DoUnset(TARGETS ARG_OUTPUT ARG_PATH ARG_FILES proto_binary)
endmacro(GenerateProtobufMessage)