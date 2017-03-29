import 'meta_reflector.dart';
import 'reflector.dart';
import 'package:reflectable/reflectable.dart';

@metareflector
class Json {
  final String name;
  final bool customSerialization;

  /**
   * Если true, исключается из сериализации / десериализации
   */
  final bool exclude;

  const Json(
      {this.name: null, this.customSerialization: false, this.exclude: false});
}

class JsonConverter {
  dynamic fromJson(dynamic json) {

    var instanceMirror = reflectable.reflect(this);
    var declarations = instanceMirror.type.declarations.values;

    for (var declaration in declarations) {

      if (declaration is MethodMirror) {
        continue;
      }

      var jsonName = declaration.simpleName;

      var jsonSerializationMetadata = declaration.metadata.firstWhere((e) =>
      e.runtimeType == Json, orElse: () => null);

      if (jsonSerializationMetadata != null) {
        var jsonSettings = (jsonSerializationMetadata as Json);

        if (jsonSettings.exclude) {
          continue;
        }

        jsonName = jsonSettings.name ?? jsonName; // TODO: сделать красивее
      }

      instanceMirror.invokeSetter(declaration.simpleName, json[jsonName]);
    }

    return this;
  }

  dynamic toJson() {
    var map = new Map();

    var instanceMirror = reflectable.reflect(this);
    var declarations = instanceMirror.type.declarations.values;

    for (DeclarationMirror declaration in declarations) {
      var jsonName = declaration.simpleName;

      var jsonSerializationMetadata = declaration.metadata.firstWhere((e) =>
      e.runtimeType == Json, orElse: () => null);

      if (jsonSerializationMetadata != null) {
        var jsonSettings = (jsonSerializationMetadata as Json);

        if (jsonSettings.exclude) {
          continue;
        }

        jsonName = jsonSettings.name ?? jsonName; // TODO: сделать красивее
      }

      map[jsonName] = instanceMirror.invokeGetter(declaration.simpleName);
    }

    return map;
  }
}