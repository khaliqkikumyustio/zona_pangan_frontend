import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/core/network/api_service.dart';
import '/presentation/auth/login_screen.dart'; // Sesuaikan path ini dengan lokasi file LoginScreen Anda

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fungsi Logout Baru
  Future<void> _handleLogout() async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Keluar")),
        ],
      ),
    );

    if (confirm == true) {
      await context.read<AuthProvider>().logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _loadData() async {
    final auth = context.read<AuthProvider>();
    final company = auth.companyName;

    if (company == null || company.isEmpty) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      final data = await ApiService().getOverview(company);
      if (mounted) {
        setState(() {
          dashboardData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error load data: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Overview Stok", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFF8C42),
        foregroundColor: Colors.white,
        elevation: 0,
        // Tombol Logout ditambahkan di sini
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF8C42)))
          : (dashboardData == null || dashboardData!['stats'] == null)
              ? const Center(child: Text("Belum ada data tersedia"))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sections: _generateSections(dashboardData!['stats']),
                            sectionsSpace: 4,
                            centerSpaceRadius: 50,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          leading: const Icon(Icons.eco, color: Colors.green, size: 40),
                          title: const Text("Food Waste Saved", style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            "${dashboardData!['food_waste_saved_kg'] ?? 0} kg telah diselamatkan",
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  List<PieChartSectionData> _generateSections(dynamic statsData) {
    if (statsData == null || statsData is! List) return [];

    return statsData.map((item) {
      String label = item['_id']?.toString() ?? "Unknown";
      double value = (item['total_weight'] as num?)?.toDouble() ?? 0.0;
      bool isBad = label.toLowerCase().contains('bad');
      
      return PieChartSectionData(
        value: value,
        color: isBad ? Colors.redAccent : Colors.green,
        title: label.toUpperCase(),
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: Colors.white
        ),
      );
    }).toList();
  }
}