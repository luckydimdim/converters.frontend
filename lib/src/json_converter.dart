import 'dart:convert';

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

class JsonConverter {
  void _setValue(InstanceMirror instanceMirror, String variableName,
      Type variableType, dynamic jsonValue) {
    if (jsonValue == null) {
      instanceMirror.invokeSetter(variableName, jsonValue);
      return;
    }

    if (variableType == double) {
      instanceMirror.invokeSetter(
          variableName, double.parse(jsonValue.toString()));
    } else if (variableType == DateTime) {
      DateTime utcTime = DateTime.parse(jsonValue);

      instanceMirror.invokeSetter(variableName, utcTime.toLocal());
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

    var declarations = ConverterHelper.getDeclarations(instanceMirror.type);

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
        Type variableType = (declaration as VariableMirror).reflectedType;

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

    var declarations = ConverterHelper.getDeclarations(instanceMirror.type);

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

      // Преобразование времени к универсальному формату
      dynamic value = instanceMirror.invokeGetter(declaration.simpleName);
      Type variableType = (declaration as VariableMirror).reflectedType;
      if (variableType == DateTime && value != null) {
        value = (value as DateTime).toUtc();
      }

      map[jsonName] = value;
    }

    return map;
  }

  dynamic _encode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  String toJsonString() {
    return JSON.encode(toJson(), toEncodable: _encode);
  }

  dynamic fromJsonString(String str) {
    return fromJson(JSON.decode(str));
  }
}
