import 'reflector.dart';
import 'package:reflectable/reflectable.dart';

class MapConverter {

  Map toMap() {
    InstanceMirror instanceMirror = reflectable.reflect(this);
    var declarations = instanceMirror.type.declarations.values;
    var result = new Map();

    for (var declaration in declarations) {

      if (declaration is MethodMirror) {
        continue;
      }

      result[declaration.simpleName] = instanceMirror.invokeGetter(declaration.simpleName);
    }

    return result;
  }

}