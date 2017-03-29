import 'reflector.dart';
import 'package:reflectable/reflectable.dart';
import 'base_converter.dart';

@metareflector
class MapSettings {
  final String name;

  /**
   * Если true, исключается из сериализации / десериализации
   */
  final bool exclude;

  const MapSettings({this.name: null, this.exclude: false});
}

class MapConverter extends BaseConverter {
  MapSettings getMapSettings(List<Object> metadata) {
    if (metadata == null) return null;

    var mapSerializationMetadata = metadata
        .firstWhere((e) => e.runtimeType == MapSettings, orElse: () => null);

    if (mapSerializationMetadata == null) return null;

    return (mapSerializationMetadata as MapSettings);
  }

  Map toMap() {
    InstanceMirror instanceMirror = reflectable.reflect(this);
    var declarations = BaseConverter.getDeclarations(instanceMirror.type);

    var result = new Map();

    for (var declaration in declarations.values) {
      if (!(declaration is VariableMirror)) {
        continue;
      }

      var mapName = declaration.simpleName;

      MapSettings mapSettings = getMapSettings(declaration.metadata);

      if (mapSettings != null) {
        if (mapSettings.exclude) {
          continue;
        }

        mapName = mapSettings.name ?? mapName; // TODO: сделать красивее

      }

      result[mapName] = instanceMirror.invokeGetter(declaration.simpleName);
    }

    return result;
  }
}
