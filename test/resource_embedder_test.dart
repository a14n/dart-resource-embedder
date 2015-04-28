library test.rational;

import 'package:test/test.dart';
import 'package:resource_embedder/resource_embedder.dart';

part 'resource_embedder_test.g.dart';

@Resources('../resources/f1.txt')
final simpleFile = _$simpleFileResource;

@Resources('../resources')
final filesInDirectory = _$filesInDirectoryResources;

@Resources('../resources', recursive: false)
final filesInDirectoryWithoutSubFolders =
    _$filesInDirectoryWithoutSubFoldersResources;

@Resources('../resources', ignore: const <String>['*2.txt'])
final filesWithIgnore = _$filesWithIgnoreResources;

main() {
  test('a simple file is embedded', () {
    expect(simpleFile, new isInstanceOf<Resource>());
    expect(simpleFile.path, "f1.txt");
    expect(simpleFile.readAsString(), "f1");
  });

  test('all files in a directory are recursively embedded', () {
    expect(filesInDirectory, new isInstanceOf<List<Resource>>());
    expect(filesInDirectory.length, equals(3));
    expect(filesInDirectory.map((e) => e.path), [
      "folder/f3.txt",
      "f1.txt",
      "f2.txt",
    ]);
    expect(filesInDirectory[0].readAsString(), "f3");
    expect(filesInDirectory[1].readAsString(), "f1");
    expect(filesInDirectory[2].readAsString(), "f2");
  });

  test('`recursive: false` allows to embed only direct children', () {
    expect(filesInDirectoryWithoutSubFolders.length, equals(2));
    expect(filesInDirectoryWithoutSubFolders.map((e) => e.path), [
      "f1.txt",
      "f2.txt",
    ]);
  });

  test('`ignore` allows to exclude some files', () {
    expect(filesWithIgnore.length, equals(2));
    expect(filesWithIgnore.map((e) => e.path), ["folder/f3.txt", "f1.txt",]);
  });
}
