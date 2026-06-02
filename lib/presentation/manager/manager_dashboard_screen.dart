import 'package:flutter/material.dart';
import 'pages/overview_page.dart';
import 'pages/inventory_page.dart';
import 'pages/history_page.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const OverviewPage(),
    const InventoryPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background yang senada dengan gradien sebelumnya jika diperlukan
      backgroundColor: Colors.white, 
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFFFF8C42), // Warna Oranye khas app Anda
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed, // Tetap stabil meski banyak tab
            elevation: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded), 
                label: "Overview"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_rounded), 
                label: "Stok"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded), 
                label: "Riwayat"
              ),
            ],
          ),
        ),
      ),
    );
  }
}