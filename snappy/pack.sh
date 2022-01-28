#!/bin/bash
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

bash "$BASE/../scripts/pack_git_repo.sh" -r https://github.com/google/snappy.git -v submodule-snappy-1.1.9 -t 1.1.9