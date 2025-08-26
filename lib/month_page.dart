import 'package:flutter/material.dart';
import 'loan_page.dart'; // We will create this file next

class MonthPage extends StatefulWidget {
  final String name;
  final String month;

  const MonthPage({super.key, required this.name, required this.month});

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  final _amountController = TextEditingController();
  bool _isAmountEntered = false; // NEW: To track if the user has typed anything

  // NEW: This is the function that shows the "Congratulations" pop-up
  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('Your contribution has been received.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // This closes the pop-up
              },
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
        title: Text(widget.month, style: const TextStyle(fontWeight: FontWeight.bold)),
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
            // ... (The Search TextField remains the same) ...
            const SizedBox(height: 40),
            const Text('Note: its a fixed price', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 30),

            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.attach_money, size: 40),
                hintText: '0.00',
                border: InputBorder.none,
              ),
              // NEW: This checks for changes in the text field
              onChanged: (value) {
                setState(() {
                  _isAmountEntered = value.isNotEmpty;
                });
              },
            ),

            const SizedBox(height: 20),

            // NEW: This "Continue" button only appears if an amount is entered
            if (_isAmountEntered)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
                onPressed: _showCongratulationsDialog, // Calls the pop-up function
                child: const Text('Continue'),
              ),

            const Expanded(child: SizedBox()), // Pushes buttons to the bottom

            // UPDATED: The "Loan" button now navigates to the LoanPage
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoanPage(name: widget.name, month: widget.month)),
                );
              },
              child: const Text('Loan'),
            ),
          ],
        ),
      ),
    );
  }
}