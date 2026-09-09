import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PortfolioContent extends StatelessWidget {
  const PortfolioContent({super.key});

  Future<Map<String, dynamic>> _veriyiYukle() async {
    final String response = await rootBundle.loadString('assets//data/data.json');
    return jsonDecode(response);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _veriyiYukle(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text('Veri yüklenirken hata oluştu.');
        }

        final data = snapshot.data!;
        final List deneyimler = data['deneyimler'] ?? [];
        final List yetenekler = data['yetenekler'] ?? [];

        return SizedBox(
          width: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Abouth
              const Text(
                'Hakkımda',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 6),
              Text(
                data['hakkimda'] ?? '',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.4),
              ),
              const Divider(height: 28),

              // skills 
              const Text(
                'Yetenekler',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: yetenekler
                    .map((item) => Chip(
                          label: Text(item, style: const TextStyle(fontSize: 12)),
                          backgroundColor: Colors.indigo.shade50,
                          side: BorderSide(color: Colors.indigo.shade100),
                        ))
                    .toList(),
              ),
              const Divider(height: 28),

              // Experience
              const Text(
                'Deneyimler',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 8),
              ...deneyimler.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.work_outline, size: 18, color: Colors.indigo),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item['pozisyon']} - ${item['sirket']}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                item['donem'],
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['aciklama'],
                                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}