import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings_page.dart';

class HistoryPage extends StatefulWidget {
  final String name;
  const HistoryPage({super.key, required this.name});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    // Replace 'userId' with the real user's Firebase Auth UID in production!
    final String userId = widget.name; // For demonstration, using name (replace with real UID!)

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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('transactions')
                  .where('userId', isEqualTo: userId) // Ensure you store userId in each transaction!
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No transactions found.'));
                }

                final data = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final tx = data[index];
                    final amount = tx['amount'].toString();
                    final status = tx['status'] ?? '';
                    final month = tx['month'] ?? '';
                    final isReceived = (tx['isReceived'] ?? false) as bool;

                    return Padding(
                      padding: const EdgeInsets.symmetric
