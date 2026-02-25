import 'package:flutter/material.dart';
import 'package:terangapay/src/ui/widgets/primary_button.dart';
import 'package:terangapay/src/utiles/form_validators.dart';
import '../../../app_theme.dart';
import '../../utiles/myAssets/image_assets.dart';
import '../widgets/primary_textfield.dart';
import 'otp_page.dart';

class Country {
  final String name;
  final String code;
  final String dialCode;
  final String flag;
  const Country({required this.name, required this.code, required this.dialCode, required this.flag});
}

const List<Country> kCountries = [
  Country(name: 'Sénégal',        code: 'SN', dialCode: '+221', flag: '🇸🇳'),
  Country(name: 'France',         code: 'FR', dialCode: '+33',  flag: '🇫🇷'),
  Country(name: 'Mali',           code: 'ML', dialCode: '+223', flag: '🇲🇱'),
  Country(name: "Côte d'Ivoire",  code: 'CI', dialCode: '+225', flag: '🇨🇮'),
  Country(name: 'Guinée',         code: 'GN', dialCode: '+224', flag: '🇬🇳'),
  Country(name: 'Cameroun',       code: 'CM', dialCode: '+237', flag: '🇨🇲'),
  Country(name: 'Maroc',          code: 'MA', dialCode: '+212', flag: '🇲🇦'),
  Country(name: 'Gabon',          code: 'GA', dialCode: '+241', flag: '🇬🇦'),
  Country(name: 'États-Unis',     code: 'US', dialCode: '+1',   flag: '🇺🇸'),
  Country(name: 'Belgique',       code: 'BE', dialCode: '+32',  flag: '🇧🇪'),
];

class PhoneVerifyPage extends StatefulWidget {
  final String nom;
  final String prenom;
  final String email;

  const PhoneVerifyPage({
    super.key,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  @override
  State<PhoneVerifyPage> createState() => _PhoneVerifyPageState();
}

class _PhoneVerifyPageState extends State<PhoneVerifyPage> {
  Country _selectedCountry = kCountries.first;
  String _phone = '';
  final _controller = TextEditingController();

  String get _formattedPhone {
    final digits = _phone.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 5 || i == 7) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String val) {
    final digits = val.replaceAll(RegExp(r'[^0-9]'), '');
    setState(() {
      _phone = digits;
      _controller.value = TextEditingValue(
        text: _formattedPhone,
        selection: TextSelection.collapsed(offset: _formattedPhone.length),
      );
    });
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CountryPickerSheet(
        selected: _selectedCountry,
        onSelect: (country) {
          setState(() => _selectedCountry = country);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _goToOtp() {
    if (_phone.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez entrer un numéro valide'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    // ✅ Toutes les données transmises à OtpPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpPage(
          nom:       widget.nom,
          prenom:    widget.prenom,
          email:     widget.email,
          telephone: _phone,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(ImagesAssets.terangaPay),
              const SizedBox(height: 28),
              const Text('Entrez votre numéro\nde téléphone',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text, height: 1.3)),
              const SizedBox(height: 8),
              const Text('Un code de vérification sera envoyé sur ce numéro.',
                  style: TextStyle(fontSize: 13, color: AppColors.sub)),
              const SizedBox(height: 28),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _showCountryPicker,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        margin: const EdgeInsets.all(1.5),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(color: AppColors.greenLight, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_selectedCountry.flag, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Text(_selectedCountry.dialCode,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.sub),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryTextField(
                      controller: _controller,
                      hint: 'XX XXX XX XX',
                      keyboardType: TextInputType.phone,
                      gradient: AppTheme.primaryGradient,
                      onChanged: _onChanged,
                      validator: FormValidators.validateTelephone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              PrimaryButton(label: 'Suivant', onTap: _goToOtp),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  final Country selected;
  final void Function(Country) onSelect;
  const _CountryPickerSheet({required this.selected, required this.onSelect});
  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  String _search = '';
  List<Country> get _filtered => kCountries
      .where((c) => c.name.toLowerCase().contains(_search.toLowerCase()) ||
          c.dialCode.contains(_search) || c.code.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        children: [
          Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 16),
          const Text('Sélectionner un pays',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Rechercher un pays...',
                hintStyle: const TextStyle(color: AppColors.sub, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.sub, size: 20),
                filled: true, fillColor: AppColors.bg,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (_, i) {
                final c = _filtered[i];
                final isSelected = c.code == widget.selected.code;
                return ListTile(
                  onTap: () => widget.onSelect(c),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: isSelected ? AppColors.greenLight : Colors.transparent,
                  leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(c.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.text)),
                  trailing: Text(c.dialCode,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.greenDark : AppColors.sub)),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}