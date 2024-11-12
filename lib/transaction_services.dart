import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kkiapay_fedapay/constant.dart';

Future<Map<String, dynamic>> createTransaction(
    int amount,
    String description,
    String currency,
    String callbackUrl,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String country) async {
  try {
    final response = await http.post(
      Uri.parse(transactionURL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'description': description,
        'amount': amount,
        'currency': currency,
        'callback_url': callbackUrl,
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'country': country,
      }),
    );

    if (response.statusCode == 200) {
      // Si la requête est réussie, on retourne la réponse de la transaction.
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la création de la transaction');
    }
  } catch (e) {
    throw Exception('Erreur lors de la création de la transaction: $e');
  }
}

