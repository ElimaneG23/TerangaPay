class FormValidators {

  // ── Champ générique ───────────────────────────────────────────────────────
  static String? validateNonEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Le champ $fieldName est requis';
    }
    if (value.contains(' ')) {
      return 'Le champ $fieldName ne doit pas contenir d\'espaces';
    }
    if (value.trim().length < 3) {
      return 'Le champ $fieldName doit contenir au moins 3 caractères';
    }
    if (value.trim().length > 20) {
      return 'Le champ $fieldName ne doit pas dépasser 20 caractères';
    }
    return null;
  }

  // ── Prénom ────────────────────────────────────────────────────────────────
  static String? validatePrenom(String? value) {
    if (value == null || value.trim().isEmpty) return 'Le prénom est requis';
    if (value.contains(' '))      return 'Le prénom ne doit pas contenir d\'espaces';
    if (value.trim().length < 3)  return 'Le prénom doit contenir au moins 3 caractères';
    if (value.trim().length > 20) return 'Le prénom ne doit pas dépasser 20 caractères';
    return null;
  }

  // ── Nom ───────────────────────────────────────────────────────────────────
  static String? validateNom(String? value) {
    if (value == null || value.trim().isEmpty) return 'Le nom est requis';
    if (value.contains(' '))      return 'Le nom ne doit pas contenir d\'espaces';
    if (value.trim().length < 3)  return 'Le nom doit contenir au moins 3 caractères';
    if (value.trim().length > 20) return 'Le nom ne doit pas dépasser 20 caractères';
    return null;
  }

  // ── Téléphone ─────────────────────────────────────────────────────────────
  static String? validateTelephone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le numéro de téléphone est requis';
      }
    if (value.contains(' ')) {
      return 'Le numéro de téléphone ne doit pas contenir d\'espaces';
    }
    if (value.trim().length < 8) {
      return 'Le numéro de téléphone doit contenir au moins 8 chiffres';
    }
    if (value.trim().length > 15) {
      return 'Le numéro de téléphone ne doit pas dépasser 15 chiffres';
    }
    
    // ✅ Accepte exactement 8 chiffres (format Sénégal sans indicatif)
    if (!RegExp(r'^\d{9}$').hasMatch(value.trim())) {
      return 'Le numéro doit comporter exactement 9 chiffres';
    }
    return null;
  }

  // ── Code PIN ──────────────────────────────────────────────────────────────
  static String? validatePin(String? value, String text) {
    if (value == null || value.trim().isEmpty) return 'Le code PIN est requis';
    if (value.contains(' ')) return 'Le code PIN ne doit pas contenir d\'espaces';
    if (!RegExp(r'^\d{4}$').hasMatch(value.trim())) {
      // Ce regex couvre déjà : exactement 4 chiffres, pas de lettres, pas d'espaces
      return 'Le code PIN doit contenir exactement 4 chiffres';
    }
    return null;
  }

  // ── Solde ─────────────────────────────────────────────────────────────────
  static String? validateSolde(String? value) {
    if (value == null || value.trim().isEmpty) return 'Le solde est requis';
    if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      return 'Le solde doit être un nombre entier positif';
    }
    return null;
  }

  // ── Email ─────────────────────────────────────────────────────────────────
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'L\'email est requis';
    if (value.contains(' ')) return 'L\'email ne doit pas contenir d\'espaces';
    if (value.trim().length < 3) return 'L\'email doit contenir au moins 3 caractères';
    if (value.trim().length > 50) return 'L\'email ne doit pas dépasser 50 caractères';

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value.trim())) {
      return 'L\'email n\'est pas valide';
    }

    return null;
  }

  // ── Mot de passe ──────────────────────────────────────────────────────────
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) return 'Le mot de passe est requis';
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$')
        .hasMatch(value.trim())) {
      return 'Min. 8 caractères, une majuscule, une minuscule et un chiffre';
    }
    return null;
  }

  // ── Confirmation mot de passe / PIN ───────────────────────────────────────
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.trim().isEmpty) {
      return 'La confirmation est requise';
    }
    if (value != password) {
      return 'Les valeurs ne correspondent pas';
    }
    return null;
  }

  static String? validateConfirmPin(String? value, String? pin) {
    if (value == null || value.trim().isEmpty) {
      return 'La confirmation du PIN est requise';
    }
    if (value != pin) {
      return 'Les codes PIN ne correspondent pas';
    }
    return null;
  }
}