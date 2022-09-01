#!/bin/bash
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

COMMIT_ID=27c3a8dc0e2c9218fe94986d249a12b5ed838f1d
REPO='https://github.com/Tencent/rapidjson.git'
NAME=rapidjson
bash "$BASE/../scripts/pack_git_repo.sh" -r ${REPO} -v ${NAME}-submodule-${COMMIT_ID} \
  -c ${COMMIT_ID} -w ${BASE}/tmp
