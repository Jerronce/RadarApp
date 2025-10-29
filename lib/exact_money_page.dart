import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExactMoneyPage extends StatelessWidget {
  final String name;
  const ExactMoneyPage({super.key, required this.name});

  void _showConfirmationDialog(BuildContext context, int amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Request Received'),
          content: Text('You requested \$$amount. Your money is on the way and will arrive in 48 hours.'),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('moneyAmounts').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data.'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No money amounts currently available.'));
            }

            // Get available live money amounts (assume a field 'amount' in each doc)
            final amounts = snapshot.data!.docs.map((doc) => doc['amount'] as int).toList();

            return Column(
              children: amounts.map((amount) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    onPressed: () => _showConfirmationDialog(context, amount),
                    child: Text('\$$amount'),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
