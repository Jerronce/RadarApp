import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // User Authentication
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // Create user account
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'balance': 0.0,
        'currency': 'USD',
        'darkMode': false,
        'notifications': true,
      });

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    try {
      String? uid = currentUserId;
      if (uid != null) {
        // Delete user data from Firestore
        await _firestore.collection('users').doc(uid).delete();
        
        // Delete all user's contributions
        var contributions = await _firestore
            .collection('contributions')
            .where('userId', isEqualTo: uid)
            .get();
        for (var doc in contributions.docs) {
          await doc.reference.delete();
        }
        
        // Delete all user's transactions
        var transactions = await _firestore
            .collection('transactions')
            .where('userId', isEqualTo: uid)
            .get();
        for (var doc in transactions.docs) {
          await doc.reference.delete();
        }

        // Delete Firebase Auth account
        await _auth.currentUser?.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  // User Data
  Stream<DocumentSnapshot> getUserData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Future<Map<String, dynamic>?> getUserDataOnce(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  Future<void> updateUserProfile({
    String? fullName,
    String? phoneNumber,
  }) async {
    if (currentUserId == null) return;
    
    Map<String, dynamic> updates = {};
    if (fullName != null) updates['fullName'] = fullName;
    if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
    
    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(currentUserId).update(updates);
    }
  }

  // Wallet Operations
  Future<void> updateBalance(double amount) async {
    if (currentUserId == null) return;
    
    await _firestore.collection('users').doc(currentUserId).update({
      'balance': FieldValue.increment(amount),
    });
    
    // Record transaction
    await _firestore.collection('transactions').add({
      'userId': currentUserId,
      'amount': amount,
      'type': amount > 0 ? 'credit' : 'debit',
      'description': amount > 0 ? 'Deposit' : 'Withdrawal',
      'timestamp': FieldValue.serverTimestamp(),
      'currency': 'USD',
    });
  }

  Future<double> getBalance() async {
    if (currentUserId == null) return 0.0;
    
    DocumentSnapshot doc = await _firestore.collection('users').doc(currentUserId).get();
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    return (data?['balance'] ?? 0.0).toDouble();
  }

  Stream<double> getBalanceStream() {
    if (currentUserId == null) return Stream.value(0.0);
    
    return _firestore.collection('users').doc(currentUserId).snapshots().map((doc) {
      Map<String, dynamic>? data = doc.data();
      return (data?['balance'] ?? 0.0).toDouble();
    });
  }

  // Contributions
  Future<void> createContribution({
    required double amount,
    required String description,
    required String cycleType, // 'exact_money', 'month'
  }) async {
    if (currentUserId == null) return;
    
    await _firestore.collection('contributions').add({
      'userId': currentUserId,
      'amount': amount,
      'description': description,
      'cycleType': cycleType,
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
      'participants': [currentUserId],
      'currentRound': 0,
    });
  }

  Stream<QuerySnapshot> getUserContributions() {
    if (currentUserId == null) return Stream.value(FirebaseFirestore.instance.collection('contributions').snapshots() as QuerySnapshot);
    
    return _firestore
        .collection('contributions')
        .where('participants', arrayContains: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllContributions() {
    return _firestore
        .collection('contributions')
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> joinContribution(String contributionId) async {
    if (currentUserId == null) return;
    
    await _firestore.collection('contributions').doc(contributionId).update({
      'participants': FieldValue.arrayUnion([currentUserId]),
    });
  }

  // Transaction History
  Stream<QuerySnapshot> getTransactionHistory() {
    if (currentUserId == null) return Stream.empty();
    
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Notifications
  Future<void> createNotification({
    required String title,
    required String message,
    required String type,
  }) async {
    if (currentUserId == null) return;
    
    await _firestore.collection('notifications').add({
      'userId': currentUserId,
      'title': title,
      'message': message,
      'type': type,
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getNotifications() {
    if (currentUserId == null) return Stream.empty();
    
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  Future<void> markAllNotificationsAsRead() async {
    if (currentUserId == null) return;
    
    var notifications = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .get();
    
    for (var doc in notifications.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  // Settings
  Future<void> updateDarkMode(bool enabled) async {
    if (currentUserId == null) return;
    
    await _firestore.collection('users').doc(currentUserId).update({
      'darkMode': enabled,
    });
  }

  Future<void> updateNotifications(bool enabled) async {
    if (currentUserId == null) return;
    
    await _firestore.collection('users').doc(currentUserId).update({
      'notifications': enabled,
    });
  }

  // Loan Operations
  Future<void> requestLoan({
    required double amount,
    required int months,
    required String purpose,
  }) async {
    if (currentUserId == null) return;
    
    double interestRate = 0.05; // 5% interest
    double totalAmount = amount + (amount * interestRate);
    double monthlyPayment = totalAmount / months;
    
    await _firestore.collection('loans').add({
      'userId': currentUserId,
      'amount': amount,
      'interestRate': interestRate,
      'totalAmount': totalAmount,
      'months': months,
      'monthlyPayment': monthlyPayment,
      'purpose': purpose,
      'status': 'pending',
      'paidAmount': 0.0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getUserLoans() {
    if (currentUserId == null) return Stream.empty();
    
    return _firestore
        .collection('loans')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> makeLoanPayment(String loanId, double amount) async {
    if (currentUserId == null) return;
    
    // Get current balance
    double balance = await getBalance();
    if (balance < amount) {
      throw Exception('Insufficient balance');
    }
    
    // Update loan
    DocumentSnapshot loanDoc = await _firestore.collection('loans').doc(loanId).get();
    Map<String, dynamic> loanData = loanDoc.data() as Map<String, dynamic>;
    double newPaidAmount = (loanData['paidAmount'] ?? 0.0) + amount;
    double totalAmount = loanData['totalAmount'];
    
    await _firestore.collection('loans').doc(loanId).update({
      'paidAmount': newPaidAmount,
      'status': newPaidAmount >= totalAmount ? 'completed' : 'active',
    });
    
    // Deduct from balance
    await updateBalance(-amount);
  }

  // Payment Integration (Placeholder)
  Future<Map<String, dynamic>> initiatePayment({
    required double amount,
    required String paymentMethod,
  }) async {
    // This is a placeholder for payment API integration
    // In production, integrate with payment providers like Stripe, PayPal, etc.
    
    return {
      'success': true,
      'transactionId': 'PLACEHOLDER_${DateTime.now().millisecondsSinceEpoch}',
      'amount': amount,
      'currency': 'USD',
      'message': 'Payment API integration pending',
    };
  }

  // Participants Management
  Stream<List<Map<String, dynamic>>> getContributionParticipants(String contributionId) async* {
    await for (DocumentSnapshot contributionDoc in _firestore.collection('contributions').doc(contributionId).snapshots()) {
      if (!contributionDoc.exists) {
        yield [];
        continue;
      }
      
      Map<String, dynamic> data = contributionDoc.data() as Map<String, dynamic>;
      List<String> participantIds = List<String>.from(data['participants'] ?? []);
      
      if (participantIds.isEmpty) {
        yield [];
        continue;
      }
      
      List<Map<String, dynamic>> participants = [];
      for (String uid in participantIds) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          participants.add(userDoc.data() as Map<String, dynamic>);
        }
      }
      
      yield participants;
    }
  }
}
