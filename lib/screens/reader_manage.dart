import 'package:flutter/material.dart';
import 'package:library_management/components/forms/add_edit_reader_form.dart';
import 'package:library_management/components/my_search_bar.dart';

class ReaderManage extends StatefulWidget {
  const ReaderManage({super.key});

  @override
  State<ReaderManage> createState() => _ReaderManageState();
}

class _ReaderManageState extends State<ReaderManage> {
  final List<String> _colsName = [
    'Mã độc giả',
    'Họ Tên',
    'Ngày sinh',
    'Địa chỉ',
    'Số điện thoại',
    'Tổng nợ'
  ];

  int selectedRow = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                      builder: (ctx) => AddEditReaderForm(),
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
                  onPressed: () {},
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
                  onPressed: () {},
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
                  5,
                  (index) => DataRow(
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
                        builder: (ctx) => AddEditReaderForm(),
                      );
                    },
                    cells: const [
                      DataCell(Text('Dash')),
                      DataCell(Text('Dash')),
                      DataCell(Text('Dash')),
                      DataCell(Text('Dash')),
                      DataCell(Text('Dash')),
                      DataCell(Text('Dash')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDataRowColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.5);
    }

    // Thứ tự các dòng if ở đây khá quan trọng, thay đổi thứ tự là thay đổi hành vi
    if (states.contains(MaterialState.pressed)) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.5);
    }
    if (states.contains(MaterialState.hovered)) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.1);
    }

    return Colors.transparent;
  }
}
