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

library resource_embedder;

import 'dart:convert';

import 'package:crypto/crypto.dart' show CryptoUtils;

/// A metadata annotation to indicate what resource to embed.
class Resources {
  /// The path where the resource files are.
  final String path;
  /// The list of glob patterns to ignore.
  final List<String> ignore;
  final bool recursive;
  final bool followLinks;

  const Resources(this.path,
      {this.ignore, this.recursive: true, this.followLinks: true});
}

/// The resource corresponding to a file.
class Resource {
  final String path;
  final String contentInBase64;

  const Resource(this.path, this.contentInBase64);

  /// Read the entire file contents as a list of bytes.
  List<int> readAsBytes() => CryptoUtils.base64StringToBytes(contentInBase64);

  /// Read the entire file contents as a string using the given [Encoding].
  String readAsString({Encoding encoding: UTF8}) =>
      encoding.decode(readAsBytes());
}
