class UserModel {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;
  final String pin;
  final double solde;

  UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.pin,
    required this.solde,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      pin: json['pin'],
      solde: (json['solde'] as num).toDouble(),
    );
  }
}
