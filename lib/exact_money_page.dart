// New file: exact_money_page.dart

import 'package:flutter/material.dart';

class ExactMoneyPage extends StatelessWidget {
  final String name;
  const ExactMoneyPage({super.key, required this.name});

  // This function shows the confirmation pop-up
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Request Received'),
          content: const Text('Your money is on the way. It will arrive in 48 hours.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Great!'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // A list of the money amounts from your design
    final List<int> amounts = [15000, 50000, 70000, 70000, 100000];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exact Money', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: Text(name)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: amounts.map((amount) {
            // Create a button for each amount in the list
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
                onPressed: () => _showConfirmationDialog(context),
                child: Text('\$$amount'),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
