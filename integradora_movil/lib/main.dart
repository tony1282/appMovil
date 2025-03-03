import 'package:flutter/material.dart';
import 'package:integradora_movil/pages/home_page.dart';
import 'package:integradora_movil/services/mongo_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoService().connect();
  print('Conexion a MongoDB establecida');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
