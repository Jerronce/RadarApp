// New file: signup_page.dart

import 'package:flutter/material.dart';
import 'package:radarflutter/main_page.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // We need a controller for each text field
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We don't need a full AppBar, just a way to go back
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Center(child: Text("RADAR", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
              const SizedBox(height: 40),

              // -- NAME TEXTFIELD --
              const Text("Write your name"),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Type Here',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ),
              const SizedBox(height: 20),

              // -- EMAIL TEXTFIELD --
              const Text("Enter your Email"),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'email@example.com',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ),
              const SizedBox(height: 20),

              // -- PHONE TEXTFIELD --
              const Text("Enter your Phone Number"),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '+234...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ),
              const SizedBox(height: 20),

              // -- PASSWORD TEXTFIELD --
              const Text("Create a Password"),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true, // This hides the text for passwords
                decoration: const InputDecoration(
                  hintText: '********',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ),
              const SizedBox(height: 40),

              // -- SIGN UP BUTTON --
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                onPressed: () {
                  // In a real app, you would save this data to a database.
                  // For now, we will just navigate to the main app.
                  String userName = _nameController.text;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MainPage(name: userName)),
                        (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Sign up', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),

              // -- SOCIAL ICONS (same as your login page) --
              const Center(child: Text('or sign up with')),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.android, size: 36),
                  SizedBox(width: 20),
                  Icon(Icons.facebook, size: 36, color: Colors.blue),
                  SizedBox(width: 20),
                  Icon(Icons.close, size: 36),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}