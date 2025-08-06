import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';
import 'package:kkiapay_fedapay/Screens/Kkiapay/kSuccessScreen.dart';

class Kkiapay extends StatefulWidget {
  const Kkiapay({super.key});

  @override
  State<Kkiapay> createState() => _KkiapayState();
}

class _KkiapayState extends State<Kkiapay> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _reasonController = TextEditingController();
  final _dataController = TextEditingController();
  final _partnerIdController = TextEditingController();

  List<String> _selectedCountries = ['BJ'];
  List<String> _selectedPaymentMethods = ['momo'];
  bool _sandboxMode = true;
  String _selectedTheme = '#222F5A';

  final List<String> _availableCountries = ['BJ', 'CI', 'SN', 'TG'];
  final List<String> _availablePaymentMethods = ['momo', 'card'];
  final Map<String, String> _themeOptions = {
    '#222F5A': 'Bleu foncé (défaut)',
    '#1565C0': 'Bleu',
    '#388E3C': 'Vert',
    '#F57C00': 'Orange',
    '#7B1FA2': 'Violet',
    '#C62828': 'Rouge',
  };

  // Callback pour KKiaPay
  void callback(response, context) {
    switch (response['status']) {
      case PAYMENT_CANCELLED:
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paiement annulé'),
            backgroundColor: Colors.orange,
          ),
        );
        debugPrint(PAYMENT_CANCELLED);
        break;

      case PAYMENT_INIT:
        debugPrint(PAYMENT_INIT);
        break;

      case PENDING_PAYMENT:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paiement en cours...'),
            backgroundColor: Colors.blue,
          ),
        );
        debugPrint(PENDING_PAYMENT);
        break;

      case PAYMENT_SUCCESS:
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              amount: response['requestData']['amount'],
              transactionId: response['transactionId'],
            ),
          ),
        );
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Événement inconnu'),
            backgroundColor: Colors.grey,
          ),
        );
        debugPrint(UNKNOWN_EVENT);
        break;
    }
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      // Créer l'instance KKiaPay avec les valeurs saisies
      final kkiapay = KKiaPay(
        amount: int.parse(_amountController.text),
        countries: _selectedCountries,
        phone: _phoneController.text,
        name: _nameController.text,
        email: _emailController.text,
        reason: _reasonController.text,
        data: _dataController.text.isEmpty ? null : _dataController.text,
        sandbox: _sandboxMode,
        apikey: 'bc46cb50800611efbca255daf9c4feeb', // Votre clé API
        callback: callback,
        theme: _selectedTheme,
        partnerId: _partnerIdController.text.isEmpty ? null : _partnerIdController.text,
        paymentMethods: _selectedPaymentMethods,
      );

      // Lancer le paiement
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => kkiapay),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();
    _dataController.dispose();
    _partnerIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KKiaPay - Nouveau Paiement",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.deepPurple.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Icon(Icons.account_balance_wallet, color: Colors.white, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      'Informations de paiement KKiaPay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Montant
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Montant (XOF) *',
                  prefixIcon: Icon(Icons.monetization_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Ex: 1000',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le montant est requis';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Montant invalide';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Nom complet
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom complet *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Ex: John Doe',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom est requis';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'L\'email est requis';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Téléphone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone *',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: '22961000000',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le téléphone est requis';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // Raison du paiement
              TextFormField(
                controller: _reasonController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Raison du paiement *',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Ex: Achat de produit, Abonnement...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La raison est requise';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Pays supportés
              Text(
                'Pays supportés *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: _availableCountries.map((country) {
                  return FilterChip(
                    label: Text(country),
                    selected: _selectedCountries.contains(country),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCountries.add(country);
                        } else {
                          if (_selectedCountries.length > 1) {
                            _selectedCountries.remove(country);
                          }
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Méthodes de paiement
              Text(
                'Méthodes de paiement *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: _availablePaymentMethods.map((method) {
                  String label = method == 'momo' ? 'Mobile Money' : 'Carte bancaire';
                  return FilterChip(
                    label: Text(label),
                    selected: _selectedPaymentMethods.contains(method),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedPaymentMethods.add(method);
                        } else {
                          if (_selectedPaymentMethods.length > 1) {
                            _selectedPaymentMethods.remove(method);
                          }
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Mode et Thème
              Row(
                children: [
                  Expanded(
                    child: SwitchListTile(
                      title: Text('Mode Sandbox'),
                      subtitle: Text(_sandboxMode ? 'Test' : 'Production'),
                      value: _sandboxMode,
                      onChanged: (value) {
                        setState(() {
                          _sandboxMode = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Thème
              DropdownButtonFormField<String>(
                value: _selectedTheme,
                decoration: InputDecoration(
                  labelText: 'Thème',
                  prefixIcon: Icon(Icons.palette),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _themeOptions.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: Color(int.parse(entry.key.replaceFirst('#', '0xFF'))),
                          margin: EdgeInsets.only(right: 10),
                        ),
                        Expanded(child: Text(entry.value)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Options avancées
              ExpansionTile(
                title: Text('Options avancées'),
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _dataController,
                    decoration: InputDecoration(
                      labelText: 'Données personnalisées (optionnel)',
                      prefixIcon: Icon(Icons.data_object),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Données supplémentaires...',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _partnerIdController,
                    decoration: InputDecoration(
                      labelText: 'ID Partenaire (optionnel)',
                      prefixIcon: Icon(Icons.business),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Votre ID partenaire...',
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              const SizedBox(height: 30),

              // Bouton de paiement
              ElevatedButton(
                onPressed: _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_balance_wallet),
                    const SizedBox(width: 10),
                    Text(
                      'Payer avec KKiaPay',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Text(
                '* Champs obligatoires',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}