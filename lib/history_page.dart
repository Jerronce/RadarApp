// New file: history_page.dart

import 'package:flutter/material.dart';
import 'settings_page.dart';


// First, let's create a data model for a single transaction
class Transaction {
  final String amount;
  final String status;
  final String month;
  final bool isReceived;

  Transaction({
    required this.amount,
    required this.status,
    required this.month,
    required this.isReceived,
  });
}

class HistoryPage extends StatefulWidget {
  final String name;
  const HistoryPage({super.key, required this.name});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // In a real app, this data would come from a database.
  // Here is some sample data based on your design.
  final List<Transaction> _transactions = [
    Transaction(amount: '\$100000', status: 'Received', month: 'Jan', isReceived: true),
    Transaction(amount: '\$50000', status: 'Received', month: 'Mar', isReceived: true),
    Transaction(amount: '\$10000', status: 'Paid', month: 'Jun', isReceived: false),
    Transaction(amount: '\$100000', status: 'Paid', month: 'Jan', isReceived: false),
    Transaction(amount: '\$10000', status: 'Paid', month: 'Dec', isReceived: false),
    Transaction(amount: '\$10000', status: 'Paid', month: 'Oct', isReceived: false),
    Transaction(amount: '\$10000', status: 'Paid', month: 'Oct', isReceived: false),
  ];

  @override
  Widget build(BuildContext context) {
    // Note: We don't need a Scaffold here because the MainPage will provide it.
    // This widget is just the content of the screen.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // -- Search and Settings Row --
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.settings, size: 36),
                onPressed: () {
                  // Navigate to the new SettingsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // -- The List of Transactions --
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  // We use a Row to lay out the items horizontally
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transaction.amount,
                        style: TextStyle(
                          color: transaction.isReceived ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(transaction.status, style: const TextStyle(fontSize: 16)),
                      Text(transaction.month, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
