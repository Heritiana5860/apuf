class MemberModel {
  final String user_id;
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String facebook;
  final DateTime dateDeNaissance;
  final String lieuDeNaissance;
  final String? etablissement;
  final String? mention;
  final String? niveau;
  final String adresse;
  final String? quartier;
  final String? sexe;
  final DateTime dateEntree;
  final String? eglise;
  final String? role;
  final String fiaviana;
  final String? mpandray;
  final String? reception;
  final String? sampana;
  final String talenta;
  final String? profileImageUrl;

  MemberModel({
    required this.user_id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    required this.facebook,
    required this.dateDeNaissance,
    required this.lieuDeNaissance,
    this.etablissement,
    this.mention,
    this.niveau,
    required this.adresse,
    this.quartier,
    this.sexe,
    required this.dateEntree,
    this.eglise,
    this.role,
    required this.fiaviana,
    this.mpandray,
    this.reception,
    this.sampana,
    required this.talenta,
    this.profileImageUrl,
  });

  // Conversion du modèle en Map pour Supabase
  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'facebook': facebook,
      'date_de_naissance': dateDeNaissance.toIso8601String(),
      'lieu_de_naissance': lieuDeNaissance,
      'etablissement': etablissement,
      'mention': mention,
      'niveau': niveau,
      'adresse': adresse,
      'quartier': quartier,
      'sexe': sexe,
      'date_entree': dateEntree.toIso8601String(),
      'eglise': eglise,
      'role': role,
      'fiaviana': fiaviana,
      'mpandray': mpandray,
      'reception': reception,
      'sampana': sampana,
      'talenta': talenta,
      'profile_image_url': profileImageUrl,
    };
  }

  // Création depuis un Map Supabase
  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      user_id: json['user_id'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      email: json['email'],
      facebook: json['facebook'],
      dateDeNaissance: DateTime.parse(json['date_de_naissance']),
      lieuDeNaissance: json['lieu_de_naissance'],
      etablissement: json['etablissement'],
      mention: json['mention'],
      niveau: json['niveau'],
      adresse: json['adresse'],
      quartier: json['quartier'],
      sexe: json['sexe'],
      dateEntree: DateTime.parse(json['date_entree']),
      eglise: json['eglise'],
      role: json['role'],
      fiaviana: json['fiaviana'],
      mpandray: json['mpandray'],
      reception: json['reception'],
      sampana: json['sampana'],
      talenta: json['talenta'],
      profileImageUrl: json['profile_image_url'],
    );
  }

  // Copier le modèle avec des modifications
  MemberModel copyWith({
    String? user_id,
    String? nom,
    String? prenom,
    String? telephone,
    String? email,
    String? facebook,
    DateTime? dateDeNaissance,
    String? lieuDeNaissance,
    String? etablissement,
    String? mention,
    String? niveau,
    String? adresse,
    String? quartier,
    String? sexe,
    DateTime? dateEntree,
    String? eglise,
    String? role,
    String? fiaviana,
    String? mpandray,
    String? reception,
    String? sampana,
    String? talenta,
    String? profileImageUrl,
  }) {
    return MemberModel(
      user_id: user_id ?? this.user_id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      facebook: facebook ?? this.facebook,
      dateDeNaissance: dateDeNaissance ?? this.dateDeNaissance,
      lieuDeNaissance: lieuDeNaissance ?? this.lieuDeNaissance,
      etablissement: etablissement ?? this.etablissement,
      mention: mention ?? this.mention,
      niveau: niveau ?? this.niveau,
      adresse: adresse ?? this.adresse,
      quartier: quartier ?? this.quartier,
      sexe: sexe ?? this.sexe,
      dateEntree: dateEntree ?? this.dateEntree,
      eglise: eglise ?? this.eglise,
      role: role ?? this.role,
      fiaviana: fiaviana ?? this.fiaviana,
      mpandray: mpandray ?? this.mpandray,
      reception: reception ?? this.reception,
      sampana: sampana ?? this.sampana,
      talenta: talenta ?? this.talenta,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
