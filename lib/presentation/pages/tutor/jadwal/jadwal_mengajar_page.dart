// lib/presentation/pages/tutor/jadwal_mengajar_page.dart
// Jadwal Mengajar
// - Week picker dengan navigasi bulan
// - "Sesi Hari Ini" section
// - Kartu sesi per siswa:
//   * Offline: avatar, nama, mapel·tanggal, jam, WA, kotak alamat+Google Maps
//   * Online:  avatar, nama, mapel·tanggal, jam, WA, kotak Link Meeting (link teal)
// - Empty state: icon kalender + teks "Belum ada sesi mengajar hari ini"

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/tutor_buttom_nav.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal  = Color(0xFF3AAFA9);
const _navy  = Color(0xFF1E2D7D);
const _green = Color(0xFF4CAF50);
const _red   = Color(0xFFE53E3E);

// ── Model ─────────────────────────────────────────────────────────
enum _SesiMode { online, offline }

class _SesiItem {
  final String namaSiswa, inisial, mapel, tanggal, jam;
  final _SesiMode mode;
  final String? alamat, mapsLink, meetLink, waNumber;
  const _SesiItem({
    required this.namaSiswa,
    required this.inisial,
    required this.mapel,
    required this.tanggal,
    required this.jam,
    required this.mode,
    this.alamat,
    this.mapsLink,
    this.meetLink,
    this.waNumber,
  });
}

// ── Data dummy — sesi per hari (key: "dd-MM-yyyy") ────────────────
const _sesiPerHari = {
  '1-4-2026': [
    _SesiItem(
      namaSiswa: 'Budi', inisial: 'B',
      mapel: 'Matematika', tanggal: '1 April 2026', jam: '08:00 - 09:00',
      mode: _SesiMode.offline,
      alamat: 'Jl. Melati Indah No. 24, RT 03/RW 05, Kel. Sumberrejo, Kec. Ngaglik, Kab. Sleman, DIY',
      mapsLink: 'https://maps.google.com/?q=Jl.+Melati+Indah+Sleman',
      waNumber: '081234567890',
    ),
    _SesiItem(
      namaSiswa: 'Ahmad', inisial: 'A',
      mapel: 'Matematika', tanggal: '1 April 2026', jam: '10:00 - 11:00',
      mode: _SesiMode.online,
      meetLink: 'https://meet.google.com/abc-defg-hij',
      waNumber: '081234567891',
    ),
    _SesiItem(
      namaSiswa: 'Citra', inisial: 'C',
      mapel: 'Matematika', tanggal: '1 April 2026', jam: '13:00 - 14:00',
      mode: _SesiMode.online,
      meetLink: 'https://meet.google.com/xyz-uvwx-yz1',
      waNumber: '081234567892',
    ),
  ],
};

class JadwalMengajarPage extends StatefulWidget {
  const JadwalMengajarPage({super.key});
  @override
  State<JadwalMengajarPage> createState() => _JadwalMengajarPageState();
}

class _JadwalMengajarPageState extends State<JadwalMengajarPage> {
  DateTime _selectedDate = DateTime(2026, 4, 1);
  DateTime _weekStart   = DateTime(2026, 3, 30);

  static const _hariSingkat = ['Sen','Sel','Rab','Kam','Jum','Sab','Min'];
  static const _bulanNama   = [
    '','Januari','Februari','Maret','April','Mei','Juni',
    'Juli','Agustus','September','Oktober','November','Desember',
  ];

  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _weekStart.add(Duration(days: i)));

  String _key(DateTime d) => '${d.day}-${d.month}-${d.year}';

  List<_SesiItem> get _todaySesi =>
      _sesiPerHari[_key(_selectedDate)] ?? [];

  // ── Actions ───────────────────────────────────────────────────
  Future<void> _openWA(String number) async {
    final uri = Uri.parse('https://wa.me/$number');
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: TutorBottomNav(
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/tutor/beranda');
          if (i == 2) Navigator.pushReplacementNamed(context, '/tutor/konfirmasi-booking');
          if (i == 3) Navigator.pushReplacementNamed(context, '/tutor/profil');
        },
      ),
      body: Column(children: [
        // ── Teal Header ─────────────────────────────────────────
        Container(
          color: _teal,
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Jadwal Mengajar',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ),

        // ── Body ─────────────────────────────────────────────────
        Expanded(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 20),
            _buildWeekPicker(),
            const SizedBox(height: 24),
            const Text('Sesi Hari Ini',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 14),
            _todaySesi.isEmpty
                ? _buildEmptyState()
                : Column(
                    children: _todaySesi.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _SesiCard(sesi: s,
                          onWA: () => s.waNumber != null ? _openWA(s.waNumber!) : null,
                          onOpenLink: (url) => _openUrl(url)),
                    )).toList(),
                  ),
            const SizedBox(height: 32),
          ]),
        )),
      ]),
    );
  }

  // ── Week Picker ───────────────────────────────────────────────
  Widget _buildWeekPicker() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => setState(() =>
                _weekStart = _weekStart.subtract(const Duration(days: 7))),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_left_rounded,
                  color: AppColors.textPrimary),
            ),
          ),
          Text(_bulanNama[_selectedDate.month],
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          GestureDetector(
            onTap: () => setState(() =>
                _weekStart = _weekStart.add(const Duration(days: 7))),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _weekDays.asMap().entries.map((e) {
          final day = e.value;
          final isSelected = day.day == _selectedDate.day &&
              day.month == _selectedDate.month;
          return GestureDetector(
            onTap: () => setState(() {
              _selectedDate = day;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 44, height: 62,
              decoration: BoxDecoration(
                color: isSelected ? _teal : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? _teal : _teal.withOpacity(0.4),
                  width: isSelected ? 1.5 : 1.2,
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(_hariSingkat[e.key],
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textSecondary)),
                const SizedBox(height: 3),
                Text('${day.day}',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.textPrimary)),
              ]),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  // ── Empty state ───────────────────────────────────────────────
  Widget _buildEmptyState() {
    return SizedBox(
      height: 300,
      child: Center(child: Column(
          mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.calendar_month_rounded,
            size: 56, color: Colors.grey.shade300),
        const SizedBox(height: 14),
        Text('Belum ada sesi mengajar hari ini',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
      ])),
    );
  }
}

// ── Kartu sesi ────────────────────────────────────────────────────
class _SesiCard extends StatelessWidget {
  final _SesiItem sesi;
  final VoidCallback? onWA;
  final void Function(String url) onOpenLink;

  const _SesiCard({
    required this.sesi,
    required this.onWA,
    required this.onOpenLink,
  });

  @override
  Widget build(BuildContext context) {
    final isOffline = sesi.mode == _SesiMode.offline;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _teal.withOpacity(0.4), width: 1.2),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Row 1: Avatar + Info + Badge ────────────────────────
        Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(sesi.inisial,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700, color: _navy)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(sesi.namaSiswa,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text('${sesi.mapel} · ${sesi.tanggal}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          ])),
          // Badge mode
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: isOffline
                  ? _red.withOpacity(0.1)
                  : _green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isOffline
                    ? _red.withOpacity(0.3)
                    : _green.withOpacity(0.3),
              ),
            ),
            child: Text(
              isOffline ? 'Offline' : 'Online',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isOffline ? _red : _green),
            ),
          ),
        ]),

        const SizedBox(height: 12),

        // ── Row 2: Jam + WhatsApp ────────────────────────────────
        Row(children: [
          const Icon(Icons.access_time_rounded,
              size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(sesi.jam,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textPrimary)),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onWA,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.chat_rounded, size: 12, color: Colors.white),
                SizedBox(width: 4),
                Text('WhatsApp',
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ]),
            ),
          ),
        ]),

        const SizedBox(height: 10),

        // ── Kotak Info (Alamat atau Link Meeting) ─────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: isOffline
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    const Text('Alamat Lokasi sesi',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ]),
                  const SizedBox(height: 4),
                  Text(sesi.alamat ?? '',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textPrimary,
                          height: 1.4)),
                  const SizedBox(height: 6),
                  if (sesi.mapsLink != null)
                    GestureDetector(
                      onTap: () => onOpenLink(sesi.mapsLink!),
                      child: const Row(children: [
                        Icon(Icons.open_in_new_rounded,
                            size: 13, color: _teal),
                        SizedBox(width: 4),
                        Text('Buka di Google Maps',
                            style: TextStyle(
                                fontSize: 12, color: _teal,
                                fontWeight: FontWeight.w500)),
                      ]),
                    ),
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.videocam_outlined,
                        size: 15, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    const Text('Link Meeting',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ]),
                  const SizedBox(height: 4),
                  if (sesi.meetLink != null)
                    GestureDetector(
                      onTap: () => onOpenLink(sesi.meetLink!),
                      child: Text(sesi.meetLink!,
                          style: const TextStyle(
                              fontSize: 12, color: _teal,
                              fontWeight: FontWeight.w500)),
                    ),
                ]),
        ),
      ]),
    );
  }
}