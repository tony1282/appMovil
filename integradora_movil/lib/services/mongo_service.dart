import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:integradora_movil/models/big_container.dart';
import 'package:integradora_movil/models/small_container.dart'; // Asegúrate de tener un modelo SmallContainer

class MongoService {
  //servicio para conectar con Mongo atlas
  // Usando Singleton
  static final MongoService _instance = MongoService._internal();

  late mongo.Db _db;

  MongoService._internal();

  factory MongoService() {
    return _instance;
  }

  Future<void> connect() async {
    try {
      _db = await mongo.Db.create(
          'mongodb+srv://antonydelacruzramos:ponyo1ponyo23@cluster0.e5lb5.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
      await _db.open();
      _db.databaseName = 'hiveBot';
      print('Conexion a MongoDB establecida');
    } on SocketException catch (e) {
      print('Error de conexion: $e');
      rethrow;
    }
  }

  mongo.Db get db {
    if (!_db.isConnected) {
      throw StateError(
          'Base de datos no inicializada, llama a connect() primero');
    }
    return _db;
  }

  // Métodos para el contenedor grande
  Future<List<BigContainer>> getBigContainer() async {
    final collection = _db.collection('contenedorGrande');
    print('Coleccion obtenida: $collection');
    var bcontainer = await collection.find().toList();
    print('En MongoService: $bcontainer');
    if (bcontainer.isEmpty) {
      print('No se encontrar b on datos de la coleccion');
    }
    return bcontainer.map((bcont) => BigContainer.fromJson(bcont)).toList();
  }

  Future<void> insertBigContainer(BigContainer bcont) async {
    final collection = _db.collection('contenedorGrande');
    await collection.insertOne(bcont.toJson());
  }

  Future<void> updateBigContainer(BigContainer bcont) async {
    final collection = _db.collection('contenedorGrande');
    await collection.updateOne(
      mongo.where.eq('_id', bcont.id),
      mongo.modify
          .set('tamano', bcont.tamano)
          .set('capacidad', bcont.capacidad)
          .set('forma', bcont.forma)
          .set('estado_conexion', bcont.estadoConexion)
          .set('material', bcont.material)
          .set('carga_dispositivo', bcont.cargaDispositivo)
          .set('consumo_energetico', bcont.consumoEnergetico)
          .set('nivel_alimento', bcont.nivelAlimento)
    );
  }

  Future<void> deleteBigContainer(mongo.ObjectId id) async {
    var collection = _db.collection('contenedorGrande');
    await collection.remove(mongo.where.eq('_id', id));
  }

  // Métodos para el contenedor pequeño
  Future<List<SmallContainer>> getSmallContainer() async {
    final collection = _db.collection('contenedorChico');
    print('Coleccion obtenida: $collection');
    var scontainer = await collection.find().toList();
    print('En MongoService: $scontainer');
    if (scontainer.isEmpty) {
      print('No se encontraron datos en la coleccion');
    }
    return scontainer.map((scont) => SmallContainer.fromJson(scont)).toList();
  }

  Future<void> insertSmallContainer(SmallContainer scont) async {
    final collection = _db.collection('contenedorChico');
    await collection.insertOne(scont.toJson());
  }

  Future<void> updateSmallContainer(SmallContainer scont) async {
    final collection = _db.collection('contenedorChico');
    await collection.updateOne(
      mongo.where.eq('_id', scont.id),
      mongo.modify
          .set('tamano', scont.tamano)
          .set('capacidad', scont.capacidad)
          .set('forma', scont.forma)
          .set('estado_conexion', scont.estadoConexion)
          .set('material', scont.material)
          .set('carga_dispositivo', scont.cargaDispositivo)
          .set('consumo_energetico', scont.consumoEnergetico)
          .set('nivel_alimento', scont.nivelAlimento)
    );
  }

  Future<void> deleteSmallContainer(mongo.ObjectId id) async {
    var collection = _db.collection('contenedorChico');
    await collection.remove(mongo.where.eq('_id', id));
  }
}
