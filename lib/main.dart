import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'main_page.dart';
import 'signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage (title: 'Radar '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// REPLACE your old _MyHomePageState class with this entire block of code
class _MyHomePageState extends State<MyHomePage> {
  final _nameController = TextEditingController(); // <-- ADD THIS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // This will show 'Radar'
        centerTitle: true,
      ),
      // We use Padding to give some space from the screen edges
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          // We use a Column to arrange all the items vertically
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // This centers the column vertically
            children: <Widget>[
              // 1. YOUR LOGO
              // I'm using a placeholder FlutterLogo. You will replace this.
              Image.asset('assets/images/logo.png'),
              const SizedBox(height: 0.5), // Spacing
              // 2. "Related to Jerry" TEXT
              const Text(
                'READY TO SAVE?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32), // Spacing
              // 3. "Enter Full Name" TEXT
              const Text('Enter Full Name'),
              const SizedBox(height: 8), // Spacing
              // 4. THE TEXT FIELD
              TextField(
                controller: _nameController, // <-- ADD THIS
                decoration: const InputDecoration(
                  hintText: 'Type Here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
              ),
              const SizedBox(height: 24), // Spacing
              // 5. THE LOG IN BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Make button wide
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  // This is what happens when you press the button
                  // 1. Get the name the user typed
                  String userName = _nameController.text;
                  Navigator.push(
                    context,
                    // Change this to MainPage
                    MaterialPageRoute(builder: (context) => MainPage(name: userName)),
                  );
                },
                child: const Text('LOG IN', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24), // Spacing
              // 6. "or sign in with" TEXT
              const Text('or sign in with'),
              const SizedBox(height: 16), // Spacing
              // 7. THE SOCIAL ICONS
              const Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the icons horizontally
                children: [
                  Icon(Icons.apple, size: 36), // Placeholder for Google
                  SizedBox(width: 20), // Spacing between icons
                  Icon(Icons.facebook, size: 36, color: Colors.blue), // Placeholder for Facebook
                  SizedBox(width: 20), // Spacing between icons
                  Icon(Icons. close, size: 36), // Placeholder for X
                ],
              ),
              const SizedBox(height: 32), // Spacing
              // 8. THE SIGN UP TEXT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text('Sign up'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
