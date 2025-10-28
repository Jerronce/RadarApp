import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/firestore_service.dart';
import 'history_page.dart';
import 'settings_page.dart';
import 'loan_page.dart';
import 'select_participants_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _firestoreService = FirestoreService();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _showAddFundsDialog() async {
    final amountController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Funds (USD)'),
        content: TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: 'Enter amount',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
              if (amount <= 0) return;

              // Placeholder payment integration
              final res = await _firestoreService.initiatePayment(
                amount: amount,
                paymentMethod: 'card_placeholder',
              );
              if (res['success'] == true) {
                await _firestoreService.updateBalance(amount);
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Funds added: \$amount USD')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _createContribution() async {
    final amountController = TextEditingController();
    final descController = TextEditingController();
    String cycleType = 'month';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Contribution'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount (USD)'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: cycleType,
                items: const [
                  DropdownMenuItem(value: 'month', child: Text('Monthly')),
                  DropdownMenuItem(value: 'exact_money', child: Text('Exact Money')),
                ],
                onChanged: (v) => cycleType = v ?? 'month',
                decoration: const InputDecoration(labelText: 'Cycle Type'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
              if (amount <= 0 || descController.text.trim().isEmpty) return;
              await _firestoreService.createContribution(
                amount: amount,
                description: descController.text.trim(),
                cycleType: cycleType,
              );
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(String uid) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        final balance = (snapshot.data?.get('balance') ?? 0.0).toDouble();
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Wallet Balance', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Text(
                      '\$${balance.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showAddFundsDialog,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: const Text('Add Funds', style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () async {
                        // Simple withdraw simulation
                        if (balance <= 0) return;
                        await _firestoreService.updateBalance(-balance.clamp(0, balance));
                      },
                      child: const Text('Withdraw'),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContributions() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getAllContributions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No active contributions'));
        }
        final docs = snapshot.data!.docs;
        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final id = docs[index].id;
            final amount = (data['amount'] ?? 0.0).toDouble();
            return ListTile(
              title: Text(data['description'] ?? 'Contribution'),
              subtitle: Text('${data['cycleType']} • Participants: ${List.from(data['participants'] ?? []).length}'),
              trailing: Text('\$${amount.toStringAsFixed(2)}'),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectParticipantsPage(contributionId: id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildTransactions() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getTransactionHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No transactions yet'));
        }
        final docs = snapshot.data!.docs;
        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final isCredit = (data['type'] ?? '') == 'credit';
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isCredit ? Colors.green.shade100 : Colors.red.shade100,
                child: Icon(isCredit ? Icons.arrow_downward : Icons.arrow_upward, color: isCredit ? Colors.green : Colors.red),
              ),
              title: Text(data['description'] ?? (isCredit ? 'Credit' : 'Debit')),
              subtitle: Text((data['timestamp'] as Timestamp?)?.toDate().toString() ?? ''),
              trailing: Text(
                (isCredit ? '+' : '-') + '\$' + (data['amount'] ?? 0.0).toStringAsFixed(2),
                style: TextStyle(color: isCredit ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotifications() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No notifications'));
        }
        final docs = snapshot.data!.docs;
        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final isRead = data['isRead'] == true;
            return ListTile(
              leading: Icon(isRead ? Icons.notifications_none : Icons.notifications_active, color: isRead ? Colors.grey : Colors.blue),
              title: Text(data['title'] ?? 'Notification'),
              subtitle: Text(data['message'] ?? ''),
              trailing: Text((data['timestamp'] as Timestamp?)?.toDate().toString() ?? ''),
              onTap: () => _firestoreService.markNotificationAsRead(docs[index].id),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    final pages = <Widget>[
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(user.uid),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _createContribution,
                    icon: const Icon(Icons.group_add),
                    label: const Text('New Contribution'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoanPage())),
                    icon: const Icon(Icons.account_balance),
                    label: const Text('Loans'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Active Contributions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(height: 420, child: _buildContributions()),
          ],
        ),
      ),
      _buildTransactions(),
      _buildNotifications(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('RadarApp'),
        actions: [
          IconButton(
            tooltip: 'History',
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage())),
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _createContribution,
              icon: const Icon(Icons.add),
              label: const Text('Contribution'),
            )
          : null,
    );
  }
}
