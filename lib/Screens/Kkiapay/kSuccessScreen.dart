import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final int amount;
  final String transactionId;

  // Constructor to accept amount and transactionId
  SuccessScreen({required this.amount, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Success"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              SizedBox(height: 20),
              Text(
                "Payment Successful!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Amount: \$${amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Transaction ID: $transactionId",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Back to Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
