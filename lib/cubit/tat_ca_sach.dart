import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_management/models/sach.dart';

class TatCaSachCubit extends Cubit<List<Sach>> {
  TatCaSachCubit() : super([]);

  void setList(List<Sach> sachs) => emit(sachs);
  void addSach(Sach newSach) => emit([...state, newSach]);
}
