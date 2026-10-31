#!/usr/bin/env bash
# Regenerates packages/turbo_api/generated from api/openapi.yaml. Never hand-edit the output.
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
root="$(cd "$here/../.." && pwd)"
out="$here/generated"
rm -rf "$out"
(cd "$root" && npx openapi-generator-cli generate \
  -i api/openapi.yaml \
  -g dart-dio \
  -o "$out" \
  --additional-properties=pubName=turbo_api_generated,pubAuthor=Turbo,serializationLibrary=json_serializable,nullSafe=true)
# The generator targets an old SDK; the output uses newer syntax (null-aware elements).
sed -i.bak "s/^  sdk: .*/  sdk: ^3.13.3/" "$out/pubspec.yaml"
rm -f "$out"/*.bak
(cd "$out" && dart pub get && dart run build_runner build --delete-conflicting-outputs)
