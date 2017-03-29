import 'meta_reflector.dart';
import 'reflector.dart';
import 'base_converter.dart';
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

class JsonConverter extends BaseConverter {
  void _setValue(InstanceMirror instanceMirror, String variableName,
      Type variableType, dynamic jsonValue) {
    if (variableType == double) {
      instanceMirror.invokeSetter(
          variableName,
          double.parse(
              jsonValue.toString())); // FIXME: написать нормальный биндер
    } else {
      instanceMirror.invokeSetter(variableName, jsonValue);
    }
  }

  Json getJsonSettings(List<Object> metadata) {
    if (metadata == null) return null;

    var jsonSerializationMetadata =
        metadata.firstWhere((e) => e.runtimeType == Json, orElse: () => null);

    if (jsonSerializationMetadata == null) return null;

    return (jsonSerializationMetadata as Json);
  }

  dynamic fromJson(dynamic json) {
    bool jsonIsMap = json is Map;

    InstanceMirror instanceMirror = reflectable.reflect(this);

    var declarations = BaseConverter.getDeclarations(instanceMirror.type);

    for (var declaration in declarations.values) {
      if (!(declaration is VariableMirror)) {
        continue;
      }

      var jsonName = declaration.simpleName;

      Json jsonSettings = getJsonSettings(declaration.metadata);

      if (jsonSettings != null) {
        if (jsonSettings.exclude) {
          continue;
        }

        jsonName = jsonSettings.name ?? jsonName; // TODO: сделать красивее
      }

      if (jsonIsMap && (json as Map).containsKey(jsonName)) {
        var variableType = (declaration as VariableMirror).reflectedType;
        _setValue(instanceMirror, declaration.simpleName, variableType,
            json[jsonName]);
      } else if (!jsonIsMap) {
        instanceMirror.invokeSetter(declaration.simpleName, json[jsonName]);
      }
    }

    return this;
  }

  Map toJson() {
    var map = new Map();

    InstanceMirror instanceMirror = reflectable.reflect(this);

    var declarations = BaseConverter.getDeclarations(instanceMirror.type);

    for (var declaration in declarations.values) {
      if (!(declaration is VariableMirror)) {
        continue;
      }

      var jsonName = declaration.simpleName;

      Json jsonSettings = getJsonSettings(declaration.metadata);

      if (jsonSettings != null) {
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
