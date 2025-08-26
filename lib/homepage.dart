import 'package:flutter/material.dart';
import 'contribute_page.dart';
import 'select_participants_page.dart';
import 'settings_page.dart';


class Homepage extends StatefulWidget {
  final String name; // This will hold the name from the login screen

  const Homepage({super.key, required this.name});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0; // To keep track of the selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // === TOP APP BAR ===


      // === SCREEN BODY ===
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // -- Search and Settings Row --
            Row(
              children: [
                Expanded( // This makes the search bar take up available space
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none, // No border line
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
            const SizedBox(height: 40),

            // -- Note Text --
            const Text(
              'Note: Money can only be contributed monthly.',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),

            // -- Buttons Column --
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              onPressed: () {

                // This will navigate to the new page when pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContributePage(name: widget.name)),
                );
              },
              child: const Text('Contribute'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectParticipantsPage(name: widget.name)),
                );

              },
              child: const Text('Participants'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectParticipantsPage(name: widget.name)),
                );

              },
              child: const Text('Select Participants'),
            ),
          ],
        ),
      ),


    );
  }
}