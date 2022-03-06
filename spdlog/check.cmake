function(Process)
    # set basic variables
    get_filename_component(_DEP_NAME ${CMAKE_CURRENT_LIST_DIR} NAME)
    string(TOUPPER ${_DEP_NAME} _DEP_UNAME)
    set(_DEP_CUR_DIR ${CMAKE_CURRENT_LIST_DIR})
    set(_DEP_VER 1.9.2)
    set(_NEED_REBUILD TRUE)
    set(_DEP_PREFIX ${CMAKE_CURRENT_LIST_DIR})
    set(_EXTERNAL_VARS)

    SetDepPrefix()
    CheckVersionV2()
    CheckLibExists()

    message(STATUS "[${_DEP_NAME}] set prefix and check version done. "
            "[_NEED_REBUILD=${_NEED_REBUILD}, _LIB_DOES_NOT_EXISTS=${_LIB_DOES_NOT_EXISTS}]")
    if ((${_NEED_REBUILD}) OR (${_LIB_DOES_NOT_EXISTS}))
        DownloadDepV2(gabime)
        ExtractDep()
        CMakeNinja()
        NinjaBuild()
        NinjaInstall()
    endif ()

    SetDepPath()
    AppendCMakePrefix()
    message(STATUS "[${_DEP_NAME}] build done. [_EXTERNAL_VARS=${_EXTERNAL_VARS}]")

    # set external variables
    foreach (_V IN LISTS _EXTERNAL_VARS)
        set(${_V} ${${_V}})
    endforeach ()
endfunction(Process)

Process()
find_package(spdlog REQUIRED)
