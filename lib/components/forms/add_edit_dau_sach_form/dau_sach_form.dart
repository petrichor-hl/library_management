import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:library_management/components/label_text_form_field.dart';
import 'package:library_management/cubit/selected_tac_gia_cubit.dart';
import 'package:library_management/cubit/selected_the_loai_cubit.dart';
import 'package:library_management/dto/dau_sach_dto.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/dau_sach.dart';
import 'package:library_management/models/tac_gia.dart';
import 'package:library_management/models/the_loai.dart';

class DauSachForm extends StatefulWidget {
  const DauSachForm({
    super.key,
    this.editDauSach,
  });

  final DauSach? editDauSach;

  @override
  State<DauSachForm> createState() => _DauSachFormState();
}

class _DauSachFormState extends State<DauSachForm> {
  final _formKey = GlobalKey<FormState>();
  final _tenDauSachController = TextEditingController();

  bool _isProcessing = false;

  void _saveDauSach() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      await Future.delayed(const Duration(microseconds: 200));

      if (widget.editDauSach == null) {
        DauSachDto newDauSachDto = DauSachDto(
          null,
          _tenDauSachController.text,
          0,
          // ignore: use_build_context_synchronously
          context.read<SelectedTacGiaCubit>().state,
          // ignore: use_build_context_synchronously
          context.read<SelectedTheLoaiCubit>().state,
        );

        int returningId = await dbProcess.insertDauSachDto(newDauSachDto);
        newDauSachDto.maDauSach = returningId;

        if (mounted) {
          Navigator.of(context).pop(newDauSachDto);
        }
      } else {
        // TODO
      }

      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        child: SizedBox.expand(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.editDauSach == null ? 'THÊM ĐẦU SÁCH MỚI' : 'SỬA ĐẦU SÁCH',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close_rounded),
                  )
                ],
              ),
              Form(
                key: _formKey,
                child: LabelTextFormField(
                  controller: _tenDauSachController,
                  labelText: 'Tên Đầu sách',
                ),
              ),
              const Gap(12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Tác giả',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      BlocBuilder<SelectedTacGiaCubit, List<TacGia>>(builder: (ctx, tacGias) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            tacGias.length,
                            (index) => Text(tacGias[index].tenTacGia),
                          ),
                        );
                      }),
                      const Gap(12),
                      const Text(
                        'Thể loại',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      BlocBuilder<SelectedTheLoaiCubit, List<TheLoai>>(builder: (ctx, theLoais) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            theLoais.length,
                            (index) => Text(theLoais[index].tenTheLoai),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              _isProcessing
                  ? const SizedBox(
                      height: 44,
                      width: 44,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : FilledButton(
                      onPressed: _saveDauSach,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 30,
                        ),
                      ),
                      child: const Text(
                        'Lưu',
                        textAlign: TextAlign.center,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
