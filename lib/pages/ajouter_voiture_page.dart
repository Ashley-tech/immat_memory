import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/voiture.dart';

class AjouterVoiturePage extends StatefulWidget {
  final Voiture? voiture;

  const AjouterVoiturePage({
    super.key,
    this.voiture,
  });

  @override
  State<AjouterVoiturePage> createState() =>
      _AjouterVoiturePageState();
}

class _AjouterVoiturePageState
    extends State<AjouterVoiturePage> {
  final immatriculationController =
      TextEditingController();

  final marqueController =
      TextEditingController();

  final occupantsController =
      TextEditingController();

  final detailsController =
      TextEditingController();

  Future<void> ajouterVoiture() async {
    final immat = immatriculationController.text.trim();

    final existe = await DatabaseHelper.instance
        .immatriculationExiste(
          immat,
          ignoreId: widget.voiture?.id,
        );

    if (existe) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Erreur'),
          content: Text(
            'La voiture "$immat" existe déjà.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (immat.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Erreur'),
          content: const Text(
            'L\'immatriculation ne peut pas être vide.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final voiture = Voiture(
      id: widget.voiture?.id,
      immatriculation: immat,
      marqueModele: marqueController.text,
      occupantsNoms: occupantsController.text,
      details: detailsController.text,
    );

    if (widget.voiture == null) {
      await DatabaseHelper.instance.createVoiture(voiture);
    } else {
      await DatabaseHelper.instance.updateVoiture(voiture);
    }

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.voiture != null) {
      immatriculationController.text =
          widget.voiture!.immatriculation ?? '';

      marqueController.text =
          widget.voiture!.marqueModele ?? '';

      occupantsController.text =
          widget.voiture!.occupantsNoms ?? '';

      detailsController.text =
          widget.voiture!.details ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle voiture'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller:
                  immatriculationController,
              decoration:
                  const InputDecoration(
                labelText: 'Immatriculation',
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: marqueController,
              decoration:
                  const InputDecoration(
                labelText: 'Marque / modèle',
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller:
                  occupantsController,
              decoration:
                  const InputDecoration(
                labelText: 'Occupants',
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: detailsController,
              decoration:
                  const InputDecoration(
                labelText: 'Détails',
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ajouterVoiture,
                child: Text(
                  widget.voiture == null
                      ? 'Ajouter'
                      : 'Modifier',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}