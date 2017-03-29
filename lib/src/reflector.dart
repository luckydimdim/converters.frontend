import 'package:reflectable/reflectable.dart';

// Annotate with this class to enable reflection.
class Reflector extends Reflectable {
  const Reflector()
      : super(
            instanceInvokeCapability,
            declarationsCapability,
            superclassQuantifyCapability,
            typeRelationsCapability,
            typeCapability,
            reflectedTypeCapability,
            metadataCapability); // Request the capability to invoke methods.
}

const reflectable = const Reflector();
