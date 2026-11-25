import 'package:flutter/material.dart';

class KontakScreen extends StatefulWidget {
  const KontakScreen({super.key});

  @override
  State<KontakScreen> createState() => _KontakScreenState();
}

class _KontakScreenState extends State<KontakScreen> {
  String _searchQuery = '';

  final List<Map<String, String>> _contacts = [
    {
      'nama': 'Reza Firmansyah',
      'jabatan': 'Head Sound Engineer',
      'telepon': '0812-3456-7890',
      'spesialis': 'Recording & Mixing',
    },
    {
      'nama': 'Dinda Aulia',
      'jabatan': 'Studio Manager',
      'telepon': '0813-5678-9012',
      'spesialis': 'Administrasi & Booking',
    },
    {
      'nama': 'Bagas Prasetyo',
      'jabatan': 'Guitar Technician',
      'telepon': '0857-1234-5678',
      'spesialis': 'Setup & Repair Gitar',
    },
    {
      'nama': 'Fitri Handayani',
      'jabatan': 'Drum Technician',
      'telepon': '0821-8765-4321',
      'spesialis': 'Tuning & Drum Setup',
    },
    {
      'nama': 'Andi Kurniawan',
      'jabatan': 'Keyboard Tech',
      'telepon': '0878-2345-6789',
      'spesialis': 'Piano & Synth Setup',
    },
    {
      'nama': 'Sari Wulandari',
      'jabatan': 'Vocal Coach',
      'telepon': '0856-3456-7890',
      'spesialis': 'Vocal Training & Recording',
    },
    {
      'nama': 'Hendra Gunawan',
      'jabatan': 'Bass Technician',
      'telepon': '0831-4567-8901',
      'spesialis': 'Bass Amp & Setup',
    },
    {
      'nama': 'Mega Rahmawati',
      'jabatan': 'Admin Studio',
      'telepon': '0819-5678-9012',
      'spesialis': 'Kasir & Layanan Member',
    },
    {
      'nama': 'Yusuf Hidayat',
      'jabatan': 'Lighting Technician',
      'telepon': '0845-6789-0123',
      'spesialis': 'Stage & Studio Lighting',
    },
    {
      'nama': 'Nina Cahyani',
      'jabatan': 'Mixing Engineer',
      'telepon': '0867-7890-1234',
      'spesialis': 'Post-Production & Mastering',
    },
    {
      'nama': 'Budi Santoso',
      'jabatan': 'Security & Ops',
      'telepon': '0853-8901-2345',
      'spesialis': 'Keamanan & Operasional',
    },
    {
      'nama': 'Lestari Puspita',
      'jabatan': 'Marketing',
      'telepon': '0881-9012-3456',
      'spesialis': 'Promosi & Media Sosial',
    },
    {
      'nama': 'Fajar Nugraha',
      'jabatan': 'IT Support',
      'telepon': '0896-0123-4567',
      'spesialis': 'DAW & Software Support',
    },
    {
      'nama': 'Dewi Kartika',
      'jabatan': 'Receptionist',
      'telepon': '0877-1234-5678',
      'spesialis': 'Penerima Tamu & Info',
    },
    {
      'nama': 'Rizky Maulana',
      'jabatan': 'Owner / Direktur',
      'telepon': '0811-2345-6789',
      'spesialis': 'Manajemen Studio',
    },
  ];

  List<Map<String, String>> get _filtered {
    if (_searchQuery.isEmpty) return _contacts;
    return _contacts
        .where((c) =>
            c['nama']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c['jabatan']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Color _avatarColor(int index) {
    final colors = [
      const Color(0xFFFFC107),
      const Color(0xFF7C4DFF),
      const Color(0xFF00BCD4),
      const Color(0xFF4CAF50),
      const Color(0xFFE91E63),
      const Color(0xFFFF5722),
    ];
    return colors[index % colors.length];
  }

  void _showCallDialog(String nama, String telepon, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              type == 'call' ? Icons.call : Icons.message,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              type == 'call'
                  ? 'Memanggil $nama ($telepon)...'
                  : 'Membuka pesan ke $nama...',
            ),
          ],
        ),
        backgroundColor:
            type == 'call' ? const Color(0xFF4CAF50) : const Color(0xFF7C4DFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contacts = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: const Text(
          'Kontak Kru & Teknisi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              '${contacts.length} Kontak',
              style: const TextStyle(
                color: Color(0xFFFFC107),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari kontak...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFFC107)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                filled: true,
                fillColor: const Color(0xFF1E1E32),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: contacts.length,
        itemBuilder: (_, i) {
          final c = contacts[i];
          final initials = c['nama']!
              .split(' ')
              .take(2)
              .map((w) => w[0].toUpperCase())
              .join();
          final color = _avatarColor(i);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E32),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.15),
                      border: Border.all(color: color, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c['nama']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          c['jabatan']!,
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          c['telepon']!,
                          style: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '🎚️ ${c['spesialis']}',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Column(
                    children: [
                      _actionBtn(
                        Icons.call,
                        const Color(0xFF4CAF50),
                        () => _showCallDialog(c['nama']!, c['telepon']!, 'call'),
                      ),
                      const SizedBox(height: 6),
                      _actionBtn(
                        Icons.message,
                        const Color(0xFF7C4DFF),
                        () => _showCallDialog(c['nama']!, c['telepon']!, 'msg'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
