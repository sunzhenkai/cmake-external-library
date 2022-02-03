#!/bin/bash
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

COMMIT_ID=1433623962e6abca03dd23ebd1909f9b1a4fce2a
bash "$BASE/../scripts/pack_git_repo.sh" -r https://gitee.com/mirrors/seastar.git -v seastar-submodule-${COMMIT_ID} \
  -c ${COMMIT_ID}
