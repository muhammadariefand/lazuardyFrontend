// lib/presentation/pages/tutor/konfirmasi_booking_tutor_page.dart
// Image 1, 2 & 5:
// - Tab Pending / Semua
// - Kartu booking: Online (tanpa alamat) & Offline (+ kotak alamat+maps)
// - Tombol Terima (teal) → push Form Link Meeting jika Online, langsung terima jika Offline
// - Tombol Tolak (merah muda) → dialog konfirmasi tolak (Image 5)

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/tutor_buttom_nav.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal   = Color(0xFF3AAFA9);
const _navy   = Color(0xFF1E2D7D);
const _green  = Color(0xFF4CAF50);
const _red    = Color(0xFFE53E3E);
const _orange = Color(0xFFF59E0B);

// ── Status booking ────────────────────────────────────────────────
enum _BookingStatus { pending, diterima, ditolak }
enum _SesiMode       { online, offline }

// ── Model ─────────────────────────────────────────────────────────
class _BookingItem {
  final String id, namaSiswa, inisial, mapel, tanggal, jam, waNumber;
  final _SesiMode mode;
  final _BookingStatus status;
  final String? alamat, mapsLink;

  const _BookingItem({
    required this.id,
    required this.namaSiswa,
    required this.inisial,
    required this.mapel,
    required this.tanggal,
    required this.jam,
    required this.waNumber,
    required this.mode,
    required this.status,
    this.alamat,
    this.mapsLink,
  });

  _BookingItem copyWith({_BookingStatus? status}) => _BookingItem(
    id: id, namaSiswa: namaSiswa, inisial: inisial, mapel: mapel,
    tanggal: tanggal, jam: jam, waNumber: waNumber,
    mode: mode, status: status ?? this.status,
    alamat: alamat, mapsLink: mapsLink,
  );
}

// ── Halaman ───────────────────────────────────────────────────────
class KonfirmasiBookingTutorPage extends StatefulWidget {
  const KonfirmasiBookingTutorPage({super.key});
  @override
  State<KonfirmasiBookingTutorPage> createState() =>
      _KonfirmasiBookingTutorPageState();
}

class _KonfirmasiBookingTutorPageState
    extends State<KonfirmasiBookingTutorPage> {
  bool _showPending = true; // true = tab Pending, false = tab Semua

  // Data dummy — ganti dengan data dari Cubit
  final List<_BookingItem> _allBooking = [
    const _BookingItem(
      id: 'b1', namaSiswa: 'Ahmad', inisial: 'S',
      mapel: 'Matematika', tanggal: '1 April 2026', jam: '14:00 - 15:00',
      waNumber: '081234567890',
      mode: _SesiMode.online, status: _BookingStatus.pending,
    ),
    const _BookingItem(
      id: 'b2', namaSiswa: 'Citra Lestari', inisial: 'C',
      mapel: 'Matematika', tanggal: '1 April 2026', jam: '14:00 - 15:00',
      waNumber: '081234567891',
      mode: _SesiMode.offline, status: _BookingStatus.pending,
      alamat: 'Jl. Melati Indah No. 24, RT 03/RW 05, Kel. Sumberrejo, Kec. Ngaglik, Kab. Sleman, DIY',
      mapsLink: 'https://maps.google.com/?q=Jl.+Melati+Indah+Sleman',
    ),
    const _BookingItem(
      id: 'b3', namaSiswa: 'Ahmad', inisial: 'S',
      mapel: 'Matematika', tanggal: '1 April 2026', jam: '14:00 - 15:00',
      waNumber: '081234567890',
      mode: _SesiMode.online, status: _BookingStatus.pending,
    ),
  ];

  List<_BookingItem> get _displayList => _showPending
      ? _allBooking.where((b) => b.status == _BookingStatus.pending).toList()
      : _allBooking;

  // ── Terima booking ────────────────────────────────────────────
  void _onTerima(_BookingItem item) {
    if (item.mode == _SesiMode.online) {
      // Online → push Form Link Meeting
      Navigator.pushNamed(context, '/tutor/form-link-meeting',
          arguments: {'booking': item});
    } else {
      // Offline → langsung terima
      setState(() {
        final idx = _allBooking.indexWhere((b) => b.id == item.id);
        if (idx != -1) {
          _allBooking[idx] = item.copyWith(status: _BookingStatus.diterima);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking ${item.namaSiswa} diterima'),
          backgroundColor: _green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  // ── Dialog tolak ──────────────────────────────────────────────
  void _showTolakDialog(_BookingItem item) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Icon segitiga merah
            Container(
              width: 68, height: 68,
              decoration: const BoxDecoration(color: Color(0xFFFFEBEE), shape: BoxShape.circle),
              child: const Icon(Icons.warning_rounded, color: _red, size: 38),
            ),
            const SizedBox(height: 20),
            const Text('Tolak Booking?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Text(
              'Booking dari ${item.namaSiswa} akan ditolak dan kuota '
              'akan dikembalikan ke siswa. Tindakan ini tidak bisa dibatalkan',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13,
                  color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Batal',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() {
                    final idx = _allBooking.indexWhere((b) => b.id == item.id);
                    if (idx != -1) {
                      _allBooking[idx] = item.copyWith(status: _BookingStatus.ditolak);
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Booking ${item.namaSiswa} ditolak'),
                      backgroundColor: _red,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Ya, Tolak',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              )),
            ]),
          ]),
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: TutorBottomNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/tutor/beranda');
          if (i == 1) Navigator.pushReplacementNamed(context, '/tutor/jadwal');
          if (i == 3) Navigator.pushReplacementNamed(context, '/tutor/profil');
        },
      ),
      body: Column(children: [
        // ── Teal Header ──────────────────────────────────────────
        Container(
          color: _teal,
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Konfirmasi Booking',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        ),

        // ── Body ─────────────────────────────────────────────────
        Expanded(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 16),
            const Text('Terima atau tolak permintaan booking siswa',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 14),

            // ── Tab Pending / Semua ──────────────────────────────
            _buildTabSelector(),
            const SizedBox(height: 16),

            // ── List booking ─────────────────────────────────────
            ..._displayList.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _BookingCard(
                item: item,
                onTerima: () => _onTerima(item),
                onTolak:  () => _showTolakDialog(item),
                onOpenMaps: item.mapsLink != null
                    ? () => _openUrl(item.mapsLink!)
                    : null,
                onWA: () => _openUrl('https://wa.me/${item.waNumber}'),
              ),
            )),

            if (_displayList.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: Text('Tidak ada booking',
                    style: TextStyle(fontSize: 14,
                        color: AppColors.textSecondary))),
              ),

            const SizedBox(height: 24),
          ]),
        )),
      ]),
    );
  }

  // ── Tab selector ──────────────────────────────────────────────
  Widget _buildTabSelector() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(children: [
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _showPending = true),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: _showPending ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(26),
              boxShadow: _showPending
                  ? [BoxShadow(color: Colors.black.withOpacity(0.07),
                      blurRadius: 6)]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text('Pending',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: _showPending
                        ? FontWeight.w700 : FontWeight.w400,
                    color: _showPending
                        ? AppColors.textPrimary
                        : AppColors.textSecondary)),
          ),
        )),
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _showPending = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: !_showPending ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(26),
              boxShadow: !_showPending
                  ? [BoxShadow(color: Colors.black.withOpacity(0.07),
                      blurRadius: 6)]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text('Semua',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: !_showPending
                        ? FontWeight.w700 : FontWeight.w400,
                    color: !_showPending
                        ? AppColors.textPrimary
                        : AppColors.textSecondary)),
          ),
        )),
      ]),
    );
  }
}

// ── Kartu Booking ─────────────────────────────────────────────────
class _BookingCard extends StatelessWidget {
  final _BookingItem item;
  final VoidCallback onTerima, onTolak, onWA;
  final VoidCallback? onOpenMaps;

  const _BookingCard({
    required this.item,
    required this.onTerima,
    required this.onTolak,
    required this.onWA,
    this.onOpenMaps,
  });

  bool get _isOffline => item.mode == _SesiMode.offline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3AAFA9).withOpacity(0.4), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Row 1: Avatar + Info + Badge Pending ─────────────────
        Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(item.inisial,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                    color: _navy)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.namaSiswa,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text('${item.mapel} · ${item.tanggal}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ])),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _orange.withOpacity(0.3)),
            ),
            child: const Text('Pending',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _orange)),
          ),
        ]),

        const SizedBox(height: 10),

        // ── Row 2: Jam + Mode + WA ─────────────────────────────
        Row(children: [
          const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Text(item.jam, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
          const SizedBox(width: 10),
          // Mode badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: _isOffline ? _red.withOpacity(0.08) : _green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isOffline ? _red.withOpacity(0.3) : _green.withOpacity(0.3)),
            ),
            child: Text(_isOffline ? 'Offline' : 'Online',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                    color: _isOffline ? _red : _green)),
          ),
          const SizedBox(width: 8),
          // WA badge
          GestureDetector(
            onTap: onWA,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  borderRadius: BorderRadius.circular(20)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.chat_rounded, size: 12, color: Colors.white),
                SizedBox(width: 4),
                Text('WhatsApp',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ]),
            ),
          ),
        ]),

        // ── Kotak alamat (hanya Offline) ──────────────────────────
        if (_isOffline && item.alamat != null) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.location_on_outlined, size: 15, color: AppColors.textSecondary),
                SizedBox(width: 5),
                Text('Alamat Lokasi sesi',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ]),
              const SizedBox(height: 5),
              Text(item.alamat!,
                  style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4)),
              if (onOpenMaps != null) ...[
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onOpenMaps,
                  child: const Row(children: [
                    Icon(Icons.open_in_new_rounded, size: 13, color: _teal),
                    SizedBox(width: 4),
                    Text('Buka di Google Maps',
                        style: TextStyle(fontSize: 12, color: _teal,
                            fontWeight: FontWeight.w500)),
                  ]),
                ),
              ],
            ]),
          ),
        ],

        const SizedBox(height: 14),

        // ── Tombol Terima + Tolak ──────────────────────────────
        Row(children: [
          Expanded(child: SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onTerima,
              icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
              label: const Text('Terima',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          )),
          const SizedBox(width: 10),
          Expanded(child: SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onTolak,
              icon: Icon(Icons.cancel_outlined, size: 18, color: _red),
              label: Text('Tolak',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: _red)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _red.withOpacity(0.1),
                foregroundColor: _red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          )),
        ]),
      ]),
    );
  }
}