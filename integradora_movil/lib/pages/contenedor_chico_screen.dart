import 'dart:ui'; // Necesario para el BackdropFilter
import 'package:flutter/material.dart';
import 'package:integradora_movil/models/small_container.dart';  // Asegúrate de importar SmallContainer
import 'package:integradora_movil/pages/insert_small_container.dart';  // Asegúrate de tener esta pantalla
import 'package:integradora_movil/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ContenedorPequenoScreen extends StatefulWidget {
  const ContenedorPequenoScreen({super.key});

  @override
  State<ContenedorPequenoScreen> createState() => _ContenedorPequenoState();
}

class _ContenedorPequenoState extends State<ContenedorPequenoScreen> {
  List<SmallContainer> scontainer = [];
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
    _fetchScontainer();
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
            'Contenedor Pequeño',
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
                MaterialPageRoute(builder: (context) => InsertSmallContainerScreen()), // Cambié a InsertSmallContainerScreen
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
            itemCount: scontainer.length,
            itemBuilder: (context, index) {
              var scont = scontainer[index];
              return oneTile(scont);
            },
          ),
        ],
      ),
    );
  }

  void _fetchScontainer() async {
    scontainer = await MongoService().getSmallContainer(); // Cambié el método a getSmallContainer
    setState(() {});
  }

  void _deleteSmallContainer(mongo.ObjectId id) async {
    await MongoService().deleteSmallContainer(id); // Cambié el método a deleteSmallContainer
    _fetchScontainer();
  }

  void _updateSmallContainer(SmallContainer scont) async {
    await MongoService().updateSmallContainer(scont); // Cambié el método a updateSmallContainer
    _fetchScontainer();
  }

  void _showEditDialog(SmallContainer scont) {
    _tamanoController.text = scont.tamano;
    _capacidadController.text = scont.capacidad.toString();
    _formaController.text = scont.forma;
    _estadoConexionController.text = scont.estadoConexion.toString();
    _materialController.text = scont.material;
    _cargaDispositivoController.text = scont.cargaDispositivo.toString();
    _consumoEnergeticoController.text = scont.consumoEnergetico.toString();
    _nivelAlimentoController.text = scont.nivelAlimento.toString();

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
                scont.tamano = _tamanoController.text;
                scont.capacidad = double.tryParse(_capacidadController.text) ?? 0.0;
                scont.forma = _formaController.text;
                scont.estadoConexion = _estadoConexionController.text.toLowerCase() == 'true';
                scont.material = _materialController.text;
                scont.cargaDispositivo = int.tryParse(_cargaDispositivoController.text) ?? 0;
                scont.consumoEnergetico = double.tryParse(_consumoEnergeticoController.text) ?? 0.0;
                scont.nivelAlimento = int.tryParse(_nivelAlimentoController.text) ?? 0;

                _updateSmallContainer(scont);
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
  Widget oneTile(SmallContainer scont) {
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
            _buildInfoRow('Tamaño', scont.tamano),
            _buildInfoRow('Material', scont.material),
            _buildInfoRow('Capacidad', scont.capacidad.toString()),
            _buildInfoRow('Forma', scont.forma),
            _buildInfoRow('Estado de Conexión', scont.estadoConexion ? 'Conectado' : 'Desconectado'),
            _buildInfoRow('Carga del Dispositivo', scont.cargaDispositivo.toString()),
            _buildInfoRow('Consumo Energético', '${scont.consumoEnergetico} W'),
            _buildInfoRow('Nivel de Alimento', scont.nivelAlimento.toString()),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _showEditDialog(scont),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => _deleteSmallContainer(scont.id),
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
