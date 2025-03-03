import 'package:flutter/material.dart';
import 'package:integradora_movil/models/small_container.dart';  // Asegúrate de importar SmallContainer
import 'package:integradora_movil/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class InsertSmallContainerScreen extends StatefulWidget {
  const InsertSmallContainerScreen({super.key});

  @override
  State<InsertSmallContainerScreen> createState() => _InsertSmallContainerState();
}

class _InsertSmallContainerState extends State<InsertSmallContainerScreen> {
  
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

  void _insertSmallContainer() async {
    var scont = SmallContainer(
      id: mongo.ObjectId(),
      tamano: _tamanoController.text,
      capacidad: double.parse(_capacidadController.text),
      forma: _formaController.text,
      estadoConexion: bool.parse(_estadoConexionController.text),
      material: _materialController.text,
      cargaDispositivo: int.parse(_cargaDispositivoController.text),
      consumoEnergetico: double.parse(_consumoEnergeticoController.text),
      nivelAlimento: int.parse(_nivelAlimentoController.text),
    );
    await MongoService().insertSmallContainer(scont);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insertar Contenedor Pequeño"),
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
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _formaController,
              decoration: InputDecoration(labelText: "Forma"),
            ),
            TextField(
              controller: _estadoConexionController,
              decoration: InputDecoration(labelText: "Estado de la Conexión"),
            ),
            TextField(
              controller: _materialController,
              decoration: InputDecoration(labelText: "Material"),
            ),
            TextField(
              controller: _cargaDispositivoController,
              decoration: InputDecoration(labelText: "Carga del Dispositivo"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _consumoEnergeticoController,
              decoration: InputDecoration(labelText: "Consumo Energético"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _nivelAlimentoController,
              decoration: InputDecoration(labelText: "Nivel de Alimento"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: _insertSmallContainer,
              child: Text("Insertar"),
            ),
          ],
        ),
      ),
    );
  }
}
