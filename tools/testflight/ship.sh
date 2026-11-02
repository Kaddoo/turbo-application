#!/bin/bash
# Builds both apps against the staging API and uploads them to App Store Connect (TestFlight), student app first.
# Before running: bump `version: 1.0.0+N` in apps/student_app/pubspec.yaml and apps/driver_app/pubspec.yaml (N must be higher than the last upload),
# and make sure Xcode is signed in to the Apple account for team M7TM8A4V9S (the upload uses that session; "missing Xcode-Token" means sign in again).
# Needs apps/*/ios/Runner/GoogleService-Info.plist and apps/*/ios/Flutter/Secrets.xcconfig on this machine (both git-ignored).
# Usage: tools/testflight/ship.sh            (takes about 15 minutes; run it in the background)
set -u
here="$(cd "$(dirname "$0")" && pwd)"
root="$(cd "$here/../.." && pwd)"
out="${TMPDIR:-/tmp}/turbo-testflight"
mkdir -p "$out"
for d in student_app driver_app; do
  echo "== $d build"
  (cd "$root/apps/$d" && flutter build ipa --release --dart-define=API_BASE_URL=https://api.turbogh.app --export-options-plist="$here/export.plist" 2>&1 | grep -E "✓ Built IPA|rror")
  echo "== $d upload"
  (cd "$root/apps/$d" && xcodebuild -exportArchive -archivePath build/ios/archive/Runner.xcarchive -exportOptionsPlist "$here/upload.plist" -exportPath "$out/up_$d" -allowProvisioningUpdates 2>&1 | grep -E "Upload succeeded|EXPORT|error:")
done
echo ALL DONE
