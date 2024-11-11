import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

Future<Map<String, dynamic>> createTransaction(
    int amount,
    String description,
    String currencyIso,
    String callbackUrl,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String countryCode,
    ) async {
  final url = Uri.parse('$baseUrl/transactions');

  final headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'description': description,
    'amount': amount,
    'currency': {'iso': currencyIso},
    'callback_url': callbackUrl,
    'customer': {
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'phone_number': {
        'number': phoneNumber,
        'country': countryCode,
      }
    }
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to create transaction: ${response.statusCode}');
  }
}
