# WARNING dependencies: autoconf automake libtool curl make g++ unzip
function(Process)
    PrepareDeps(3.20.0 MODULES protobuf)
    AddProject(
            DEP_AUTHOR protocolbuffers
            DEP_PROJECT ${_DEP_NAME}
            DEP_TAG v${_DEP_VER}
            SPEED_UP_FILE ${_DEP_NAME}-all-${_DEP_VER}.tar.gz
            CONFIGURE_DEFINE --enable-shared=no
            AUTOGEN CONFIGURE MAKE INSTALL)
endfunction(Process)
Process()
ProcessAddLibrary(EXECUTABLES protoc)

macro(GenerateProtobufMessage target)
    set(options NoneOpt)
    set(oneValueArgs OUTPUT PATH)
    set(multiValueArgs FILES)
    cmake_parse_arguments(P "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    file(GLOB T_PROTO_FILES ${P_FILES})
    get_property(proto_binary TARGET protobuf::bin::protoc PROPERTY LOCATION)
    foreach (I ${T_PROTO_FILES})
        execute_process(COMMAND ${proto_binary} -I ${P_PATH} --cpp_out=${P_OUTPUT} ${I}
                RESULT_VARIABLE rc)
        if (NOT "${rc}" STREQUAL "0")
            message(FATAL_ERROR "[GenerateProtobufMessage] generate ${I} failed. [message=${rc}]")
        endif ()
    endforeach ()
    set(${target}_include ${P_OUTPUT})
    file(GLOB ${target}_src ${P_OUTPUT}/*.cc)
    include_directories(${${target}_include})
endmacro(GenerateProtobufMessage)