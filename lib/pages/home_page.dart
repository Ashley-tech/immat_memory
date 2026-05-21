import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/voiture.dart';
import 'ajouter_voiture_page.dart';

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

  Future<void> supprimerVoiture(int id) async {
    await DatabaseHelper.instance.deleteVoiture(id);

    chargerVoitures();
  }

  Future<void> modifierVoiture(Voiture voiture) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AjouterVoiturePage(
          voiture: voiture,
        ),
      ),
    ).then((_) {
      chargerVoitures();
    });
  }

  Future<void> ouvrirAjoutVoiture() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AjouterVoiturePage(),
      ),
    );

    chargerVoitures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes voitures'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ouvrirAjoutVoiture,
        child: const Icon(Icons.add),
      ),
      body: voitures.isEmpty
          ? const Center(
              child: Text('Aucune voiture'),
            )
          : ListView.builder(
              itemCount: voitures.length,
              itemBuilder: (context, index) {
                final voiture = voitures[index];

                return Card(
                  child: ListTile(
                    title: Text(voiture.immatriculation),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Marque / Modèle: ${voiture.marqueModele ?? ''}"),
                        Text("Occupants: ${voiture.occupantsNoms ?? ''}"),
                        Text("Détails: ${voiture.details ?? ''}"),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            modifierVoiture(voiture);
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final confirmation =
                                await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Supprimer la voiture',
                                  ),
                                  content: Text(
                                    'Voulez-vous vraiment supprimer ${voiture.immatriculation} ?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          context,
                                          false,
                                        );
                                      },
                                      child: const Text('Annuler'),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          context,
                                          true,
                                        );
                                      },
                                      child: const Text('Supprimer'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmation == true) {
                              supprimerVoiture(voiture.id!);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}