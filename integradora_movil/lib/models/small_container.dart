import 'package:mongo_dart/mongo_dart.dart' as mongo;

class SmallContainer {
  final mongo.ObjectId id;
  String tamano;
  double capacidad;
  String forma;
  bool estadoConexion;
  String material;
  int cargaDispositivo;
  double consumoEnergetico;
  int nivelAlimento;

  SmallContainer({
    required this.id,
    required this.tamano,
    required this.capacidad,
    required this.forma,
    required this.estadoConexion,
    required this.material,
    required this.cargaDispositivo,
    required this.consumoEnergetico,
    required this.nivelAlimento,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'tamano': tamano,
      'capacidad': capacidad,
      'forma': forma,
      'estado_conexion': estadoConexion,
      'material': material,
      'carga_dispositivo': cargaDispositivo,
      'consumo_energetico': consumoEnergetico,
      'nivel_alimento': nivelAlimento,
    };
  }

  factory SmallContainer.fromJson(Map<String, dynamic> json) {
    var id = json['_id'];
    if (id is String) {
      try {
        id = mongo.ObjectId.fromHexString(id);
      } catch (e) {
        id = mongo.ObjectId(); // Si el id es inválido, genera uno nuevo
      }
    } else if (id is! mongo.ObjectId) {
      id = mongo.ObjectId(); // Si el id no es ObjectId, genera uno nuevo
    }

    // Asegúrate de manejar el tipo de estadoConexion correctamente (String a bool)
    bool estadoConexion = false;
    if (json['estado_conexion'] is String) {
      estadoConexion = json['estado_conexion'].toLowerCase() == 'true'; // Si el valor es "true" o "false" como cadena
    } else if (json['estado_conexion'] is bool) {
      estadoConexion = json['estado_conexion']; // Si el valor es un bool, se mantiene igual
    }

    return SmallContainer(
      id: id as mongo.ObjectId,
      tamano: json['tamano'] as String,
      capacidad: json['capacidad'] is String
          ? double.tryParse(json['capacidad']) ?? 0.0 // Si es String, intenta convertirlo a double
          : json['capacidad'] is double
              ? json['capacidad'] as double
              : (json['capacidad'] is int ? (json['capacidad'] as int).toDouble() : 0.0), // Si es int, convierte a double
      forma: json['forma'] as String,
      estadoConexion: estadoConexion,
      material: json['material'] as String,
      cargaDispositivo: (json['carga_dispositivo'] is String)
          ? int.tryParse(json['carga_dispositivo']) ?? 0 // Si es String, intenta convertirlo a int
          : (json['carga_dispositivo'] as int?) ?? 0, // Si es int, mantiene el valor
      consumoEnergetico: json['consumo_energetico'] is String
          ? double.tryParse(json['consumo_energetico']) ?? 0.0 // Si es String, intenta convertirlo a double
          : json['consumo_energetico'] is double
              ? json['consumo_energetico'] as double
              : (json['consumo_energetico'] is int ? (json['consumo_energetico'] as int).toDouble() : 0.0),
      nivelAlimento: (json['nivel_alimento'] is String)
          ? int.tryParse(json['nivel_alimento']) ?? 0 // Si es String, intenta convertirlo a int
          : (json['nivel_alimento'] as int?) ?? 0, // Si es int, mantiene el valor
    );
  }
}
