#!/bin/bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <version>" >&2
    exit 64
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
version="${1#v}"
build_dir="$(mktemp -d "${TMPDIR:-/tmp}/shakewellerer-build.XXXXXX")"
stage_dir="$(mktemp -d "${TMPDIR:-/tmp}/shakewellerer-stage.XXXXXX")"

cleanup() {
    rm -rf "$build_dir" "$stage_dir"
}
trap cleanup EXIT

output_dir="$repo_root/dist"
workflow_output="$output_dir/ShakeWellerer.alfredworkflow"
binary_output="$output_dir/ShakeWellerer"

rm -rf "$output_dir"
mkdir -p "$output_dir"

for arch in arm64 x86_64; do
    arch_build_dir="$build_dir/$arch"
    xcrun swift build \
        --package-path "$repo_root" \
        --scratch-path "$arch_build_dir" \
        -c release \
        --arch "$arch"
done

xcrun lipo -create \
    "$build_dir/arm64/out/Products/Release/ShakeWellerer" \
    "$build_dir/x86_64/out/Products/Release/ShakeWellerer" \
    -output "$stage_dir/ShakeWellerer"

cp "$repo_root/workflow/info.plist" "$stage_dir/info.plist"
cp "$repo_root/workflow/icon.png" "$stage_dir/icon.png"
chmod 755 "$stage_dir/ShakeWellerer"

plutil -replace version -string "$version" "$stage_dir/info.plist"
codesign --force --sign - "$stage_dir/ShakeWellerer"
plutil -lint "$stage_dir/info.plist"

cp "$stage_dir/ShakeWellerer" "$binary_output"
(
    cd "$stage_dir"
    zip -qry "$workflow_output" .
)

file "$binary_output"
unzip -tq "$workflow_output"
