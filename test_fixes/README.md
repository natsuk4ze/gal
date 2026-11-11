## Directory contents

The Dart files and the golden `.expect` files in this directory test the
[`dart fix`](https://dart.dev/tools/dart-fix) migrations in
`lib/fix_data.yaml`.

To run the tests, run this command in this directory:

```sh
dart fix --compare-to-golden
```

The files use the old API on purpose, so the root `analysis_options.yaml`
excludes this directory.

For more about data-driven fixes, see
https://dart.dev/go/data-driven-fixes#test-folder.
