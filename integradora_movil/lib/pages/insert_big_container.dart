import 'package:flutter/material.dart';
import 'package:integradora_movil/models/big_container.dart';
import 'package:integradora_movil/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class InsertBigContainerScreen extends StatefulWidget {
  const InsertBigContainerScreen({super.key});

  @override
  State<InsertBigContainerScreen> createState() => _InsertBigContainerState();
}

class _InsertBigContainerState extends State<InsertBigContainerScreen> {

  late TextEditingController _tamanoController;
  late TextEditingController _capacidadController;
  late TextEditingController _formaController;
  late TextEditingController _estadoConexionController;
  late TextEditingController _materialController;
  late TextEditingController _cargaDispositivoController;
  late TextEditingController _consumoEnergeticoController;
  late TextEditingController _nivelAlimentoController;

  @override
  void initState() {
    super.initState();
    _tamanoController = TextEditingController();
    _capacidadController = TextEditingController();
    _formaController = TextEditingController();
    _estadoConexionController = TextEditingController();
    _materialController = TextEditingController();
    _cargaDispositivoController = TextEditingController();
    _consumoEnergeticoController = TextEditingController();
    _nivelAlimentoController = TextEditingController();

  }

  @override
  void dispose() {
    _tamanoController.dispose();
    _capacidadController.dispose();
    _formaController.dispose();
    _estadoConexionController.dispose();
    _materialController.dispose();
    _cargaDispositivoController.dispose();
    _consumoEnergeticoController.dispose();
    _nivelAlimentoController.dispose();


    

    super.dispose();
  }

  void _insertBigContainer () async {
    var bcont = BigContainer(
    id: mongo.ObjectId(), 
    tamano: _tamanoController.text, 
    capacidad: int.parse(_capacidadController.text), 
    forma: _formaController.text, 
    estadoConexion: bool.parse(_estadoConexionController.text),
    material: _materialController.text,
    cargaDispositivo: int.parse(_cargaDispositivoController.text) ,
    consumoEnergetico: double.parse(_consumoEnergeticoController.text),
    nivelAlimento: int.parse(_nivelAlimentoController.text),
    );
    await MongoService().insertBigContainer(bcont);
    if ( !mounted ) return;
    Navigator.of(context).pop();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insertar Contenedor grande"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tamanoController,
              decoration: InputDecoration(labelText: "Tamaño"),
            ),
            TextField(
              controller: _capacidadController,
              decoration: InputDecoration(labelText: "Capacidad"),
            ),
            TextField(
              controller: _formaController,
              decoration: InputDecoration(labelText: "forma"),
            ),
            TextField(
              controller: _estadoConexionController,
              decoration: InputDecoration(labelText: "Estado de la conexion"),
            ),
            TextField(
              controller: _materialController,
              decoration: InputDecoration(labelText: "Material"),
            ),
            TextField(
              controller: _cargaDispositivoController,
              decoration: InputDecoration(labelText: "carga del dispositivo"),
            ),
              TextField(
              controller: _consumoEnergeticoController,
              decoration: InputDecoration(labelText: "Consumo energetico"),
            ),
              TextField(
              controller: _nivelAlimentoController,
              decoration: InputDecoration(labelText: "Nivel de alimento"),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: _insertBigContainer,
              child: Text("Insertar"),
            ),
          ],
        ),
      ),
    );
  }
}