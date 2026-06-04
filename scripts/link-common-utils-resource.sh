#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <resource-directory>" >&2
  echo "Example: $0 scripts/event_bus" >&2
  exit 2
fi

resource_path="${1%/}"
repo_root="$(git rev-parse --show-toplevel)"
common_utils_dir="$repo_root/vendor/gamemaker-common-utils"
local_path="$repo_root/$resource_path"
vendor_path="$common_utils_dir/$resource_path"
backup_root="${FANTASMA_COMMON_UTILS_BACKUP_ROOT:-/private/tmp/fantasma-common-utils-backup/$(date +%Y%m%d-%H%M%S)}"

if [[ ! -d "$common_utils_dir" ]]; then
  echo "Missing submodule directory: $common_utils_dir" >&2
  exit 1
fi

if [[ ! -d "$vendor_path" ]]; then
  echo "Missing vendor resource directory: $vendor_path" >&2
  exit 1
fi

if [[ -L "$local_path" ]]; then
  echo "Already linked: $resource_path -> $(readlink "$local_path")"
  exit 0
fi

if [[ ! -d "$local_path" ]]; then
  echo "Missing local resource directory: $local_path" >&2
  exit 1
fi

case "$resource_path" in
  scripts/*|objects/*)
    ;;
  *)
    echo "Unsupported path for this helper: $resource_path" >&2
    echo "Expected a one-level scripts/* or objects/* resource directory." >&2
    exit 1
    ;;
esac

mkdir -p "$backup_root/$(dirname "$resource_path")"
mv "$local_path" "$backup_root/$resource_path"

parent_dir="$(dirname "$resource_path")"
resource_name="$(basename "$resource_path")"
ln -s "../vendor/gamemaker-common-utils/$resource_path" "$repo_root/$parent_dir/$resource_name"

echo "Backed up $resource_path to $backup_root/$resource_path"
echo "Linked $resource_path -> $(readlink "$local_path")"
