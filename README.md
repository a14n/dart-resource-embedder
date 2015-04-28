# Resource Embedder

[![Build Status](https://travis-ci.org/a14n/dart-resource-embedder.svg?branch=master)](https://travis-ci.org/a14n/dart-resource-embedder)

This project allows to embed files into the sources and to be able to use their contents.

## Configuration and Initialization

### Adding the dependency

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  resource_embedder: any
```

### Adding the generator to your build.dart

A generator is used to automatically insert the resource. You have to add to your `build.dart` file the following code:

```dart
import 'package:resource_embedder/resource_embedder_generator.dart';
import 'package:source_gen/source_gen.dart';

void main(List<String> args) {
  build(args, [new ResourcesGenerator()],
      librarySearchPaths: ['lib', 'example', 'test']).then(print);
}
```

Thanks to the [source_gen package](https://pub.dartlang.org/packages/source_gen) every change in a file monitored will trigger the generator. In the above example any change in the `lib` folder will be observed. The generated content will land in a part file with a suffix `*.g.dart`. You only have to add this part to your library.

## Usage

### Embed a file

First you need to declare a top level variable annotated with `@Resource($path)` where `$path` is a file or a directory.

```dart
@Resources('../resources/f1.txt')
final simpleFile = _$simpleFileResource;
```

The Right hand side variable is defined in the generated part `*.g.dart` aside your current dart file. It defines a `Resource` containing the path and the content of the file.

### Embed a directory

When a directory is used as `$path` the variable is actually a `List<Resource>` and the generated variable ends with a `s`.

```dart
@Resources('../resources/')
final directory = _$directoryResources;
```

By default the files in the directory are retrieve with a `dir.list(recursive: true, followLinks: true)`. You can tweak this behaviour by providing named parameters on `@Resource`:

```dart
@Resources('../resources/', recursive: false, followLinks: false)
final directory = _$directoryResources;
```

You can also exclude some files or directory by providing some glob pattern:

```dart
@Resources('../resources', ignore: const <String>['*2.txt'])
final directory = _$directoryResources;
```

## License
Apache 2.0
