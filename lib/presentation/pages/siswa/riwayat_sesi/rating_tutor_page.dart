// lib/presentation/pages/siswa/rating_tutor_page.dart
// Form rating + textarea ulasan → submit via RiwayatSesiCubit
// Setelah berhasil: dialog sukses; jika gagal: dialog error

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import '../../../state_management/riwayat_sesi/riwayat_sesi_cubit.dart';
import '../../../state_management/riwayat_sesi/riwayat_sesi_state.dart';

const _teal = Color(0xFF3AAFA9);
const _navy = Color(0xFF1E2D7D);
const _starYellow = Color(0xFFFFB800);
const _green = Color(0xFF4CAF50);

class RatingTutorPage extends StatefulWidget {
  const RatingTutorPage({super.key});

  @override
  State<RatingTutorPage> createState() => _RatingTutorPageState();
}

class _RatingTutorPageState extends State<RatingTutorPage> {
  int _selectedStar = 0; // 0 = belum dipilih, 1-5
  int _hoveredStar = 0; // untuk efek hover
  final _ulasanCtrl = TextEditingController();
  static const _maxChar = 500;

  // Args dari route
  int? _tutorId;
  String _tutorNama = '';
  String _tutorInisial = '';
  String _mapel = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    _tutorId = args['tutor_id'] as int?;
    _tutorNama = args['tutor_nama'] as String? ?? '';
    _tutorInisial = args['tutor_inisial'] as String? ?? '';
    _mapel = args['mapel'] as String? ?? '';
  }

  @override
  void dispose() {
    _ulasanCtrl.dispose();
    super.dispose();
  }

  void _onKirimRating() {
    if (_selectedStar == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih rating bintang terlebih dahulu'),
          backgroundColor: Color(0xFFE53E3E),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    if (_tutorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data tutor tidak valid'),
          backgroundColor: Color(0xFFE53E3E),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    context.read<RiwayatSesiCubit>().submitReview(
          tutorId: _tutorId!,
          rate: _selectedStar.toDouble(),
          comment: _ulasanCtrl.text.trim(),
        );
  }

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
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _green, width: 2.5),
              ),
              child: const Icon(Icons.check_rounded, color: _green, size: 38),
            ),
            const SizedBox(height: 20),

            const Text('Terima Kasih!',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            const Text(
              'Rating Anda membantu tutor\ndan siswa lainnya.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // tutup dialog
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/siswa/riwayat-sesi', (_) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Kembali ke Riwayat Sesi',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE53E3E), width: 2.5),
              ),
              child: const Icon(Icons.close_rounded,
                  color: Color(0xFFE53E3E), size: 38),
            ),
            const SizedBox(height: 20),

            const Text('Gagal Mengirim',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53E3E),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Tutup',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final charCount = _ulasanCtrl.text.length;

    return BlocListener<RiwayatSesiCubit, RiwayatSesiState>(
      listener: (context, state) {
        if (state is SubmitReviewSuccess) {
          _showSuccessDialog();
        }
        if (state is RiwayatSesiError) {
          _showErrorDialog(state.message);
        }
      },
      child: BlocBuilder<RiwayatSesiCubit, RiwayatSesiState>(
        builder: (context, state) {
          final isLoading = state is SubmitReviewLoading;

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
              title: const Text(
                'Rating Tutor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onKirimRating,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : const Text('Kirim Rating',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                const SizedBox(height: 8),

                // ── Kartu tutor (center) ────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _teal.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8)
                    ],
                  ),
                  child: Column(children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _tutorInisial.isNotEmpty ? _tutorInisial : '?',
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: _navy),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _tutorNama.isNotEmpty ? _tutorNama : 'Tutor',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _mapel.isNotEmpty ? _mapel : '',
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ]),
                ),

                const SizedBox(height: 24),

                // ── Pertanyaan rating ───────────────────────────────
                const Text(
                  'Bagaimana pengalaman belajar Anda?',
                  style: TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                ),

                const SizedBox(height: 16),

                // ── Bintang interaktif 5 ────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final starIndex = i + 1;
                    final isFilled = starIndex <=
                        (_hoveredStar > 0 ? _hoveredStar : _selectedStar);
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedStar = starIndex),
                      child: MouseRegion(
                        onEnter: (_) =>
                            setState(() => _hoveredStar = starIndex),
                        onExit: (_) =>
                            setState(() => _hoveredStar = 0),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 6),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            child: Icon(
                              isFilled
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              key: ValueKey('$starIndex-$isFilled'),
                              size: 44,
                              color: isFilled
                                  ? _starYellow
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                // Label rating
                if (_selectedStar > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    _ratingLabel(_selectedStar),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _starYellow),
                  ),
                ],

                const SizedBox(height: 24),

                // ── Textarea ulasan ─────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text('Ulasan',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _ulasanCtrl,
                  maxLines: 7,
                  maxLength: _maxChar,
                  buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                      null,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Ceritakan pengalaman belajar Anda...',
                    hintStyle: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: _teal.withOpacity(0.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: _teal, width: 1.5),
                    ),
                  ),
                ),
                // Character counter
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '$charCount/$_maxChar',
                      style: TextStyle(
                        fontSize: 12,
                        color: charCount >= _maxChar * 0.9
                            ? const Color(0xFFE53E3E)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ]),
            ),
          );
        },
      ),
    );
  }

  String _ratingLabel(int star) {
    switch (star) {
      case 1:
        return 'Sangat Buruk';
      case 2:
        return 'Kurang Memuaskan';
      case 3:
        return 'Cukup';
      case 4:
        return 'Bagus';
      case 5:
        return 'Luar Biasa!';
      default:
        return '';
    }
  }
}