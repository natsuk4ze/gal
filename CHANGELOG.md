## 2.2.0

* ADD: PlatformInterface #180
* FIX: package download size 1MB to 0.5MB #181

## 2.1.4

* FIX: package download size 6MB to 1MB #175

## 2.1.3

* FIX: Compilation error on Windows in some environments #166

## 2.1.2

* UPDATE: document comments #158
* UPDATE: metadata for pub.dev #158 

## 2.1.1

* UPDATE: `putImageBytes` for Improving performance on windows #155
* FIX: `putImageBytes` for saving .tiff on windows #154

## 2.1.0

* **ADD: windows support** #148

## 2.0.0

* **ADD: macOS support** #142
* **BREAKING CHANGE**: `flutter: '>=3.3.0'` to `flutter: '>=3.7.0'` #142
* **BREAKING CHANGE**: `GalException.error` to `GalException.platformException` #143
* **BREAKING CHANGE**:  Remove `GalExceptionType.notHandle` (had marked deprecated) #144 

## 1.9.1

* FIX: `album` option is not working on Android API 29 #130
* UPDATE: Permission behavior in Android API 29 with `album` option #133

## 1.9.0

* ADD: Support for AGP 8 #118

## 1.8.6

* UPDATE: Keep file name when saving #115
* UPDATE: README.md

## 1.8.5

* UPDATE: `putImageBytes` in iOS to get metadata 

## 1.8.4

* FIX: file auto conversion #105 

## 1.8.3

* FIX: dart format

## 1.8.2

* FIX: `put-` does not run with Future #96
* FIX: `put-` with album and user selects 'selected photos' in permission dialog #95
* ADD: `requestAccess` when called `put-` #97 

## 1.8.1

* REMOVE: plugin_platform_interface #84
* FIX: example with toAlbum
* UPDATE: example in readme
* UPDATE: assets in example
* UPDATE: `GalException` error messages

## 1.8.0

* FEAT: Gal supports album option for saving medias. **iOS needs additional permission settings, see latest README or [wiki](https://github.com/natsuk4ze/gal/wiki/Permissions)**.

## 1.7.0

* ADD: Support Android API 21-23.

## 1.6.3

* FIX: Crashing on permission requests for other packages.

## 1.6.2

* FIX: Returning false when permission granted by default when calling `hasAccess()`,`requestAccess()` in Android.
* UPDATE: Include maxSdkVersion as a key to write in AndroidManifest. *It is not necessary, but it is recommended.

## 1.6.1

* UPDATE: We have made a stronger typing. `Gal`,`GalException`,`MethodChannelGal` has `@immutable` now.
* UPDATE: update README.

## 1.6.0

* UPDATE: Significantly improved error handling for low iOS versions. As a result, `GalExceptionType.notHandle` is now `@Deprecated` and will be removed in the next major version.

## 1.5.0

* FEAT: Add `putImageBytes()`. This allows saving image from memory.

## 1.4.1

* UPDATE: update README.

## 1.4.0

* UPDATE: `Gal`is `final` now.
* UPDATE: add export file.
* UPDATE: add ios `NOT_SUPPORTED_FORMAT` condition.

## 1.3.6

* UPDATE: add error info on throw.
* UPDATE: clean up native codes.
* UPDATE: update README.

## 1.3.5

* UPDATE: fix example.
* UPDATE: update README.

## 1.3.4

* UPDATE: update code docs.
* UPDATE: update README.

## 1.3.3

* FIX: fix README 

## 1.3.2

* FIX: remove `android:requestLegacyExternalStorage="true"` 

## 1.3.1

* FIX: fix README
* UPDATE: make gal constractor private

## 1.3.0

* FEAT: Add permissionhandlings. Now you can use `hasAccess()`,`requestAccess()`.

## 1.2.0

* UPDATE: remove url_launcher and android_intent_plus

## 1.1.2

* FIX: fix README

## 1.1.1

* UPDATE: add examples

## 1.1.0

* FEAT: add error handlings

## 1.0.7

* UPDATE: transfer repo

## 1.0.6

* UPDATE: update README

## 1.0.5

* FIX: refactor

## 1.0.4

* FIX: update README

## 1.0.3

* FIX: update README

## 1.0.2

* FIX: update README

## 1.0.1

* FIX: update README

## 1.0.0

* FEAT: saving image

## 0.0.5

* UPDATE: update README

## 0.0.4

* FIX: fix CHANGELOG

## 0.0.3

* UPDATE: dartdoc comments

## 0.0.2

* UPDATE: update description field of pubspec.yaml

## 0.0.1

* Initial Release
