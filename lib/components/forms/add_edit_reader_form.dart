import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:library_management/components/label_text_form_field_datepicker.dart';
import 'package:library_management/components/label_text_form_field.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/reader.dart';
import 'package:library_management/utils/common_variables.dart';
import 'package:library_management/utils/extension.dart';
import 'package:library_management/utils/parameters.dart';

class AddEditReaderForm extends StatefulWidget {
  const AddEditReaderForm({super.key, this.editReader});

  final Reader? editReader;

  @override
  State<AddEditReaderForm> createState() => _AddEditReaderFormState();
}

class _AddEditReaderFormState extends State<AddEditReaderForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final _fullnameController = TextEditingController();

  final _dobController = TextEditingController();

  final _addressController = TextEditingController();

  final _phoneController = TextEditingController();

  final _creationDateController = TextEditingController();

  final _expirationDateController = TextEditingController();

  final _totalTiabilitiesController = TextEditingController();

  void setCreationExpriationDate(DateTime date) {
    _creationDateController.text = date.toVnFormat();
    _expirationDateController.text = date.addMonths(6).toVnFormat();
  }

  void saveReader(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      if (widget.editReader == null) {
        Reader newReader = Reader(
          null,
          _fullnameController.text,
          vnDateFormat.parse(_dobController.text),
          _addressController.text,
          _phoneController.text,
          vnDateFormat.parse(_creationDateController.text),
          vnDateFormat.parse(_expirationDateController.text),
          0,
        );

        int returningId = await dbProcess.insertReader(newReader);
        newReader.id = returningId;

        if (mounted) {
          Navigator.of(context).pop(newReader);
        }
      } else {
        widget.editReader!.fullname = _fullnameController.text;
        widget.editReader!.dob = vnDateFormat.parse(_dobController.text);
        widget.editReader!.address = _addressController.text;
        widget.editReader!.phoneNumber = _phoneController.text;
        widget.editReader!.creationDate =
            vnDateFormat.parse(_creationDateController.text);
        widget.editReader!.expirationDate =
            vnDateFormat.parse(_expirationDateController.text);
        widget.editReader!.totalTiabilities =
            int.parse(_totalTiabilitiesController.text.replaceAll('.', ''));

        await dbProcess.updateReader(widget.editReader!);

        if (mounted) {
          Navigator.of(context).pop('updated');
        }
      }

      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.editReader == null
                ? 'Tạo thẻ độc giả thành công.'
                : 'Cập nhật thông tin thành công'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            width: 300,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.editReader != null) {
      _fullnameController.text = widget.editReader!.fullname;
      _dobController.text = widget.editReader!.dob.toVnFormat();
      _addressController.text = widget.editReader!.address;
      _phoneController.text = widget.editReader!.phoneNumber;
      _addressController.text = widget.editReader!.address;
      _creationDateController.text =
          widget.editReader!.creationDate.toVnFormat();
      _expirationDateController.text =
          widget.editReader!.expirationDate.toVnFormat();
      _totalTiabilitiesController.text =
          widget.editReader!.totalTiabilities.toVnCurrencyWithoutSymbolFormat();
    } else {
      /* 
      Nếu là thêm mới Độc Giả, thì thiết lập sẵn Creation và ExpriationDate 
      CreationDate là DateTime.now()
      ExpriationDate là DateTime.now() + 6 tháng 
      */
      setCreationExpriationDate(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.editReader == null
                          ? 'TẠO THẺ ĐỘC GIẢ'
                          : 'SỬA THẺ ĐỘC GIẢ',
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
                // if (widget.editReader != null) ...[
                //   const SizedBox(height: 10),
                //   LabelTextFormField(
                //     labelText: 'Mã độc giả',
                //     initText: widget.editReader!.id.toString(),
                //     isEnable: false,
                //   ),
                // ],
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
                  initialDate: widget.editReader != null
                      ? widget.editReader!.dob
                      : DateTime.now(),
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
                  'Ngày lập thẻ',
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
                            initialDate: widget.editReader != null
                                ? widget.editReader!.creationDate
                                : DateTime.now(),
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
                            hintStyle:
                                const TextStyle(color: Color(0xFF888888)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.all(14),
                            isCollapsed: true,
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
                          initialDate: widget.editReader != null
                              ? widget.editReader!.creationDate
                              : DateTime.now(),
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
                if (widget.editReader != null) ...[
                  const SizedBox(height: 10),
                  LabelTextFormField(
                    labelText: 'Tổng nợ',
                    controller: _totalTiabilitiesController,
                    suffixText: 'VND',
                    onEditingComplete: () {
                      var text = _totalTiabilitiesController.text;
                      try {
                        _totalTiabilitiesController.text =
                            int.parse(text).toVnCurrencyWithoutSymbolFormat();
                      } catch (e) {
                        // Do nothing
                        // print('Parse FAILED');
                      }
                      FocusScope.of(context).unfocus();
                    },
                    onTap: () {
                      _totalTiabilitiesController.text =
                          _totalTiabilitiesController.text.replaceAll('.', '');
                    },
                  ),
                ] else ...[
                  const SizedBox(height: 10),
                  Text(
                    '*Thu tiền tạo thẻ ${Parameters.cardCreationFee.toVnCurrencyFormat()}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  )
                ],
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: _isProcessing
                      ? const SizedBox(
                          height: 44,
                          width: 44,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : FilledButton(
                          onPressed: () => saveReader(context),
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
      ),
    );
  }
}
