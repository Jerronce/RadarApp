import 'package:flutter/material.dart';

class MePage extends StatefulWidget {
  final String name;
  const MePage({super.key, required this.name});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  // We create controllers to manage the text in the TextFields
  // and pre-fill them with the user's data.
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    // In a real app, you would load this data from a database.
    // For now, we'll use placeholder data.
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: 'jerry@example.com');
    _phoneController = TextEditingController(text: '+234 801 234 5678');
  }

  @override
  void dispose() {
    // It's good practice to dispose of controllers when the widget is removed
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // We use SingleChildScrollView to prevent the screen from overflowing
      // if the keyboard pops up.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Make children stretch to full width
            children: [
              const SizedBox(height: 20),

              // -- PROFILE PICTURE --
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  // In a real app, you'd use a NetworkImage or FileImage here
                  child: Icon(Icons.person, size: 50),
                ),
              ),
              const SizedBox(height: 40),

              // -- FULL NAME TEXTFIELD --
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // -- EMAIL TEXTFIELD --
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // -- PHONE NUMBER TEXTFIELD --
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 40),

              // -- SAVE CHANGES BUTTON --
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  // Logic to save the updated profile information
                  String newName = _nameController.text;
                  String newEmail = _emailController.text;
                  String newPhone = _phoneController.text;

                  print('Saving changes: $newName, $newEmail, $newPhone');
                  // You could show a confirmation pop-up here too
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
