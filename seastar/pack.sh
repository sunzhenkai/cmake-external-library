#!/bin/bash
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

COMMIT_ID=8783e005c93f9fc6b48e9a12e08cd6fb5d543c82
bash "$BASE/../scripts/pack_git_repo.sh" -r https://github.com/scylladb/seastar.git -v seastar-submodule-${COMMIT_ID} \
  -c ${COMMIT_ID}
