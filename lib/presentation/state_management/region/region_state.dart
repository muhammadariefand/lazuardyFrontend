import 'package:lazuadry_mobile_fe/domain/entities/region_entity.dart';

class RegionState {
  final bool isLoading;
  
  // List Data
  final List<RegionEntity> provinces;
  final List<RegionEntity> regencies;
  final List<RegionEntity> districts;
  final List<RegionEntity> subdistricts;

  // Selected Data
  final RegionEntity? selectedProvince;
  final RegionEntity? selectedRegency;
  final RegionEntity? selectedDistrict;
  final RegionEntity? selectedSubdistrict;

  RegionState({
    this.isLoading = false,
    this.provinces = const [],
    this.regencies = const [],
    this.districts = const [],
    this.subdistricts = const [],
    this.selectedProvince,
    this.selectedRegency,
    this.selectedDistrict,
    this.selectedSubdistrict,
  });

  RegionState copyWith({
    bool? isLoading,
    List<RegionEntity>? provinces,
    List<RegionEntity>? regencies,
    List<RegionEntity>? districts,
    List<RegionEntity>? subdistricts,
    RegionEntity? selectedProvince,
    RegionEntity? selectedRegency,
    RegionEntity? selectedDistrict,
    RegionEntity? selectedSubdistrict,
    bool clearRegency = false,
    bool clearDistrict = false,
    bool clearSubdistrict = false,
  }) {
    return RegionState(
      isLoading: isLoading ?? this.isLoading,
      provinces: provinces ?? this.provinces,
      regencies: clearRegency ? [] : (regencies ?? this.regencies),
      districts: clearDistrict ? [] : (districts ?? this.districts),
      subdistricts: clearSubdistrict ? [] : (subdistricts ?? this.subdistricts),
      selectedProvince: selectedProvince ?? this.selectedProvince,
      selectedRegency: clearRegency ? null : (selectedRegency ?? this.selectedRegency),
      selectedDistrict: clearDistrict ? null : (selectedDistrict ?? this.selectedDistrict),
      selectedSubdistrict: clearSubdistrict ? null : (selectedSubdistrict ?? this.selectedSubdistrict),
    );
  }
}