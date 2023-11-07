import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_management/models/the_loai.dart';

class SelectedTheLoaiCubit extends Cubit<List<TheLoai>> {
  SelectedTheLoaiCubit() : super([]);

  void add(TheLoai theLoai) => emit([...state, theLoai]);
  void remove(TheLoai theLoai) {
    state.remove(theLoai);
    emit([...state]);
  }

  bool contains(TheLoai theLoai) {
    return state.contains(theLoai);
  }
}
