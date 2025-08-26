import 'package:flutter/material.dart';
import 'month_page.dart';
import 'select_participants_page.dart';


class ContributePage extends StatefulWidget {
  final String name; // To receive the name from the homepage

  const ContributePage({super.key, required this.name});

  @override
  State<ContributePage> createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
  // A list of all the months to create our buttons automatically
  final List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar is similar to your homepage
      appBar: AppBar(
        // Flutter automatically adds a back button here because we used Navigator.push()
        title: const Text(
          'RADAR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: Text(widget.name)),
          ),
        ],
      ),

      // We don't add a bottomNavigationBar property, so it will be empty as you wanted

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // -- Search Row --
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

            // -- The Grid of Months --
            // We use an Expanded widget to make the GridView fill the available space
            Expanded(
              child: GridView.count(
                crossAxisCount: 3, // This creates 3 columns
                crossAxisSpacing: 10, // Horizontal space between buttons
                mainAxisSpacing: 10, // Vertical space between buttons
                children: months.map((String month) {
                  // This creates a button for each month in our list
                  return ElevatedButton(
                    onPressed: () {
                      // Action for when a month is tapped
                      // When a month is tapped, navigate to the new MonthPage
                      // and pass the name and the selected month.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MonthPage(name: widget.name, month: month),
                        ),
                      );
                      print('$month tapped');
                    },
                    child: Text(month),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // -- The Bottom Button --
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