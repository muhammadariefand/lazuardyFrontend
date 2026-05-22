import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/region_entity.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_districts_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_provinces_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_regencies_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/region/get_subdistricts_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_state.dart';

class RegionCubit extends Cubit<RegionState> {
  final GetProvincesUseCase getProvincesUseCase;
  final GetRegenciesUseCase getRegenciesUseCase;
  final GetDistrictsUseCase getDistrictsUseCase;
  final GetSubdistrictsUseCase getSubdistrictsUseCase;

  RegionCubit(
    this.getProvincesUseCase,
    this.getRegenciesUseCase,
    this.getDistrictsUseCase,
    this.getSubdistrictsUseCase,
  ) : super(RegionState());

  void fetchProvinces() async {
    print("DEBUG: Memanggil fetchProvinces..."); // Tambahkan ini
    emit(state.copyWith(isLoading: true));
    try {
      final data = await getProvincesUseCase.execute();
      print("DEBUG: Data Provinsi Berhasil: ${data.length} item"); // Tambahkan ini
      emit(state.copyWith(isLoading: false, provinces: data));
    } catch (e) {
      print("DEBUG: Error fetchProvinces: $e"); // Cek error di console!
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectProvince(RegionEntity province) async {
    // Reset Kota, Kecamatan, Desa jika Provinsi diganti
    emit(state.copyWith(
      selectedProvince: province,
      clearRegency: true,
      clearDistrict: true,
      clearSubdistrict: true,
      isLoading: true,
    ));
    try {
      final data = await getRegenciesUseCase.execute(province.id);
      emit(state.copyWith(isLoading: false, regencies: data));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectRegency(RegionEntity regency) async {
    emit(state.copyWith(
      selectedRegency: regency,
      clearDistrict: true,
      clearSubdistrict: true,
      isLoading: true,
    ));
    try {
      final data = await getDistrictsUseCase.execute(regency.id);
      emit(state.copyWith(isLoading: false, districts: data));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectDistrict(RegionEntity district) async {
    emit(state.copyWith(
      selectedDistrict: district,
      clearSubdistrict: true,
      isLoading: true,
    ));
    try {
      final data = await getSubdistrictsUseCase.execute(district.id);
      emit(state.copyWith(isLoading: false, subdistricts: data));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectSubdistrict(RegionEntity subdistrict) {
    emit(state.copyWith(selectedSubdistrict: subdistrict));
  }
}