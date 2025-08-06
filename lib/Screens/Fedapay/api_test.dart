import 'package:flutter/material.dart';
import '../../transaction_services.dart';

class PaymentScreen extends StatefulWidget {
  final int amount;
  final String description;
  final String currency;
  final String callbackUrl;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String country;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.description,
    required this.currency,
    required this.callbackUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.country,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  String? _paymentUrl;

  @override
  void initState() {
    super.initState();
    // Lancer automatiquement la création de transaction au chargement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initiatePayment();
    });
  }

  void initiatePayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      print('=== DÉBUT TRAITEMENT PAIEMENT ===');
      print('Paramètres du paiement:');
      print('  - Montant: ${widget.amount} ${widget.currency}');
      print('  - Client: ${widget.firstName} ${widget.lastName}');
      print('  - Email: ${widget.email}');
      print('  - Téléphone: ${widget.phoneNumber}');
      print('=====================================');

      final transaction = await createTransaction(
        widget.amount,
        widget.description,
        widget.currency,
        widget.callbackUrl,
        widget.firstName,
        widget.lastName,
        widget.email,
        widget.phoneNumber,
        widget.country,
      );

      print("Transaction créée avec succès: $transaction");

      setState(() {
        _isProcessing = false;
      });

      // Vérifier si nous avons reçu une URL de paiement
      String? paymentUrl;
      if (transaction.containsKey('payment_url')) {
        paymentUrl = transaction['payment_url'];
      } else if (transaction.containsKey('transaction')) {
        // Essayer d'extraire l'URL de paiement de l'objet transaction
        var transactionData = transaction['transaction'];
        if (transactionData is Map && transactionData.containsKey('generateToken')) {
          // Si FedaPay retourne un token/URL
          paymentUrl = transactionData['generateToken']['url'];
        }
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text("Transaction Créée"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("✅ Transaction créée avec succès !"),
              SizedBox(height: 10),
              if (transaction.containsKey('transaction') &&
                  transaction['transaction'] != null)
                ...[
                  Text("📄 Détails:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  if (transaction['transaction']['id'] != null)
                    Text("• ID: ${transaction['transaction']['id']}"),
                  Text("• Montant: ${widget.amount} ${widget.currency}"),
                  Text("• Client: ${widget.firstName} ${widget.lastName}"),
                ]
              else
                Text("Transaction créée mais détails non disponibles."),

              if (paymentUrl != null) ...[
                SizedBox(height: 15),
                Text("🔗 Lien de paiement disponible",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ]
            ],
          ),
          actions: [
            if (paymentUrl != null)
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openPaymentUrl(paymentUrl!);
                },
                icon: Icon(Icons.payment, color: Colors.blue),
                label: Text("Payer Maintenant",
                    style: TextStyle(color: Colors.blue)),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Retourner au formulaire
              },
              child: Text("Retour"),
            ),
          ],
        ),
      );

    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      print("Erreur lors de la création de la transaction: $e");

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 10),
              Text("Erreur"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("❌ Échec de la création de transaction"),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "Détails de l'erreur :\n$e",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "💡 Suggestions :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("• Vérifiez votre connexion internet"),
              Text("• Vérifiez les informations saisies"),
              Text("• Réessayez dans quelques instants"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                initiatePayment(); // Réessayer
              },
              child: Text("Réessayer", style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Retourner au formulaire
              },
              child: Text("Retour"),
            ),
          ],
        ),
      );
    }
  }

  void _openPaymentUrl(String url) {
    // Ici vous pouvez implémenter l'ouverture du lien de paiement
    // Par exemple avec url_launcher ou dans une WebView
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Lien de Paiement"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Ouvrir ce lien pour finaliser le paiement:"),
            SizedBox(height: 10),
            SelectableText(
              url,
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Fermer"),
          ),
          TextButton(
            onPressed: () {
              // Ici vous pouvez copier le lien ou l'ouvrir avec url_launcher
              Navigator.of(context).pop();
            },
            child: Text("Copier le lien"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Traitement du Paiement",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animation de chargement ou résultat
            _isProcessing
                ? Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepPurple,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Création de la transaction...",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Veuillez patienter",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
                : Container(),

            SizedBox(height: 30),

            // Récapitulatif de la transaction
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📋 Récapitulatif de la Transaction",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Divider(),
                    _buildInfoRow("Montant", "${widget.amount} ${widget.currency}"),
                    _buildInfoRow("Description", widget.description),
                    _buildInfoRow("Client", "${widget.firstName} ${widget.lastName}"),
                    _buildInfoRow("Email", widget.email),
                    _buildInfoRow("Téléphone", widget.phoneNumber),
                    _buildInfoRow("Pays", widget.country),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            if (!_isProcessing)
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back),
                label: Text("Retour au formulaire"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}