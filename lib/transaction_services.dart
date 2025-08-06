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

  print('=== DÉBUT CRÉATION TRANSACTION ===');
  print('URL: $transactionURL');

  // Debug des paramètres d'entrée
  print('Paramètres reçus:');
  print('  - amount: $amount (type: ${amount.runtimeType})');
  print('  - description: "$description" (length: ${description.length})');
  print('  - currency: "$currency"');
  print('  - callbackUrl: "$callbackUrl"');
  print('  - firstName: "$firstName"');
  print('  - lastName: "$lastName"');
  print('  - email: "$email"');
  print('  - phoneNumber: "$phoneNumber"');
  print('  - country: "$country"');

  // Validation des paramètres
  if (amount <= 0) {
    print('ERROR: Montant invalide: $amount');
    throw Exception('Montant invalide: doit être supérieur à 0');
  }

  if (description.isEmpty) {
    print('ERROR: Description vide');
    throw Exception('Description ne peut pas être vide');
  }

  if (email.isEmpty || !email.contains('@')) {
    print('ERROR: Email invalide: $email');
    throw Exception('Email invalide');
  }

  // Construction du body
  final Map<String, dynamic> requestBody = {
    'description': description,
    'amount': amount,
    'currency': currency,
    'callback_url': callbackUrl,
    'firstname': firstName,
    'lastname': lastName,
    'email': email,
    'phone_number': phoneNumber,
    'country': country,
  };

  print('Body de la requête:');
  print(json.encode(requestBody));

  try {
    print('Envoi de la requête HTTP POST...');

    final response = await http.post(
      Uri.parse(transactionURL),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Si vous utilisez le middleware API simple :
        // 'X-API-Key': 'your-simple-api-key-here',
      },
      body: json.encode(requestBody),
    ).timeout(
      Duration(seconds: 30),
      onTimeout: () {
        print('ERROR: Timeout de la requête (30s)');
        throw Exception('Timeout: La requête a pris trop de temps');
      },
    );

    print('Réponse reçue:');
    print('  - Status Code: ${response.statusCode}');
    print('  - Headers: ${response.headers}');
    print('  - Body: ${response.body}');
    print('  - Content-Length: ${response.contentLength}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('SUCCESS: Transaction créée avec succès');
      try {
        final responseData = json.decode(response.body);
        print('Données décodées: $responseData');
        return responseData;
      } catch (jsonError) {
        print('ERROR: Impossible de décoder la réponse JSON: $jsonError');
        print('Réponse brute: ${response.body}');
        throw Exception('Réponse JSON invalide: $jsonError');
      }
    } else {
      print('ERROR: Status code non-200: ${response.statusCode}');
      print('Message d\'erreur du serveur: ${response.body}');

      // Essayer de décoder l'erreur si c'est du JSON
      try {
        final errorData = json.decode(response.body);
        print('Détails de l\'erreur: $errorData');
        throw Exception('Erreur serveur (${response.statusCode}): ${errorData['message'] ?? response.body}');
      } catch (jsonError) {
        throw Exception('Erreur serveur (${response.statusCode}): ${response.body}');
      }
    }

  } on http.ClientException catch (e) {
    print('ERROR: Erreur de client HTTP: $e');
    throw Exception('Erreur de connexion: Vérifiez votre connexion internet');

  } on FormatException catch (e) {
    print('ERROR: Erreur de format: $e');
    throw Exception('Erreur de format des données: $e');

  } on Exception catch (e) {
    print('ERROR: Exception générique: $e');
    rethrow;

  } catch (e) {
    print('ERROR: Erreur inattendue: $e (type: ${e.runtimeType})');
    throw Exception('Erreur inattendue: $e');

  } finally {
    print('=== FIN CRÉATION TRANSACTION ===\n');
  }
}