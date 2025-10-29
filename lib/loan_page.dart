import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'exact_money_page.dart';
import 'other_amount_page.dart';

class LoanPage extends StatefulWidget {
  final String name;
  final String month;

  const LoanPage({super.key, required this.name, required this.month});

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Loan', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: Text(widget.name)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // -- Search Bar --
            TextField(
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
            const SizedBox(height: 24),

            // -- Show live available loan records from Firestore, optionally by month or status --
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('loans')
                    .where('status', isEqualTo: 'available') // Show only available loans
                    .where('month', isEqualTo: widget.month) // Optional: by user's current month
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No loan amounts available for this month.'));
                  }

                  final loans = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: loans.length,
                    itemBuilder: (context, index) {
                      final loan = loans[index];
                      final amount = loan['amount'].toString();
                      final loanOwner = loan['ownerName'] ?? 'Unknown';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text('\$$amount', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Owner: $loanOwner'),
                          trailing: ElevatedButton(
                            child: const Text('Request'),
                            onPressed: ()
