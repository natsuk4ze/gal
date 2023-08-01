## 1.7.0

* Add: Support Android API 21-23.

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