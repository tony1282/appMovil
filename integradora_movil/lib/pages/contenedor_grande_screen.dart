import 'dart:ui'; // Necesario para el BackdropFilter
import 'package:flutter/material.dart';
import 'package:integradora_movil/models/big_container.dart';
import 'package:integradora_movil/pages/insert_big_container.dart';
import 'package:integradora_movil/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ContenedorGrandeScreen extends StatefulWidget {
  const ContenedorGrandeScreen({super.key});

  @override
  State<ContenedorGrandeScreen> createState() => _ContenedorGrandeState();
}

class _ContenedorGrandeState extends State<ContenedorGrandeScreen> {
  List<BigContainer> bcontainer = [];
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
    _fetchBcontainer();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0), // Ajusta la cantidad de padding aquí
          child: const Text(
            'Contenedor Grande',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 245, 103),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () {
              // Agregar lógica para abrir pantalla de agregar contenedor
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InsertBigContainerScreen()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Fondo con difuminado
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'), // Asegúrate de tener esta imagen en la carpeta assets
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), // Difuminado
                child: Container(
                  color: Colors.black.withOpacity(0.18), // Sombra oscura para mejorar contraste
                ),
              ),
            ),
          ),
          // Contenido de la pantalla
          ListView.builder(
            itemCount: bcontainer.length,
            itemBuilder: (context, index) {
              var bcont = bcontainer[index];
              return oneTile(bcont);
            },
          ),
        ],
      ),
    );
  }

  void _fetchBcontainer() async {
    bcontainer = await MongoService().getBigContainer();
    setState(() {});
  }

  void _deleteBigContainer(mongo.ObjectId id) async {
    await MongoService().deleteBigContainer(id);
    _fetchBcontainer();
  }

  void _updateBigContainer(BigContainer bcont) async {
    await MongoService().updateBigContainer(bcont);
    _fetchBcontainer();
  }

  void _showEditDialog(BigContainer bcont) {
    _tamanoController.text = bcont.tamano;
    _capacidadController.text = bcont.capacidad.toString();
    _formaController.text = bcont.forma;
    _estadoConexionController.text = bcont.estadoConexion.toString();
    _materialController.text = bcont.material;
    _cargaDispositivoController.text = bcont.cargaDispositivo.toString();
    _consumoEnergeticoController.text = bcont.consumoEnergetico.toString();
    _nivelAlimentoController.text = bcont.nivelAlimento.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar contenedor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Tamaño'),
                controller: _tamanoController,
              ),
              TextField(
                controller: _capacidadController,
                decoration: const InputDecoration(labelText: 'Capacidad'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _formaController,
                decoration: const InputDecoration(labelText: 'Forma'),
              ),
              TextField(
                controller: _estadoConexionController,
                decoration: const InputDecoration(labelText: 'Estado de la Conexion'),
              ),
              TextField(
                controller: _materialController,
                decoration: const InputDecoration(labelText: 'Material'),
              ),
              TextField(
                controller: _cargaDispositivoController,
                decoration: const InputDecoration(labelText: 'Carga del Dispositivo'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _consumoEnergeticoController,
                decoration: const InputDecoration(labelText: 'Consumo Energético'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: _nivelAlimentoController,
                decoration: const InputDecoration(labelText: 'Nivel de Alimento'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                bcont.tamano = _tamanoController.text;
                bcont.capacidad = int.tryParse(_capacidadController.text) ?? 0;
                bcont.forma = _formaController.text;
                bcont.estadoConexion = _estadoConexionController.text.toLowerCase() == 'true';
                bcont.material = _materialController.text;
                bcont.cargaDispositivo = int.tryParse(_cargaDispositivoController.text) ?? 0;
                bcont.consumoEnergetico = double.tryParse(_consumoEnergeticoController.text) ?? 0.0;
                bcont.nivelAlimento = int.tryParse(_nivelAlimentoController.text) ?? 0;

                _updateBigContainer(bcont);
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Personalizamos el diseño de los contenedores dentro de la lista
  Widget oneTile(BigContainer bcont) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 178, 178, 178).withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Tamaño', bcont.tamano),
            _buildInfoRow('Material', bcont.material),
            _buildInfoRow('Capacidad', bcont.capacidad.toString()),
            _buildInfoRow('Forma', bcont.forma),
            _buildInfoRow('Estado de Conexión', bcont.estadoConexion ? 'Conectado' : 'Desconectado'),
            _buildInfoRow('Carga del Dispositivo', bcont.cargaDispositivo.toString()),
            _buildInfoRow('Consumo Energético', '${bcont.consumoEnergetico} W'),
            _buildInfoRow('Nivel de Alimento', bcont.nivelAlimento.toString()),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _showEditDialog(bcont),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => _deleteBigContainer(bcont.id),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
