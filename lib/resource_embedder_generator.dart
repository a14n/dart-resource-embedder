// Copyright (c) 2015, Alexandre Ardhuin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library resource_embedder_generator;

import 'dart:async';
import 'dart:io';

import 'package:analyzer/src/generated/element.dart';
import 'package:analyzer/src/generated/source_io.dart';
import 'package:crypto/crypto.dart' show CryptoUtils;
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

import 'resource_embedder.dart';

class ResourcesGenerator extends GeneratorForAnnotation<Resources> {
  const ResourcesGenerator();

  @override
  Future<String> generateForAnnotatedElement(
      Element element, Resources annotation) async {
    if (p.isAbsolute(annotation.path)) {
      throw 'must be relative path to the source file';
    }

    var source = element.source as FileBasedSource;
    var sourcePath = source.file.getAbsolutePath();

    var sourcePathDir = p.dirname(sourcePath);

    var path = p.join(sourcePathDir, annotation.path);

    if (await FileSystemEntity.isFile(path)) {
      var file = new File(path);
      return 'const _\$${element.displayName}Resource = ' +
          await getResourceDeclaration(file, p.basename(path)) +
          ';';
    } else if (await FileSystemEntity.isDirectory(path)) {
      var dir = new Directory(path);
      var files = await dir
          .list(
              recursive: annotation.recursive,
              followLinks: annotation.followLinks)
          .where((fse) => fse is File);
      var result =
          'const _\$${element.displayName}Resources = const <Resource>[';
      await for (File file in files) {
        var relativePath = p.relative(file.path, from: dir.path);
        if (accept(relativePath, annotation.ignore)) {
          result += await getResourceDeclaration(file, relativePath) + ',';
        }
      }
      result += '];';
      return result;
    }

    throw 'Not supported! - $path';
  }

  bool accept(String relativePath, List<String> ignore) {
    if (ignore == null) return true;
    for (final pattern in ignore) {
      if (new Glob(pattern).matches(relativePath)) {
        return false;
      }
    }
    return true;
  }

  Future<String> getResourceDeclaration(File file, String path) async {
    var bytes = await file.readAsBytes();
    var contentInBase64 = CryptoUtils.bytesToBase64(bytes);
    return "const Resource('$path', '$contentInBase64')";
  }
}
