import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/package/package_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/package/package_state.dart';
import 'package:lazuadry_mobile_fe/domain/entities/package_entity.dart';

const _priceRed = AppColors.errorRed;

class BeliPaketPage extends StatefulWidget {
  const BeliPaketPage({super.key});
  @override
  State<BeliPaketPage> createState() => _BeliPaketPageState();
}

class _BeliPaketPageState extends State<BeliPaketPage> {
  PackageEntity? _selectedPackage;

  @override
  void initState() {
    super.initState();
    // Panggil fetchPackages() saat halaman dimuat
    context.read<PackageCubit>().fetchPackages();
  }

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  void _onLanjutkan() {
    if (_selectedPackage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih paket terlebih dahulu'),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ));
      return;
    }

    // Kirim order ke backend
    context.read<PackageCubit>().orderPackages([
      {'id': _selectedPackage!.id, 'quantity': 1},
    ]);
  }

  Future<void> _openCheckoutUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tidak dapat membuka halaman pembayaran'),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PackageCubit, PackageState>(
      listener: (context, state) {
        if (state is PackageOrderSuccess) {
          // Buka checkout URL di browser eksternal
          _openCheckoutUrl(state.checkoutUrl);

          // Navigasi ke halaman pembayaran berhasil
          Navigator.pushNamed(
            context,
            '/siswa/pembayaran-berhasil',
            arguments: {
              'orderId': state.orderId,
              'paketNama': _selectedPackage?.name ?? 'Paket',
              'jumlahSesi': _selectedPackage?.session ?? 0,
            },
          );
        } else if (state is PackageOrderError) {
          // Bersihkan prefix ServerException dari pesan error
          var errorMsg = state.message;
          if (errorMsg.contains('ServerException:')) {
            errorMsg = errorMsg.replaceAll(RegExp(r'.*ServerException:\s*'), '');
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              errorMsg,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ));

          // Re-fetch packages agar UI kembali ke state PackageLoaded
          context.read<PackageCubit>().fetchPackages();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Beli Paket Sesi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        bottomNavigationBar: _selectedPackage != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: SizedBox(
                  height: 52,
                  child: BlocBuilder<PackageCubit, PackageState>(
                    builder: (context, state) {
                      final isOrdering = state is PackageOrderLoading;
                      return ElevatedButton(
                        onPressed: isOrdering ? null : _onLanjutkan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isOrdering
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text('Lanjutkan',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                      );
                    },
                  ),
                ),
              )
            : const SizedBox.shrink(),
        body: BlocBuilder<PackageCubit, PackageState>(
          buildWhen: (prev, curr) =>
              curr is PackageLoading ||
              curr is PackageLoaded ||
              curr is PackageError,
          builder: (context, state) {
            if (state is PackageLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is PackageError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<PackageCubit>().fetchPackages(),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
              );
            } else if (state is PackageLoaded) {
              final packages = state.packages;

              if (packages.isEmpty) {
                return const Center(
                  child: Text('Tidak ada paket yang tersedia',
                      style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
                );
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 4),
                  const Text(
                    'Pilih Paket sesi yang sesuai dengan kebutuhan belajar Anda',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // List kartu paket
                  ...packages.map((paket) {
                    final isSelected = _selectedPackage?.id == paket.id;
                    final hargaPerSesi = paket.session > 0 ? (paket.price ~/ paket.session) : paket.price;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedPackage = paket),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.35),
                              width: isSelected ? 1.8 : 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header: ikon + judul + radio
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Ikon buku 📚 atau imagePath
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                      image: paket.imagePath != null && paket.imagePath!.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(paket.imagePath!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: (paket.imagePath == null || paket.imagePath!.isEmpty)
                                        ? const Center(
                                            child: Text('📚', style: TextStyle(fontSize: 26)),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(paket.name,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary)),
                                        const SizedBox(height: 2),
                                        Text(paket.description,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textSecondary)),
                                      ],
                                    ),
                                  ),
                                  // Radio button
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? AppColors.primary : Colors.grey.shade400,
                                        width: isSelected ? 0 : 1.5,
                                      ),
                                      color: isSelected ? AppColors.primary : Colors.white,
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check_rounded,
                                            color: Colors.white, size: 14)
                                        : null,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // Harga merah besar
                              Text(
                                _formatRupiah(paket.price),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: _priceRed,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Harga per sesi + jumlah sesi
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${_formatRupiah(hargaPerSesi)}/sesi',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary),
                                  ),
                                  Text(
                                    '${paket.session} sesi',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                ]),
              );
            }

            // Initial state
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}