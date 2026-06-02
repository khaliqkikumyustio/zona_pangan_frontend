import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/core/network/api_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final auth = context.read<AuthProvider>();
    final company = auth.companyName;

    if (company == null || company.isEmpty) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      // ApiService kini sudah menggunakan /api/logs
      final data = await ApiService().getLogs(company);
      if (mounted) {
        setState(() {
          logs = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error load logs: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _exportToCSV() {
    if (logs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada data untuk di-export")),
      );
      return;
    }

    List<List<dynamic>> csvData = [
      ["Waktu", "Operator", "Prediksi", "Berat (kg)", "Status"],
      ...logs.map((log) => [
            log['timestamp'] ?? 'N/A',
            log['username'] ?? 'Unknown',
            log['prediction'] ?? 'Unknown',
            log['weight'] ?? 0,
            log['status'] ?? 'pending'
          ])
    ];
    
    String csv = const ListToCsvConverter().convert(csvData);
    debugPrint(csv); 
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data berhasil di-export ke konsol!"), 
        backgroundColor: Colors.orange
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Audit", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFF8C42),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.file_download), onPressed: _exportToCSV),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF8C42)))
          : logs.isEmpty
              ? const Center(child: Text("Belum ada riwayat audit"))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: logs.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange[100],
                        child: const Icon(Icons.history, color: Color(0xFFFF8C42)),
                      ),
                      title: Text(
                        "Operator: ${log['username'] ?? 'Unknown'}", 
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                      subtitle: Text(
                        "Prediksi: ${log['prediction'] ?? 'N/A'} | ${log['weight'] ?? 0} kg\nWaktu: ${log['timestamp'] ?? 'N/A'}"
                      ),
                      isThreeLine: true,
                    );
                  },
                ),
    );
  }
}