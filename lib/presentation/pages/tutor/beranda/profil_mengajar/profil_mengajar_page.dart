import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/profil_mengajar/profil_mengajar_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/profil_mengajar/profil_mengajar_state.dart';


class _HariSlot {
  final String label;
  final String namaLengkap;
  final String englishName;
  List<String> aktif;

  _HariSlot({
    required this.label,
    required this.namaLengkap,
    required this.englishName,
    required this.aktif,
  });
}

class ProfilMengajarPage extends StatefulWidget {
  const ProfilMengajarPage({super.key});

  @override
  State<ProfilMengajarPage> createState() => _ProfilMengajarPageState();
}

class _ProfilMengajarPageState extends State<ProfilMengajarPage> {
  bool _isEditMode = false;
  bool _onlineAktif = false;
  bool _offlineAktif = false;
  int _selectedHariIdx = 0;

  late final TextEditingController _deskripsiCtrl;

  static const _allSlots = [
    '08:00', '09:00', '10:00', '11:00',
    '12:00', '13:00', '14:00', '15:00',
    '16:00', '17:00', '18:00', '19:00',
    '20:00', '21:00',
  ];

  late List<_HariSlot> _hariList;

  @override
  void initState() {
    super.initState();
    _deskripsiCtrl = TextEditingController();
    _initHariList();
  }

  void _initHariList() {
    _hariList = [
      _HariSlot(label: 'Sen', namaLengkap: 'Senin', englishName: 'monday', aktif: []),
      _HariSlot(label: 'Sel', namaLengkap: 'Selasa', englishName: 'tuesday', aktif: []),
      _HariSlot(label: 'Rab', namaLengkap: 'Rabu', englishName: 'wednesday', aktif: []),
      _HariSlot(label: 'Kam', namaLengkap: 'Kamis', englishName: 'thursday', aktif: []),
      _HariSlot(label: 'Jum', namaLengkap: 'Jumat', englishName: 'friday', aktif: []),
      _HariSlot(label: 'Sab', namaLengkap: 'Sabtu', englishName: 'saturday', aktif: []),
      _HariSlot(label: 'Min', namaLengkap: 'Minggu', englishName: 'sunday', aktif: []),
    ];
  }

  @override
  void dispose() {
    _deskripsiCtrl.dispose();
    super.dispose();
  }

  _HariSlot get _selectedHari => _hariList[_selectedHariIdx];

  List<String> get _availableSlots => _allSlots
      .where((s) => !_selectedHari.aktif.contains(s))
      .toList();

  void _addSlot(String jam) {
    setState(() {
      _selectedHari.aktif = [..._selectedHari.aktif, jam]..sort();
    });
  }

  void _removeSlot(String jam) {
    setState(() {
      _selectedHari.aktif = _selectedHari.aktif.where((s) => s != jam).toList();
    });
  }

  void _populateData(ProfilMengajarLoaded state) {
    if (_isEditMode) return;

    _deskripsiCtrl.text = state.tutorProfile.description ?? '';
    final methods = state.tutorProfile.learningMethods;
    _onlineAktif = methods.contains('online');
    _offlineAktif = methods.contains('offline');

    _initHariList();
    for (var schedule in state.schedules) {
      final slotStr = schedule.time.length >= 5 ? schedule.time.substring(0, 5) : schedule.time;
      final dayStr = schedule.day.toLowerCase();
      for (var hari in _hariList) {
        if (hari.englishName == dayStr) {
          if (!hari.aktif.contains(slotStr)) {
            hari.aktif.add(slotStr);
          }
          hari.aktif.sort();
          break;
        }
      }
    }
  }

  void _simpan() {
    final List<String> selectedMethods = [];
    if (_onlineAktif) selectedMethods.add('online');
    if (_offlineAktif) selectedMethods.add('offline');

    final List<Map<String, String>> schedules = [];
    for (var hari in _hariList) {
      for (var jam in hari.aktif) {
        schedules.add({
          'day': hari.englishName,
          'time': jam,
        });
      }
    }

    context.read<ProfilMengajarCubit>().saveProfile(
          description: _deskripsiCtrl.text.trim(),
          learningMethods: selectedMethods,
          schedules: schedules,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ProfilMengajarCubit, ProfilMengajarState>(
        listener: (context, state) {
          if (state is ProfilMengajarLoaded) {
            if (state.submitSuccessMessage != null) {
              setState(() => _isEditMode = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.submitSuccessMessage!),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.read<ProfilMengajarCubit>().clearMessages();
            } else if (state.submitErrorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.submitErrorMessage!),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.read<ProfilMengajarCubit>().clearMessages();
            }
          }
        },
        builder: (context, state) {
          if (state is ProfilMengajarLoading || state is ProfilMengajarInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is ProfilMengajarError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProfilMengajarCubit>().fetchProfileData(),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            );
          } else if (state is ProfilMengajarLoaded) {
            _populateData(state);

            return Stack(
              children: [
                Column(
                  children: [
                    _buildAppBar(state.isSubmitting),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildDeskripsiCard(),
                            const SizedBox(height: 14),
                            _buildMetodeCard(),
                            const SizedBox(height: 14),
                            _buildSlotCard(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (state.isSubmitting)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAppBar(bool isSubmitting) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 4,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_isEditMode) {
                setState(() {
                  _isEditMode = false;
                  final state = context.read<ProfilMengajarCubit>().state;
                  if (state is ProfilMengajarLoaded) {
                    _populateData(state);
                  }
                });
              } else {
                Navigator.pop(context);
              }
            },
            icon: Icon(
              _isEditMode ? Icons.close_rounded : Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Expanded(
            child: Text(
              'Profil Mengajar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: isSubmitting
                ? null
                : () {
                    if (_isEditMode) {
                      _simpan();
                    } else {
                      setState(() => _isEditMode = true);
                    }
                  },
            icon: Icon(
              _isEditMode ? Icons.save_outlined : Icons.edit_outlined,
              color: isSubmitting ? Colors.white54 : Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeskripsiCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi Mengajar',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _isEditMode
              ? TextField(
                  controller: _deskripsiCtrl,
                  minLines: 4,
                  maxLines: 8,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textPrimary, height: 1.5),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                )
              : Text(
                  _deskripsiCtrl.text.isEmpty
                      ? 'Belum ada deskripsi mengajar.'
                      : _deskripsiCtrl.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: _deskripsiCtrl.text.isEmpty
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    fontStyle: _deskripsiCtrl.text.isEmpty
                        ? FontStyle.italic
                        : FontStyle.normal,
                    height: 1.6,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildMetodeCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metode Mengajar',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _metodeButton(
                icon: Icons.videocam_outlined,
                label: 'Online',
                isActive: _onlineAktif,
                onTap: _isEditMode
                    ? () => setState(() => _onlineAktif = !_onlineAktif)
                    : null,
              ),
              const SizedBox(width: 12),
              _metodeButton(
                icon: Icons.location_on_outlined,
                label: 'Offline',
                isActive: _offlineAktif,
                onTap: _isEditMode
                    ? () => setState(() => _offlineAktif = !_offlineAktif)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metodeButton({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? AppColors.primary : const Color(0xFFCCCCCC),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 18, color: isActive ? Colors.white : AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Atur Slot Ketersediaan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          _buildHariSelector(),
          const SizedBox(height: 18),
          Text(
            'Slot Aktif - ${_selectedHari.namaLengkap}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _buildAktifChips(),
          const SizedBox(height: 18),
          if (_availableSlots.isNotEmpty) ...[
            const Text(
              'Tambah slot',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            _buildTambahSlotGrid(),
          ],
        ],
      ),
    );
  }

  Widget _buildHariSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_hariList.length, (i) {
        final hari = _hariList[i];
        final isSelected = _selectedHariIdx == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedHariIdx = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 40,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFCCCCCC),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hari.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${hari.aktif.length} slot',
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected
                        ? Colors.white.withOpacity(0.85)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAktifChips() {
    final aktif = _selectedHari.aktif;

    if (aktif.isEmpty) {
      return Text(
        'Belum ada slot aktif',
        style: TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary.withOpacity(0.7),
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: aktif.map((jam) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule_rounded, size: 15, color: AppColors.primary),
              const SizedBox(width: 5),
              Text(
                jam,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              if (_isEditMode) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _removeSlot(jam),
                  child: const Icon(Icons.cancel_rounded,
                      size: 16, color: Colors.red),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTambahSlotGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableSlots.map((jam) {
        return GestureDetector(
          onTap: _isEditMode ? () => _addSlot(jam) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded,
                    size: 14,
                    color: _isEditMode
                        ? AppColors.textPrimary
                        : AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  jam,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _isEditMode
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}