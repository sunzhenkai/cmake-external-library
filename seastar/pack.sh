#!/bin/bash
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# 20.05 59f7b32d892191bfae336afcdf6a6d4bd236c183
# 19.06 aa46d84646b381da03dd9126015292686bd078da
# 18.08 7dea64159e2b4a27a740e15d76665e7fccd1d689
COMMIT_ID=7dea64159e2b4a27a740e15d76665e7fccd1d689
bash "$BASE/../scripts/pack_git_repo.sh" -r https://github.com/scylladb/seastar.git -v seastar-submodule-${COMMIT_ID} \
  -c ${COMMIT_ID} -w ${BASE}/tmp
