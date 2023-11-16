import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_management/dto/cuon_sach_dto_2th.dart';

class SelectedCuonSachChoMuonCubit extends Cubit<List<CuonSachDto2th>> {
  SelectedCuonSachChoMuonCubit() : super([]);

  void add(CuonSachDto2th cuonSach) => emit([...state, cuonSach]);
  void remove(CuonSachDto2th cuonSach) {
    state.removeWhere(
      (element) => element.maCuonSach == cuonSach.maCuonSach,
    );
    emit([...state]);
  }

  bool contains(CuonSachDto2th needCheckCuonSach) {
    for (var cuonSach in state) {
      if (cuonSach.maCuonSach == needCheckCuonSach.maCuonSach) {
        return true;
      }
    }
    return false;
  }

  void clear() => emit([]);
}
