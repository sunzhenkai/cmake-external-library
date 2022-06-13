#!/bin/bash
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

COMMIT_ID=5a68003f0385d9dc3d25d50ffb7a9a50cf7c2206
bash "$BASE/../scripts/pack_git_repo.sh" -r https://github.com/scylladb/seastar.git -v seastar-submodule-${COMMIT_ID} \
  -c ${COMMIT_ID} -w ${BASE}/tmp
