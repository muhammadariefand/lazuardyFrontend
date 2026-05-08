// lib/presentation/pages/tutor/edit_profil_tutor_page.dart
// Edit Profil Tutor
// Perbedaan vs Edit Profil Siswa:
//   + Dropdown "Pilih Bank" dan input "Nomor Rekening"
//   - Tidak ada field "Kelas" dan "Kontak Orang Tua"
// Image 3: Dialog sukses "Edit Profil Berhasil!" → Kembali ke Profil

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal  = Color(0xFF3AAFA9);
const _navy  = Color(0xFF1E2D7D);
const _green = Color(0xFF4CAF50);

class EditProfilTutorPage extends StatefulWidget {
  const EditProfilTutorPage({super.key});
  @override
  State<EditProfilTutorPage> createState() => _EditProfilTutorPageState();
}

class _EditProfilTutorPageState extends State<EditProfilTutorPage> {
  // ── Controllers ────────────────────────────────────────────────
  final _namaCtrl      = TextEditingController(text: 'Mardhika Murni Pramestika');
  final _waCtrl        = TextEditingController(text: '089505086860');
  final _tglLahirCtrl  = TextEditingController(text: '20/08/2005');
  final _rekeningCtrl  = TextEditingController(text: '1234567890');

  // ── Dropdown values ────────────────────────────────────────────
  String? _jenisKelamin = 'Perempuan';
  String? _bank         = 'Mandiri';
  String? _provinsi     = 'DI Yogyakarta';
  String? _kota         = 'Kab. Sleman';
  String? _kecamatan    = 'Depok';
  String? _desa         = 'Caturtunggal';

  bool _isLoading = false;

  // ── Lists ──────────────────────────────────────────────────────
  static const _jkList      = ['Laki-laki', 'Perempuan'];
  static const _bankList    = ['BCA', 'BRI', 'BNI', 'BSI', 'Mandiri', 'CIMB', 'Danamon'];
  static const _provinsiList = ['DI Yogyakarta', 'DKI Jakarta', 'Jawa Barat', 'Jawa Tengah', 'Jawa Timur'];
  static const _kotaMap     = {
    'DI Yogyakarta': ['Kota Yogyakarta', 'Kab. Sleman', 'Bantul', 'Kulon Progo', 'Gunungkidul'],
  };
  static const _kecamatanMap = {
    'Kab. Sleman': ['Depok', 'Mlati', 'Gamping', 'Godean'],
  };
  static const _desaMap = {
    'Depok': ['Catur Tunggal', 'Condong Catur', 'Maguwoharjo', 'Caturtunggal'],
  };

  @override
  void dispose() {
    _namaCtrl.dispose();
    _waCtrl.dispose();
    _tglLahirCtrl.dispose();
    _rekeningCtrl.dispose();
    super.dispose();
  }

  // ── Pilih tanggal ──────────────────────────────────────────────
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 8, 20),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _teal)),
        child: child!,
      ),
    );
    if (picked != null) {
      _tglLahirCtrl.text =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
    }
  }

  // ── Simpan ─────────────────────────────────────────────────────
  void _onSimpan() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // TODO: panggil UseCase
    if (mounted) {
      setState(() => _isLoading = false);
      _showSuccessDialog();
    }
  }

  // ── Dialog sukses (Image 3) ────────────────────────────────────
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Icon centang hijau
            Container(
              width: 68, height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _green, width: 2.5),
              ),
              child: const Icon(Icons.check_rounded, color: _green, size: 38),
            ),
            const SizedBox(height: 20),
            const Text('Edit Profil Berhasil!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            const Text('Profil Berhasil Diperbarui!',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            const Text('Perubahan data profil Anda telah berhasil disimpan',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13,
                    color: AppColors.textSecondary, height: 1.4)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // tutup dialog
                  Navigator.pushReplacementNamed(context, '/tutor/profil');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Kembali ke Profil',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profil',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),

      // ── Sticky bottom: Batal + Simpan ──────────────────────────
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Row(children: [
          Expanded(child: SizedBox(height: 52, child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Batal',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ))),
          const SizedBox(width: 12),
          Expanded(child: SizedBox(height: 52, child: ElevatedButton(
            onPressed: _isLoading ? null : _onSimpan,
            style: ElevatedButton.styleFrom(
              backgroundColor: _teal,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(width: 22, height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5))
                : const Text('Simpan',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
          ))),
        ]),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const SizedBox(height: 8),

          // ── Avatar + camera icon ─────────────────────────────
          Stack(alignment: Alignment.bottomRight, children: [
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(
                  color: Color(0xFFB2EBF2), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Text('M',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700,
                      color: _navy)),
            ),
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: _teal,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.camera_alt_rounded,
                  size: 14, color: Colors.white),
            ),
          ]),

          const SizedBox(height: 20),

          // ── Detail Pribadi ──────────────────────────────────
          _buildCard('Detail Pribadi', [
            _field('Nama Lengkap', _namaCtrl),
            _dropdown('Jenis Kelamin', _jenisKelamin, _jkList,
                (v) => setState(() => _jenisKelamin = v)),
            _datePicker('Tanggal Lahir'),
            _phoneField('Nomor WhatsApp', _waCtrl),
            _dropdown('Pilih Bank', _bank, _bankList,
                (v) => setState(() => _bank = v)),
            _numberField('Nomor Rekening', _rekeningCtrl),
          ]),

          const SizedBox(height: 16),

          // ── Detail Alamat ───────────────────────────────────
          _buildCard('Detail Alamat', [
            _dropdown('Provinsi', _provinsi, _provinsiList, (v) => setState(() {
              _provinsi = v; _kota = null; _kecamatan = null; _desa = null;
            })),
            _dropdown('Kota/Kabupaten', _kota, _kotaMap[_provinsi] ?? [], (v) => setState(() {
              _kota = v; _kecamatan = null; _desa = null;
            })),
            _dropdown('Kecamatan', _kecamatan, _kecamatanMap[_kota] ?? [], (v) => setState(() {
              _kecamatan = v; _desa = null;
            })),
            _dropdown('Desa/Kelurahan', _desa, _desaMap[_kecamatan] ?? [],
                (v) => setState(() => _desa = v)),
          ]),

          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  // ── Card wrapper ──────────────────────────────────────────────
  Widget _buildCard(String title, List<Widget> fields) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _teal.withOpacity(0.4)),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 14),
        ...fields,
      ]),
    );
  }

  // ── Helper: label ──────────────────────────────────────────────
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
  );

  // ── Helper: base InputDecoration ──────────────────────────────
  InputDecoration _inputDeco({String? hint, Widget? prefix, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      prefixIcon: prefix,
      suffixIcon: suffix,
      filled: true, fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _teal, width: 1.5)),
    );
  }

  // ── Text field biasa ──────────────────────────────────────────
  Widget _field(String label, TextEditingController ctrl, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label),
        TextFormField(
          controller: ctrl,
          decoration: _inputDeco(hint: hint ?? label),
        ),
      ]),
    );
  }

  // ── Phone field ───────────────────────────────────────────────
  Widget _phoneField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label),
        TextFormField(
          controller: ctrl,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: _inputDeco(
            prefix: const Icon(Icons.phone_outlined,
                color: AppColors.textSecondary, size: 18)),
        ),
      ]),
    );
  }

  // ── Number field (rekening) ───────────────────────────────────
  Widget _numberField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label),
        TextFormField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: _inputDeco(hint: 'Masukkan nomor rekening'),
        ),
      ]),
    );
  }

  // ── Date picker field ─────────────────────────────────────────
  Widget _datePicker(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label),
        TextFormField(
          controller: _tglLahirCtrl,
          readOnly: true,
          onTap: _pickDate,
          decoration: _inputDeco(
            prefix: const Icon(Icons.calendar_today_outlined,
                color: AppColors.textSecondary, size: 18)),
        ),
      ]),
    );
  }

  // ── Dropdown ─────────────────────────────────────────────────
  Widget _dropdown(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
    final enabled = items.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label),
        Opacity(
          opacity: enabled ? 1.0 : 0.45,
          child: DropdownButtonFormField<String>(
            value: (value != null && items.contains(value)) ? value : null,
            onChanged: enabled ? onChanged : null,
            decoration: _inputDeco(hint: 'Pilih $label'),
            icon: const Icon(Icons.keyboard_arrow_up_rounded,
                color: AppColors.textSecondary),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            isExpanded: true,
            items: items.map((e) => DropdownMenuItem(
              value: e,
              child: Text(e,
                  style: const TextStyle(fontSize: 13)),
            )).toList(),
          ),
        ),
      ]),
    );
  }
}