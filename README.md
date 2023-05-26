# Gal💚

Hi👋 Gal is Flutter Plugin for handle native gallery apps.

## Features

* Open native gallery app.
* Save video to native gallery app.
* TODO: Save image to native gallery app.

## Installation

First, add `gal` as a
[dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

### iOS

Add the following key to your _Info.plist_ file, located in
`<project root>/ios/Runner/Info.plist`:

* `NSPhotoLibraryAddUsageDescription` - you can copy from [Info.plist in example](https://github.com/Midori-Design-Studio/gal/blob/main/example/ios/Runner/Info.plist).

### Android (<10)

For less than Android 10, add the following keys to your _AndroidManifest.xml_ file, located in
`<project root>/android/app/src/main/AndroidManifest.xml`:

* `android:requestLegacyExternalStorage="true"` - you can copy from [AndroidManifest.xml in example](https://github.com/Midori-Design-Studio/gal/blob/main/example/android/app/src/main/AndroidManifest.xml).


## Example

``` dart
import 'package:flutter/material.dart';

import 'package:gal/gal.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            "Gal Example 💚",
            style: Theme.of(context).textTheme.titleLarge,
          )),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                onPressed: () async => Gal.open(),
                label: const Text('Open Gallery'),
                icon: const Icon(Icons.open_in_new),
              ),
              FilledButton.icon(
                onPressed: () async => Gal.putVideo('TODO: Change this text to video path'),
                label: const Text('Save Video'),
                icon: const Icon(Icons.download),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Contributing

Welcome💚 Feel free to create Issue or PR. Basically, please follows [Effective Dart](https://dart.dev/effective-dart).
