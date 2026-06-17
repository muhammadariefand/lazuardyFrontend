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
    emit(state.copyWith(isLoading: true));
    try {
      final data = await getProvincesUseCase.execute();
      emit(state.copyWith(isLoading: false, provinces: data));
    } catch (e) {
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

  void prefillRegions({
    String? provinceName,
    String? regencyName,
    String? districtName,
    String? subdistrictName,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final provinces = await getProvincesUseCase.execute();
      RegionEntity? selProv;
      if (provinceName != null) {
        for (var p in provinces) {
          if (p.name.toUpperCase().trim() == provinceName.toUpperCase().trim()) {
            selProv = p;
            break;
          }
        }
      }

      if (selProv == null) {
        emit(state.copyWith(isLoading: false, provinces: provinces));
        return;
      }

      final regencies = await getRegenciesUseCase.execute(selProv.id);
      RegionEntity? selReg;
      if (regencyName != null) {
        for (var r in regencies) {
          if (r.name.toUpperCase().trim() == regencyName.toUpperCase().trim()) {
            selReg = r;
            break;
          }
        }
      }

      if (selReg == null) {
        emit(state.copyWith(
          isLoading: false,
          provinces: provinces,
          selectedProvince: selProv,
          regencies: regencies,
        ));
        return;
      }

      final districts = await getDistrictsUseCase.execute(selReg.id);
      RegionEntity? selDist;
      if (districtName != null) {
        for (var d in districts) {
          if (d.name.toUpperCase().trim() == districtName.toUpperCase().trim()) {
            selDist = d;
            break;
          }
        }
      }

      if (selDist == null) {
        emit(state.copyWith(
          isLoading: false,
          provinces: provinces,
          selectedProvince: selProv,
          regencies: regencies,
          selectedRegency: selReg,
          districts: districts,
        ));
        return;
      }

      final subdistricts = await getSubdistrictsUseCase.execute(selDist.id);
      RegionEntity? selSub;
      if (subdistrictName != null) {
        for (var s in subdistricts) {
          if (s.name.toUpperCase().trim() == subdistrictName.toUpperCase().trim()) {
            selSub = s;
            break;
          }
        }
      }

      emit(state.copyWith(
        isLoading: false,
        provinces: provinces,
        selectedProvince: selProv,
        regencies: regencies,
        selectedRegency: selReg,
        districts: districts,
        selectedDistrict: selDist,
        subdistricts: subdistricts,
        selectedSubdistrict: selSub,
      ));
    } catch (e) {
      print("Error prefillRegions: $e");
      emit(state.copyWith(isLoading: false));
    }
  }
}