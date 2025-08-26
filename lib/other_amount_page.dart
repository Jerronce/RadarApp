// New file: other_amount_page.dart

import 'package:flutter/material.dart';

class OtherAmountPage extends StatefulWidget {
  final String name;
  const OtherAmountPage({super.key, required this.name});

  @override
  State<OtherAmountPage> createState() => _OtherAmountPageState();
}

class _OtherAmountPageState extends State<OtherAmountPage> {
  final _amountController = TextEditingController();

  // The confirmation dialog (same as before)
  void _showConfirmationDialog() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Request Received'),
      content: const Text('Your money is on the way. It will arrive in 48 hours.'),
      actions: [TextButton(child: const Text('Great!'), onPressed: () => Navigator.of(ctx).pop())],
    ));
  }

  // A new dialog to show an error message
  void _showErrorDialog(String message) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Invalid Amount'),
      content: Text(message),
      actions: [TextButton(child: const Text('OK'), onPressed: () => Navigator.of(ctx).pop())],
    ));
  }

  void _validateAndSubmit() {
    // tryParse safely converts text to a number. It returns null if the text is not a valid number.
    final amount = double.tryParse(_amountController.text);

    if (amount == null) {
      _showErrorDialog('Please enter a valid number.');
      return; // Stop the function here
    }

    if (amount > 10000000) {
      _showErrorDialog('The loan amount cannot be more than \$10,000,000.');
      return; // Stop the function here
    }

    // If both checks pass, show the confirmation
    _showConfirmationDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Amount', style: TextStyle(fontWeight: FontWeight.bold)),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter your desired loan amount:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
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
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              onPressed: _validateAndSubmit, // Call our validation function
              child: const Text('Request Loan'),
            ),
          ],
        ),
      ),
    );
  }
}
