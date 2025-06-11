import 'package:flutter/material.dart';
import 'package:pharma_connect_flutter/presentation/pages/admin/medicines/medicines_screen.dart';
import 'package:pharma_connect_flutter/presentation/pages/admin/pharmacies/pharmacies_screen.dart';
import 'package:pharma_connect_flutter/presentation/pages/admin/add_medicine_screen.dart';
import 'package:pharma_connect_flutter/presentation/pages/admin/applications/applications_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/application/notifiers/auth_notifier.dart';
import 'package:pharma_connect_flutter/application/notifiers/application_notifier.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const AdminPharmaciesScreen(),
      AdminMedicinesScreen(),
      const AddMedicineScreen(),
      const AdminApplicationsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 3) {
      // Refresh applications when Applications tab is tapped
      final container = ProviderScope.containerOf(context, listen: false);
      final notifier = container.read(applicationProvider.notifier);
      notifier.loadApplications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          Consumer(
            builder: (context, ref, _) => IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final notifier = ref.read(authProvider.notifier);
                await notifier.logout();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            label: 'Pharmacies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Medicines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Medicine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Applications',
          ),
        ],
      ),
    );
  }
}
