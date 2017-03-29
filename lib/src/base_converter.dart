import 'meta_reflector.dart';
import 'reflector.dart';
import 'package:reflectable/reflectable.dart';

class BaseConverter {
  static bool _isReflectable(ClassMirror classMirror) {
    var reflectorMetadata = classMirror.metadata
        .firstWhere((e) => e.runtimeType == Reflector, orElse: () => null);

    return reflectorMetadata != null;
  }

  static Map<String, DeclarationMirror> getDeclarations(
      ClassMirror classMirror) {
    var result = new Map<String, DeclarationMirror>();

    result.addAll(classMirror.declarations);

    if (_isReflectable(classMirror.superclass)) {
      result.addAll(getDeclarations(classMirror.superclass));
    }

    return result;
  }
}
