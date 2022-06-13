#!/bin/bash
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

COMMIT_ID=aa46d84646b381da03dd9126015292686bd078da
bash "$BASE/../scripts/pack_git_repo.sh" -r https://github.com/scylladb/seastar.git -v seastar-submodule-${COMMIT_ID} \
  -c ${COMMIT_ID} -w ${BASE}/tmp
