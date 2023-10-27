import 'package:flutter/material.dart';
import 'package:library_management/components/forms/add_edit_reader_form.dart';
import 'package:library_management/components/my_search_bar.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/reader.dart';
import 'package:library_management/utils/extension.dart';

class ReaderManage extends StatefulWidget {
  const ReaderManage({super.key});

  @override
  State<ReaderManage> createState() => _ReaderManageState();
}

class _ReaderManageState extends State<ReaderManage> {
  final List<String> _colsName = [
    '#',
    'Họ Tên',
    'Ngày sinh',
    'Địa chỉ',
    'Số điện thoại',
    'Ngày đăng ký',
    'Ngày hết hạn',
    'Tổng nợ',
  ];

  int selectedRow = -1;

  late final List<Reader> _readerRows;

  late final Future<void> _futureRecentReaders = _getRecentReaders();
  Future<void> _getRecentReaders() async {
    _readerRows = await dbProcess.querryRecentReader();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _futureRecentReaders,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MySearchBar(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => const AddEditReaderForm(),
                        );
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Thêm độc giả'),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: selectedRow == -1
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Xác nhận'),
                                  content: Text(
                                      'Bạn có chắc xóa Độc giả ${_readerRows[selectedRow].fullname}?'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Huỷ'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await dbProcess.deleteReader(
                                            _readerRows[selectedRow].id!);
                                        if (mounted) {
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Đã xóa Độc giả ${_readerRows[selectedRow].fullname}.'),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Có'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      icon: const Icon(Icons.delete),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (ctx) => AddEditReaderForm(
                          editReader: _readerRows[selectedRow],
                        ),
                      ),
                      icon: const Icon(Icons.edit),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  clipBehavior: Clip.antiAlias,
                  child: DataTable(
                    columnSpacing: 40,
                    dataRowColor:
                        MaterialStateProperty.resolveWith(_getDataRowColor),
                    border: TableBorder.symmetric(),
                    headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Theme.of(context).colorScheme.primary,
                    ),
                    showCheckboxColumn: false,
                    columns: List.generate(
                      _colsName.length,
                      (index) => DataColumn(
                        label: Text(
                          _colsName[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    rows: List.generate(
                      _readerRows.length,
                      (index) {
                        Reader reader = _readerRows[index];
                        return DataRow(
                          selected: selectedRow == index,
                          onSelectChanged: (_) => setState(() {
                            selectedRow = index;
                          }),
                          onLongPress: () {
                            setState(() {
                              selectedRow = index;
                            });
                            showDialog(
                              context: context,
                              builder: (ctx) => AddEditReaderForm(
                                editReader: reader,
                              ),
                            );
                          },
                          cells: [
                            DataCell(Text(reader.id!.toString())),
                            DataCell(
                              SizedBox(
                                width: 150,
                                child: Text(reader.fullname),
                              ),
                            ),
                            DataCell(Text(reader.dob.toVnFormat())),
                            DataCell(
                              SizedBox(
                                width: 250,
                                child: Text(reader.address),
                              ),
                            ),
                            DataCell(Text(reader.phoneNumber)),
                            DataCell(Text(reader.creationDate.toVnFormat())),
                            DataCell(Text(reader.expirationDate.toVnFormat())),
                            DataCell(
                              Text(
                                reader.totalTiabilities.toVnCurrencyFormat(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getDataRowColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.3);
    }

    // Thứ tự các dòng if ở đây khá quan trọng, thay đổi thứ tự là thay đổi hành vi
    if (states.contains(MaterialState.pressed)) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.3);
    }
    if (states.contains(MaterialState.hovered)) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.1);
    }

    return Colors.transparent;
  }
}
