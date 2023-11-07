import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_management/models/tac_gia.dart';

class SelectedTacGiaCubit extends Cubit<List<TacGia>> {
  SelectedTacGiaCubit() : super([]);

  void add(TacGia tacGia) => emit([...state, tacGia]);
  void remove(TacGia tacGia) {
    state.remove(tacGia);
    emit([...state]);
  }

  bool contains(TacGia tacGia) {
    return state.contains(tacGia);
  }
}
