import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/components/label_text_field_datepicker.dart';
import 'package:library_management/components/label_text_form_field.dart';
import 'package:library_management/models/reader.dart';
import 'package:library_management/parameters.dart';

class AddEditReaderForm extends StatelessWidget {
  AddEditReaderForm({super.key, this.editReader});

  final Reader? editReader;

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _creationDateController = TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void setCreationExpriationDate(DateTime date) {
    _creationDateController.text = DateFormat('dd/MM/yyyy').format(date);

    _expirationDateController.text = DateFormat('dd/MM/yyyy').format(
      date.addMonths(6),
    );
  }

  @override
  Widget build(BuildContext context) {
    setCreationExpriationDate(DateTime.now());

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    editReader == null ? 'TẠO THẺ ĐỘC GIẢ' : 'SỬA THẺ ĐỘC GIẢ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  )
                ],
              ),
              //
              const SizedBox(height: 10),
              const LabelTextFormField(
                labelText: 'Mã độc giả',
                hint: '0112',
                isEnable: false,
              ),
              //
              const SizedBox(height: 10),
              LabelTextFormField(
                labelText: 'Họ Tên',
                controller: _fullnameController,
              ),
              //
              const SizedBox(height: 10),
              LabelTextFieldDatePicker(
                labelText: 'Ngày sinh',
                controller: _dobController,
              ),
              //
              const SizedBox(height: 10),
              LabelTextFormField(
                labelText: 'Địa chỉ',
                controller: _addressController,
              ),
              //
              const SizedBox(height: 10),
              LabelTextFormField(
                labelText: 'Số điện thoại',
                controller: _phoneController,
              ),
              //
              const SizedBox(height: 10),
              const Text(
                'Ngày đăng ký',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        DateTime? chosenDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (chosenDate != null) {
                          setCreationExpriationDate(chosenDate);
                        }
                      },
                      child: TextFormField(
                        controller: _creationDateController,
                        enabled: false,
                        mouseCursor: SystemMouseCursors.click,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 245, 246, 250),
                          hintText: 'dd/MM/yyyy',
                          hintStyle: const TextStyle(color: Color(0xFF888888)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(14),
                          isCollapsed: true,
                          // isDense: true,
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () async {
                      DateTime? chosenDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (chosenDate != null) {
                        setCreationExpriationDate(chosenDate);
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    padding: const EdgeInsets.all(10),
                  )
                ],
              ),
              //
              const SizedBox(height: 10),
              LabelTextFormField(
                labelText: 'Ngày hết hạn',
                isEnable: false,
                controller: _expirationDateController,
              ),
              //
              const SizedBox(height: 10),
              Text(
                '*Thu tiền tạo thẻ ${NumberFormat.currency(locale: 'vi_VN').format(Parameters.cardCreationFee)}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: FilledButton(
                  onPressed: () {},
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
                    'Save',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
