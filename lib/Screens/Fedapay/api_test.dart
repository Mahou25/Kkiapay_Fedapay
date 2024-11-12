import 'package:flutter/material.dart';
import '../../transaction_services.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();

  void initiatePayment(BuildContext context) async {
    try {
      final transaction = await createTransaction(
        int.parse(_amountController.text), // Montant de la transaction
        "Transaction for john.doe@example.com",
        "XOF",
        "https://votre_callback_url.com/callback",
        "John",
        "Doe",
        "john.doe@example.com",
        "+22997808080",
        "BJ",
      );

      print("Transaction réussie: $transaction");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Succès"),
          content: Text("Transaction réussie : ${transaction['transaction']['id']}"), // Affiche l'ID ou un autre champ pertinent
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Erreur lors de la création de la transaction: $e");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erreur"),
          content: Text("Erreur lors de la création de la transaction : $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paiement"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: "Montant de la transaction (XOF)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              // Pass the function reference without parentheses
              onPressed: () => initiatePayment(context),  // Fixed this line
              child: Text("Payer"),
            ),
          ],
        ),
      ),
    );
  }

}
