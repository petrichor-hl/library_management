import 'dart:math';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:library_management/components/forms/add_edit_reader_form.dart';
import 'package:library_management/components/my_search_bar.dart';
import 'package:library_management/components/pagination.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/reader.dart';
import 'package:library_management/utils/common_variables.dart';
import 'package:library_management/utils/extension.dart';

class ReaderManage extends StatefulWidget {
  const ReaderManage({super.key});

  @override
  State<ReaderManage> createState() => _ReaderManageState();
}

class _ReaderManageState extends State<ReaderManage> {
  // Danh sách Tên các cột trong Bảng Độc Giả
  final List<String> _colsName = [
    '#',
    'Họ Tên',
    'Ngày sinh',
    'Địa chỉ',
    'Số điện thoại',
    'Ngày lập thẻ',
    'Ngày hết hạn',
    'Tổng nợ',
  ];

  int _selectedRow = -1;

  /* 2 biến này không set final bởi vì nó sẽ thay đổi giá trị khi người dùng tương tác */
  late List<Reader> _readerRows;
  late int _readerCount;

  late final Future<void> _futureRecentReaders = _getRecentReaders();
  Future<void> _getRecentReaders() async {
    _readerRows = await dbProcess.querryReader(numberRowIgnore: 0);
    _readerCount = await dbProcess.queryCountReader();
  }

  /*
  Nếu có Độc giả mới được thêm (tức là đã điền đầy đủ thông tin hợp lệ + nhấn Save)
  thì phương thức showDialog() sẽ trả về một Reader mới
  */
  Future<void> _logicAddReader() async {
    Reader? newReader = await showDialog(
      context: context,
      builder: (ctx) => const AddEditReaderForm(),
    );

    // print(newReader);
    if (newReader != null) {
      // print(
      //     "('${newReader.fullname}', '${newReader.dob.toVnFormat()}', '${newReader.address}', '${newReader.phoneNumber}', '${newReader.creationDate.toVnFormat()}', '${newReader.expirationDate.toVnFormat()}', 0),");
      setState(() {
        if (_readerRows.length < 8) {
          _readerRows.add(newReader);
        }
        _readerCount++;
        // print('total page = ${_readerCount ~/ 8 + min(_readerCount % 8, 1)}');
      });
    }
  }

  /*
  Hàm này là logic xử lý khi người dùng nhấn vào nút Edit hoặc Long Press vào một Row trong bảng
  Đầu tiên là show AddEditReaderForm, showDialog() sẽ trả về:
    - String 'updated', nếu người dùng nhấn Save
    - null, nếu người dùng nhấn nút Close hoặc Click Outside of Dialog
  */
  Future<void> _logicEditReader() async {
    String? message = await showDialog(
      context: context,
      builder: (ctx) => AddEditReaderForm(
        editReader: _readerRows[_selectedRow],
      ),
    );

    // print(message);
    if (message == "updated") {
      setState(() {});
    }
  }

  /* 
  Hàm này là logic Xóa Độc giả 
  */
  Future<void> _logicDeleteReader() async {
    var deleteReaderName = _readerRows[_selectedRow].fullname;

    /* Xóa dòng dữ liệu*/
    await dbProcess.deleteReader(
      _readerRows[_selectedRow].id!,
    );

    /* 
    Lấy giá trị totalPages trước khi giảm _readerCount đi 1 đơn vị 
    VD: Có 17 dòng dữ liệu, phân trang 8 dòng => Đang có 3 total page 
    Nếu giảm _readerCount đi 1 đơn vị trước khi tính totalPages
    thì totalPages chỉ còn 2 => SAI 
    */
    int totalPages = _readerCount ~/ 8 + min(_readerCount % 8, 1);
    int currentPage = int.parse(_paginationController.text);

    _readerCount--;

    // print('totalPage = $totalPages');

    if (currentPage == totalPages) {
      _readerRows.removeAt(_selectedRow);
      /* 
      Trường hợp đặc biệt:
      Thủ thư đang ở trang cuối cùng và xóa nốt dòng cuối cùng 
      thì phải chuyển lại sang trang trước đó.

      Nếu không còn trang trước đó, tức _readerCount == 0, thì không cần làm gì cả
      */
      if (_readerRows.isEmpty && _readerCount > 0) {
        currentPage--;
        _paginationController.text = currentPage.toString();
        _loadReadersOfPageIndex(currentPage);
      }
    } else {
      _loadReadersOfPageIndex(currentPage);
    }

    setState(() {});

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã xóa Độc giả $deleteReaderName.',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          width: 400,
        ),
      );
    }
  }

  /* Hàm này dùng để lấy các Reader ở trang thứ Index và hiển thị lên bảng */
  Future<void> _loadReadersOfPageIndex(int pageIndex) async {
    var newReaderRows =
        await dbProcess.querryReader(numberRowIgnore: (pageIndex - 1) * 8);

    setState(() {
      _readerRows = newReaderRows;
      _selectedRow = -1;
    });
  }

  final _paginationController = TextEditingController(text: "1");

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

          int totalPages = _readerCount ~/ 8 + min(_readerCount % 8, 1);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const MySearchBar(),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /* 
                    Đây là nút "Thêm độc giả" mới,
                    Logic xử lý khi nhấn _logicAddReader xem ở bên trên
                    */
                    FilledButton.icon(
                      onPressed: _logicAddReader,
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
                    /* 
                    Đây là nút "Xóa độc giả",
                    Phòng trường hợp khi _selectedRow đang ở cuối bảng và ta nhấn xóa dòng cuối của bảng
                    Lúc này _selectedRow đã nằm ngoài mảng, và nút "Xóa độc giả" vẫn chưa được Disable
                    => Có khả năng gây ra lỗi
                    Solution: Sau khi xóa phải kiểm tra lại 
                    xem _selectedRow có nằm ngoài phạm vi của _readerRows hay không.
                    */
                    IconButton.filled(
                      onPressed: _selectedRow == -1
                          ? null
                          : () async {
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Xác nhận'),
                                  content: Text(
                                      'Bạn có chắc xóa Độc giả ${_readerRows[_selectedRow].fullname}?'),
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
                                    FilledButton(
                                      onPressed: _logicDeleteReader,
                                      child: const Text('Có'),
                                    ),
                                  ],
                                ),
                              );

                              if (_selectedRow >= _readerRows.length) {
                                _selectedRow = -1;
                              }
                            },
                      icon: const Icon(Icons.delete),
                      style: myIconButtonStyle,
                    ),
                    const SizedBox(width: 12),
                    /* 
                    Nút "Sửa thông tin Độc Giả" 
                    Logic xử lý _logicEditReader xem ở phần khai báo bên trên
                    */
                    IconButton.filled(
                      onPressed: _selectedRow == -1 ? null : _logicEditReader,
                      icon: const Icon(Icons.edit),
                      style: myIconButtonStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /* Bo góc cho DataTable */
                SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAlias,
                    child: DataTable(
                      /* Set màu cho Heading */
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Theme.of(context).colorScheme.primary,
                      ),
                      /* The horizontal margin between the contents of each data column */
                      columnSpacing: 40,
                      dataRowColor:
                          MaterialStateProperty.resolveWith(_getDataRowColor),
                      dataRowMaxHeight: 62,
                      border: TableBorder.symmetric(),
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
                          /* Thẻ Độc Giả quá hạn sẽ tô màu xám (black26) */
                          TextStyle cellTextStyle = TextStyle(
                              color: reader.expirationDate < DateTime.now()
                                  ? Colors.black26
                                  : Colors.black);

                          return DataRow(
                            /* Thẻ Độc Giả quá hạn sẽ tô màu xám (black12) */
                            color: reader.expirationDate < DateTime.now()
                                ? MaterialStateProperty.resolveWith((states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3);
                                    }
                                    return Colors.black12;
                                  })
                                : null,
                            selected: _selectedRow == index,
                            onSelectChanged: (_) => setState(() {
                              _selectedRow = index;
                            }),
                            onLongPress: () {
                              setState(() {
                                _selectedRow = index;
                              });
                              _logicEditReader();
                            },
                            cells: [
                              DataCell(
                                Text(
                                  reader.id!.toString(),
                                  style: cellTextStyle,
                                ),
                              ),
                              DataCell(
                                /* Ràng buộc cho Chiều rộng Tối đa của cột Họ Tên = 150 */
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 150),
                                  child: Text(
                                    reader.fullname,
                                    style: cellTextStyle,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  reader.dob.toVnFormat(),
                                  style: cellTextStyle,
                                ),
                              ),
                              DataCell(
                                /* 
                                Ràng buộc cho Chiều rộng Tối đa của cột Địa chỉ = 250 
                                phòng trường hợp địa chỉ quá dài
                                */
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 250),
                                  child: Text(
                                    reader.address,
                                    style: cellTextStyle,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  reader.phoneNumber,
                                  style: cellTextStyle,
                                ),
                              ),
                              DataCell(
                                Text(
                                  reader.creationDate.toVnFormat(),
                                  style: cellTextStyle,
                                ),
                              ),
                              DataCell(
                                Text(
                                  reader.expirationDate.toVnFormat(),
                                  style: cellTextStyle,
                                ),
                              ),
                              DataCell(
                                Text(
                                  reader.totalTiabilities
                                      .toVnCurrencyWithoutSymbolFormat(),
                                  style: cellTextStyle,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (_readerCount > 0) const Spacer(),
                _readerCount > 0
                    ? Pagination(
                        controller: _paginationController,
                        maxPages: totalPages,
                        onChanged: _loadReadersOfPageIndex,
                      )
                    : const Expanded(
                        child: Center(
                          child: Text(
                            'Chưa có dữ liệu Độc Giả',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
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
