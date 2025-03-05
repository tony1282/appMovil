import 'dart:ui'; // Necesario para el BackdropFilter
import 'package:flutter/material.dart';
import 'package:integradora_movil/models/small_container.dart'; // Asegúrate de importar SmallContainer
import 'package:integradora_movil/pages/insert_small_container.dart'; // Asegúrate de tener esta pantalla
import 'package:integradora_movil/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ContenedorPequenoScreen extends StatefulWidget {
  const ContenedorPequenoScreen({super.key});

  @override
  State<ContenedorPequenoScreen> createState() => _ContenedorPequenoState();
}

class _ContenedorPequenoState extends State<ContenedorPequenoScreen> {
  List<SmallContainer> scontainer = [];

  @override
  void initState() {
    super.initState();
    _fetchScontainer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con fondo negro y texto amarillo
      appBar: AppBar(
        title: const Text(
          'Contenedor Pequeño',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.yellow, // Amarillo en el texto
          ),
        ),
        backgroundColor: Colors.black, // Fondo negro para el AppBar
        elevation: 0, // Sin sombra
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.yellow),
            onPressed: () {
              print("Notificaciones presionadas");
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black, // Fondo negro para todo el cuerpo
        child: ListView.builder(
          itemCount: scontainer.length,
          itemBuilder: (context, index) {
            var scont = scontainer[index];
            return oneTile(scont);
          },
        ),
      ),
      // Footer con iconos reorganizados: Inicio, Usuario, Configuración, Ayuda
      bottomNavigationBar: BottomAppBar(
        color: Colors.black, // Fondo negro para el footer
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribuye los íconos
            children: [
              // Icono de Inicio
              IconButton(
                icon: Icon(Icons.home, color: Colors.yellow),
                onPressed: () {
                  print("Inicio presionado");
                },
              ),
              // Icono de Usuario
              IconButton(
                icon: Icon(Icons.person, color: Colors.yellow),
                onPressed: () {
                  print("Usuario presionado");
                },
              ),
              // Icono de Configuración
              IconButton(
                icon: Icon(Icons.settings, color: Colors.yellow),
                onPressed: () {
                  print("Configuración presionada");
                },
              ),
              // Icono de Ayuda
              IconButton(
                icon: Icon(Icons.help, color: Colors.yellow),
                onPressed: () {
                  print("Ayuda presionada");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  void _fetchScontainer() async {
    scontainer = await MongoService().getSmallContainer();
    setState(() {});
  }

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

  void _deleteSmallContainer(mongo.ObjectId id) async {
    await MongoService().deleteSmallContainer(id);
    _fetchScontainer();
  }

  void _updateSmallContainer(SmallContainer scont) async {
    await MongoService().updateSmallContainer(scont);
    _fetchScontainer();
  }

  void _showEditDialog(SmallContainer scont) {
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
                controller: TextEditingController(text: scont.tamano),
              ),
              TextField(
                controller: TextEditingController(text: scont.capacidad.toString()),
                decoration: const InputDecoration(labelText: 'Capacidad'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: TextEditingController(text: scont.forma),
                decoration: const InputDecoration(labelText: 'Forma'),
              ),
              TextField(
                controller: TextEditingController(text: scont.estadoConexion.toString()),
                decoration: const InputDecoration(labelText: 'Estado de la Conexion'),
              ),
              TextField(
                controller: TextEditingController(text: scont.material),
                decoration: const InputDecoration(labelText: 'Material'),
              ),
              TextField(
                controller: TextEditingController(text: scont.cargaDispositivo.toString()),
                decoration: const InputDecoration(labelText: 'Carga del Dispositivo'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: TextEditingController(text: scont.consumoEnergetico.toString()),
                decoration: const InputDecoration(labelText: 'Consumo Energético'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: TextEditingController(text: scont.nivelAlimento.toString()),
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
                scont.tamano = TextEditingController(text: scont.tamano).text;
                scont.capacidad = double.tryParse(TextEditingController(text: scont.capacidad.toString()).text) ?? 0.0;
                scont.forma = TextEditingController(text: scont.forma).text;
                scont.estadoConexion = TextEditingController(text: scont.estadoConexion.toString()).text.toLowerCase() == 'true';
                scont.material = TextEditingController(text: scont.material).text;
                scont.cargaDispositivo = int.tryParse(TextEditingController(text: scont.cargaDispositivo.toString()).text) ?? 0;
                scont.consumoEnergetico = double.tryParse(TextEditingController(text: scont.consumoEnergetico.toString()).text) ?? 0.0;
                scont.nivelAlimento = int.tryParse(TextEditingController(text: scont.nivelAlimento.toString()).text) ?? 0;
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
}
