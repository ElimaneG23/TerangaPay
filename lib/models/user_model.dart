class UserModel {
  final int id;
  final String nom;
  final String prenom;
  final String? email;      // nullable
  final String telephone;
  final String? pin;        // nullable
  double solde;

  UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    this.email,               // optionnel
    required this.telephone,
    this.pin,                 // optionnel
    required this.solde,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],        // peut être null
      telephone: json['telephone'],
      pin: json['pin'],            // peut être null
      solde: (json['solde'] as num).toDouble(),
    );
  }
}