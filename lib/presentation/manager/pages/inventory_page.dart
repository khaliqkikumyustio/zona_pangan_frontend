import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/core/network/api_service.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<dynamic> inventoryData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    final auth = context.read<AuthProvider>();
    final company = auth.companyName;

    // Jika company kosong, hentikan proses
    if (company == null || company.isEmpty) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      // ApiService kini memanggil /api/inventory secara otomatis
      final data = await ApiService().getInventory(company);
      if (mounted) {
        setState(() {
          inventoryData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error load inventory: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventaris (FIFO)", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFF8C42),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF8C42)))
          : inventoryData.isEmpty
              ? const Center(child: Text("Tidak ada data inventaris"))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: inventoryData.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = inventoryData[index];
                    
                    // Mengakses 'alert' yang dikirim dari backend dashboard.py
                    bool isBad = item['alert'] == true;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      title: Text(
                        item['prediction'] ?? 'Unknown',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Masuk: ${item['date'] ?? 'N/A'}"),
                      trailing: Chip(
                        label: Text(isBad ? "Kompos" : "Ready"),
                        backgroundColor: isBad ? Colors.redAccent : Colors.green,
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    );
                  },
                ),
    );
  }
}