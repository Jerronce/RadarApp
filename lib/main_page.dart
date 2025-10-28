// New file: main_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage.dart'; // Import your homepage
import 'history_page.dart'; // Import your new history page
import 'me_page.dart';

class MainPage extends StatefulWidget {
  final String name;
  const MainPage({super.key, required this.name});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Tracks the currently selected tab
  late final List<Widget> _pages; // A list to hold our pages
  
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Initialize the list of pages here, so we can pass the user's name
    _pages = [
      Homepage(name: widget.name),
      HistoryPage(name: widget.name),
    ];
    
    // Load user data from Firestore
    _loadUserData();
  }

  // Load user data from Firestore
  Future<void> _loadUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          // User data loaded successfully
          print('User data loaded: ${userDoc.data()}');
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // In main_page.dart
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('RADAR', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        // REPLACE THE ACTIONS SECTION WITH THIS:
        actions: [
          TextButton(
            onPressed: () {
              // This is where we navigate to the new MePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MePage(name: widget.name)),
              );
            },
            child: Text(
              'Welcome, ${widget.name}',
              style: TextStyle(color: Colors.blue), // Set color to make it visible
            ),
          ),
        ],
      ),
      // The body of the screen is now just the selected page from our list
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Records',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Firestore Service Class for Ajo Circles, Loans, and Transactions
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create Ajo Circle
  Future<String?> createAjoCircle({
    required String name,
    required double contributionAmount,
    required String frequency,
    required List<String> memberIds,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DocumentReference ajoRef = await _firestore.collection('ajo_circles').add({
        'name': name,
        'contributionAmount': contributionAmount,
        'frequency': frequency,
        'createdBy': user.uid,
        'memberIds': memberIds,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });

      return ajoRef.id;
    } catch (e) {
      print('Error creating Ajo circle: $e');
      return null;
    }
  }

  // Get User's Ajo Circles
  Stream<QuerySnapshot> getUserAjoCircles() {
    User? user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('ajo_circles')
        .where('memberIds', arrayContains: user.uid)
        .snapshots();
  }

  // Add Member to Ajo Circle
  Future<bool> addMemberToAjoCircle(String ajoCircleId, String memberId) async {
    try {
      await _firestore.collection('ajo_circles').doc(ajoCircleId).update({
        'memberIds': FieldValue.arrayUnion([memberId]),
      });
      return true;
    } catch (e) {
      print('Error adding member to Ajo circle: $e');
      return false;
    }
  }

  // Create Loan
  Future<String?> createLoan({
    required String ajoCircleId,
    required double amount,
    required String borrowerId,
    required double interestRate,
    required DateTime dueDate,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DocumentReference loanRef = await _firestore.collection('loans').add({
        'ajoCircleId': ajoCircleId,
        'amount': amount,
        'borrowerId': borrowerId,
        'interestRate': interestRate,
        'dueDate': Timestamp.fromDate(dueDate),
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
        'approvedBy': [],
      });

      return loanRef.id;
    } catch (e) {
      print('Error creating loan: $e');
      return null;
    }
  }

  // Get Loans for User
  Stream<QuerySnapshot> getUserLoans() {
    User? user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('loans')
        .where('borrowerId', isEqualTo: user.uid)
        .snapshots();
  }

  // Get Loans for Ajo Circle
  Stream<QuerySnapshot> getAjoCircleLoans(String ajoCircleId) {
    return _firestore
        .collection('loans')
        .where('ajoCircleId', isEqualTo: ajoCircleId)
        .snapshots();
  }

  // Create Transaction (Contribution/Payment)
  Future<String?> createTransaction({
    required String ajoCircleId,
    required double amount,
    required String type, // 'contribution', 'loan_payment', 'withdrawal'
    String? loanId,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DocumentReference transactionRef = await _firestore.collection('transactions').add({
        'ajoCircleId': ajoCircleId,
        'userId': user.uid,
        'amount': amount,
        'type': type,
        'loanId': loanId,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'completed',
      });

      return transactionRef.id;
    } catch (e) {
      print('Error creating transaction: $e');
      return null;
    }
  }

  // Get Transactions for User
  Stream<QuerySnapshot> getUserTransactions() {
    User? user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get Transactions for Ajo Circle
  Stream<QuerySnapshot> getAjoCircleTransactions(String ajoCircleId) {
    return _firestore
        .collection('transactions')
        .where('ajoCircleId', isEqualTo: ajoCircleId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Update User Profile
  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return false;

      await _firestore.collection('users').doc(user.uid).update(data);
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Get User Profile
  Future<DocumentSnapshot?> getUserProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      return await _firestore.collection('users').doc(user.uid).get();
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }
}
