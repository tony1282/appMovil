import 'package:mongo_dart/mongo_dart.dart' as mongo;

class BigContainer {
  final mongo.ObjectId id;
  String tamano;
  int capacidad;
  String forma;
  bool estadoConexion;
  String material;
  int cargaDispositivo;
  double consumoEnergetico;
  int nivelAlimento;

  BigContainer({
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

  
  factory BigContainer.fromJson(Map<String, dynamic> json) {
    var id = json['_id'];
    if (id is String) {
      try {
        id = mongo.ObjectId.fromHexString(id);  
      } catch (e) {
        id = mongo.ObjectId(); 
      }
    } else if (id is! mongo.ObjectId) {
      id = mongo.ObjectId(); 
    }

    /////// CHAT GPT  
    return BigContainer(
      id: id as mongo.ObjectId,
      tamano: json['tamano'] as String,
      capacidad: json['capacidad'] as int? ?? 0,  // Si es null, asigna 0
      forma: json['forma'] as String,
      estadoConexion: json['estado_conexion'] as bool? ?? false,  // Si es null, asigna false
      material: json['material'] as String,
      cargaDispositivo: (json['carga_dispositivo'] as int?) ?? 0, // Si es null, asigna 0
      consumoEnergetico: json['consumo_energetico'] is double
          ? json['consumo_energetico'] as double
          : (json['consumo_energetico'] is int
              ? (json['consumo_energetico'] as int).toDouble()
              : 0.0), // Si es null, asigna 0.0
      nivelAlimento: (json['nivel_alimento'] as int?) ?? 0, // Si es null, asigna 0
    );
  }
}
