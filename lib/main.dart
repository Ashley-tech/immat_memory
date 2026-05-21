import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

import 'database/database_helper.dart';
import 'models/voiture.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // IMPORTANT pour Windows / Linux / macOS
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'app.db');

  final file = File(path);
  if (await file.exists()) {
    await file.delete();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Voiture> voitures = [];

  @override
  void initState() {
    super.initState();

    chargerVoitures();
  }

  Future<void> chargerVoitures() async {
    final data =
        await DatabaseHelper.instance.readAllVoitures();

    setState(() {
      voitures = data;
    });
  }

  Future<void> ajouterVoiture() async {
    final voiture = Voiture(
      immatriculation: 'AB-123-CD',
      marqueModele: 'Peugeot 308',
      occupantsNoms: 'Jean Dupont',
      details: 'Véhicule bleu',
    );

    await DatabaseHelper.instance.createVoiture(voiture);

    chargerVoitures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Flutter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ajouterVoiture,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: voitures.length,
        itemBuilder: (context, index) {
          final u = voitures[index];

          return ListTile(
            title: Text(u.immatriculation),
            subtitle: Text('Nom : ${u.marqueModele}'),
          );
        },
      ),
    );
  }
}