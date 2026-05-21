class Voiture {
  final int? id;
  final String immatriculation;
  final String? marqueModele;
  final String? occupantsNoms;
  final String? details;

  Voiture({
    this.id,
    required this.immatriculation,
    this.marqueModele,
    this.occupantsNoms,
    this.details,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'immatriculation': immatriculation,
        'marque_modele': marqueModele,
        'occupants_noms': occupantsNoms,
        'details': details,
      };

  static Voiture fromJson(Map<String, dynamic> json) {
    return Voiture(
      id: json['id'],
      immatriculation: json['immatriculation'],
      marqueModele: json['marque_modele'],
      occupantsNoms: json['occupants_noms'],
      details: json['details'],
    );
  }
}