import 'package:flutter/material.dart';
import 'settings_page.dart';

// First, we create a "model" for our data. This class represents a single participant.
class Participant {
  final String name;
  bool isSelected;

  Participant({required this.name, this.isSelected = false});
}

class SelectParticipantsPage extends StatefulWidget {
  final String name; // To receive the user's name

  const SelectParticipantsPage({super.key, required this.name});

  @override
  State<SelectParticipantsPage> createState() => _SelectParticipantsPageState();
}

class _SelectParticipantsPageState extends State<SelectParticipantsPage> {
  // In a real app, this list would come from a database.
  // For now, we create a sample list of participants.
  final List<Participant> _participants = [
    Participant(name: 'Frank'),
    Participant(name: 'David'),
    Participant(name: 'Faith'),
    Participant(name: 'Landrie'),
    Participant(name: 'Fola'),
    Participant(name: 'Grace'),
    Participant(name: 'Ben'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Participants', style: TextStyle(fontWeight: FontWeight.bold)),
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
            const Text('Note: Only 1 can be selected', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 20),

            // -- The List of Participants --
            // We use Expanded and ListView.builder to create a scrollable list
            Expanded(
              child: ListView.builder(
                itemCount: _participants.length,
                itemBuilder: (context, index) {
                  // Get the participant for the current row
                  final participant = _participants[index];
                  return Card( // Using a Card for a nice visual container
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(participant.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      // The trailing widget is our interactive toggle switch
                      trailing: Switch(
                        value: participant.isSelected,
                        onChanged: (bool value) {
                          // This is where the magic happens!
                          setState(() {
                            // When the switch is tapped, we update the isSelected status
                            // for this specific participant in our list.
                            participant.isSelected = value;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // -- The Bottom "CONFIRM" Button --
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
    // In select_participants_page.dart

    onPressed: () {
    // First, we can still print the names for our own testing
    final selectedParticipants = _participants
        .where((p) => p.isSelected)
        .map((p) => p.name)
        .toList();
    print('Confirmed participants: $selectedParticipants');

    // NOW, WE SHOW THE POP-UP
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(
    title: const Text('Congratulations!'),
    content: const Text('The participants have been successfully selected.'),
    actions: <Widget>[
    TextButton(
    child: const Text('OK'),
    onPressed: () {
    Navigator.of(context).pop(); // Closes the pop-up
    },
    ),
    ],
    );
    },
    );
    },

              child: const Text('CONFIRM'),
            ),
          ],
        ),
      ),
    );
  }
}
