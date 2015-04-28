library resource_embedder.example.sample;

import 'package:resource_embedder/resource_embedder.dart';

part 'sample.g.dart';

@Resources('../resources')
final d = _$dResources;

@Resources('sample.dart')
final f = _$fResource;

main() {
  print(f.readAsString());
}