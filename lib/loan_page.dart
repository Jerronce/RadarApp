import 'package:flutter/material.dart';
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

            // This Expanded widget centers the buttons vertically
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // -- "EXACT MONEY" Button --
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    onPressed: () {
                      // Logic for requesting a loan of a specific amount

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExactMoneyPage(name: widget.name)),
                      );
                    },
                    child: const Text('EXACT MONEY'),
                  ),
                  const SizedBox(height: 20),

                  // -- "OTHER" Button --
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    onPressed: () {
                      // Logic for requesting a custom loan amount
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OtherAmountPage(name: widget.name)),
                       );


                    },
                    child: const Text('OTHER'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}