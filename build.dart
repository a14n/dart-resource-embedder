library source_gen.build_file;

import 'package:resource_embedder/resource_embedder_generator.dart';
import 'package:source_gen/source_gen.dart';

void main(List<String> args) {
  build(args, [new ResourcesGenerator()],
      librarySearchPaths: ['example', 'test']).then(print);
}
