import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:library_management/components/forms/add_edit_dau_sach_form/dau_sach_form.dart';
import 'package:library_management/components/forms/add_edit_dau_sach_form/tac_gia_form.dart';
import 'package:library_management/components/forms/add_edit_dau_sach_form/the_loai_form.dart';
import 'package:library_management/cubit/selected_tac_gia_cubit.dart';
import 'package:library_management/cubit/selected_the_loai_cubit.dart';
import 'package:library_management/models/dau_sach.dart';
import 'package:library_management/models/the_loai.dart';

class AddEditDauSachForm extends StatefulWidget {
  const AddEditDauSachForm({
    super.key,
    this.editDauSach,
  });

  final DauSach? editDauSach;

  @override
  State<AddEditDauSachForm> createState() => _AddEditDauSachFormState();
}

class _AddEditDauSachFormState extends State<AddEditDauSachForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 180),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SelectedTacGiaCubit()),
          BlocProvider(create: (_) => SelectedTheLoaiCubit()),
        ],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: DauSachForm(
                editDauSach: widget.editDauSach,
              ),
            ),
            const Gap(12),
            const Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: TacGiaForm(),
                  ),
                  Gap(12),
                  Expanded(
                    child: TheLoaiForm(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
