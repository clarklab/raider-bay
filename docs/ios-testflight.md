# iOS TestFlight Build

Raider Bay has an `iOS TestFlight` Godot export preset and a GitHub Actions workflow at `.github/workflows/build-ios-testflight.yml`.

## What Apple Requires

- A paid Apple Developer Program membership.
- An App Store Connect app using bundle ID `com.clarklab.raiderbay`.
- Xcode 26 or newer for App Store Connect/TestFlight uploads.
- An Apple Distribution signing certificate.
- An App Store distribution provisioning profile for `com.clarklab.raiderbay`.
- An App Store Connect API key with permission to upload builds.

## GitHub Secrets

Add these in GitHub under `Settings > Secrets and variables > Actions`.

- `APPLE_TEAM_ID`: Your 10-character Apple Developer Team ID.
- `BUILD_CERTIFICATE_BASE64`: Base64 text for the `.p12` Apple Distribution certificate.
- `P12_PASSWORD`: Password used when exporting the `.p12`.
- `BUILD_PROVISION_PROFILE_BASE64`: Base64 text for the App Store `.mobileprovision` profile.
- `APP_STORE_CONNECT_API_KEY_ID`: API key ID from App Store Connect.
- `APP_STORE_CONNECT_API_ISSUER_ID`: Issuer ID from App Store Connect.
- `APP_STORE_CONNECT_API_KEY_BASE64`: Base64 text for the `AuthKey_XXXXXXXXXX.p8` file.

On macOS, copy files into GitHub secrets with:

```sh
base64 -i /path/to/certificate.p12 | pbcopy
base64 -i /path/to/profile.mobileprovision | pbcopy
base64 -i /path/to/AuthKey_XXXXXXXXXX.p8 | pbcopy
```

## Run The Build

1. Open GitHub Actions.
2. Choose `Build iOS TestFlight`.
3. Click `Run workflow`.
4. Leave `upload_to_testflight` on when you want the IPA sent to TestFlight.

The workflow uses GitHub's `macos-26` runner so the build is created with the current Xcode/iOS SDK required by Apple.
