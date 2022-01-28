# TODOs
- specify deps version by variables

# requirements
- gcc 8+

# dependencies
- valgrind

## install
```shell
# yum install -y valgrind-devel
```

# deps
## snappy
```shell
# put snappy deps dir into CMAKE_PREFIX_PATH
find_package(Snappy REQUIRED)
target_link_libraries(<target> Snappy::snappy)
```