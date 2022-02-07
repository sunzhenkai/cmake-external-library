#!/bin/bash
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

COMMIT_ID=368865a2b867922655179f9f2249a8ac4b15854f
#bash "$BASE/../scripts/pack_git_repo.sh" -r https://gitee.com/mirrors/seastar.git -v seastar-submodule-${COMMIT_ID} \
bash "$BASE/../scripts/pack_git_repo.sh" -r https://github.com/scylladb/seastar.git -v seastar-submodule-${COMMIT_ID} \
  -c ${COMMIT_ID}
