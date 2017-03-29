import 'package:reflectable/reflectable.dart';

// Reflector for annotation
class MetaReflector extends Reflectable {
  const MetaReflector() : super(metadataCapability);
}

const metareflector = const MetaReflector();
