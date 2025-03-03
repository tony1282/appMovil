import 'package:flutter/material.dart';

import 'contenedor_chico_screen.dart';
import 'contenedor_grande_screen.dart';
import 'dart:ui'; // Necesario para BackdropFilter

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List contenedor = [
    ['Contenedor Chico', false],
    ['Contenedor Grande', false],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('HiveBot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))),
        backgroundColor: const Color.fromARGB(255, 255, 245, 103),
        elevation: 5,
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg', // Asegúrate de tener esta imagen en la ruta correcta
              fit: BoxFit.cover,
            ),
          ),
          // Aplicar el difuminado
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), // Aplicar el blur
              child: Container(
                color: Colors.black.withOpacity(0.18), // Color de fondo con opacidad para el difuminado
              ),
            ),
          ),
          // Contenido de la página
          Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: contenedor.length,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: GestureDetector(
                    onTap: () {
                      if (contenedor[index][0] == 'Contenedor Chico') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContenedorPequenoScreen(),
                          ),
                        );
                      } else if (contenedor[index][0] == 'Contenedor Grande') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContenedorGrandeScreen(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 100),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8), // Fondo semi-transparente
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 178, 178, 178).withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        contenedor[index][0],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
