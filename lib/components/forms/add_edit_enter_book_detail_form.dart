import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:library_management/components/forms/add_edit_dau_sach_form.dart';
import 'package:library_management/components/label_text_form_field.dart';
import 'package:library_management/components/my_search_bar.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/dau_sach.dart';
import 'package:library_management/models/enter_book_detail.dart';
import 'package:library_management/utils/common_variables.dart';

class AddEditEnterBookDetailForm extends StatefulWidget {
  const AddEditEnterBookDetailForm({
    super.key,
    this.editEnterBookDetail,
  });

  final EnterBookDetail? editEnterBookDetail;

  @override
  State<AddEditEnterBookDetailForm> createState() => _AddEditEnterBookDetailState();
}

class _AddEditEnterBookDetailState extends State<AddEditEnterBookDetailForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isProcessing = false;
  bool _isOpen = false;
  bool _isQueryingDauSach = false;

  List<DauSach> _dausachs = [];

  int selectedIndex = -1;

  /* Key này dùng để xác định vị trí của Inkwell Chọn Đầu sách */
  final _chonDauSachKey = GlobalKey();

  /* Controller cho những TextField nằm trong Dialog Thêm sách mới */
  final timTenDauSachController = TextEditingController();
  final _lanTaiBanController = TextEditingController();
  final _nhaXuatBanController = TextEditingController();

  /* Controller cho những TextField nằm trong Dialog Thêm chi tiết nhập sách */
  final _maSachController = TextEditingController();
  final _soLuongController = TextEditingController();
  final _donGiaController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _maSachController.dispose();
    _soLuongController.dispose();
    _donGiaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    List<DauSach> filteredDauSachs = List.of(_dausachs);
    return AnimatedPadding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * (_isOpen ? 0.05 : 0.2) - (_isOpen ? 6 : 0)),
      duration: const Duration(milliseconds: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              AnimatedPadding(
                padding: EdgeInsets.only(right: _isOpen ? 12 + screenWidth * 0.3 : 0),
                duration: const Duration(milliseconds: 200),
                child: Dialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(0),
                  child: SizedBox(
                    height: 500,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 30,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MySearchBar(
                            controller: TextEditingController(),
                            onSearch: () {},
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Tất cả Sách',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              _isQueryingDauSach
                                  ? Container(
                                      height: 44,
                                      width: 160,
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 70),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    )
                                  : FilledButton.icon(
                                      onPressed: () async {
                                        if (_dausachs.isEmpty) {
                                          setState(() {
                                            _isQueryingDauSach = true;
                                          });
                                          _dausachs = await dbProcess.queryDauSach();
                                          /* Delay thêm một khoản thời gian nhỏ cho người dùng thấy cái loading thôi :))) */
                                          await Future.delayed(
                                            const Duration(milliseconds: 200),
                                          );
                                          setState(() {
                                            _isQueryingDauSach = false;
                                          });
                                        }
                                        setState(() {
                                          _isOpen = true;
                                        });
                                      },
                                      icon: const Icon(Icons.add_rounded),
                                      label: const Text('Thêm mới sách'),
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(height: 10),
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
                                dataRowColor: MaterialStateProperty.resolveWith(
                                  (states) => getDataRowColor(context, states),
                                ),
                                dataRowMaxHeight: 62,
                                border: TableBorder.symmetric(),
                                showCheckboxColumn: false,
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      'Mã Sách',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Tên đầu Sách',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Lần Tái Bản',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'NXB',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: [],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              /*
              Thêm Sách mới
              */
              Positioned(
                right: 0,
                child: IgnorePointer(
                  ignoring: !_isOpen,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isOpen ? 1 : 0,
                    child: AnimatedSlide(
                      offset: _isOpen ? const Offset(0, 0) : const Offset(-0.15, 0),
                      duration: const Duration(milliseconds: 200),
                      child: Dialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(0),
                        child: SizedBox(
                          width: screenWidth * 0.3,
                          height: 500,
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
                                    const Text(
                                      'THÊM SÁCH MỚI',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isOpen = false;
                                        });
                                      },
                                      icon: const Icon(Icons.arrow_back_rounded),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Đầu sách',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Ink(
                                  height: 44,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 245, 246, 250),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: StatefulBuilder(builder: (ctx, setStateInWell) {
                                    return InkWell(
                                      key: _chonDauSachKey,
                                      onTap: () {
                                        // Lấy vị trí của Widget đã được render trên màn hình
                                        RenderObject? renderObject = _chonDauSachKey.currentContext!.findRenderObject();
                                        Offset widgetPosition = (renderObject as RenderBox).localToGlobal(Offset.zero);

                                        final themDauSachController = TextEditingController();
                                        showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return Stack(
                                              children: [
                                                Positioned(
                                                  top: widgetPosition.dy + 46,
                                                  left: widgetPosition.dx,
                                                  child: Card(
                                                    margin: const EdgeInsets.all(0),
                                                    elevation: 4,
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.vertical(
                                                        bottom: Radius.circular(6),
                                                      ),
                                                    ),
                                                    clipBehavior: Clip.antiAlias,
                                                    child: Ink(
                                                      width: screenWidth * 0.3 - 60,
                                                      color: Colors.white,
                                                      child: ConstrainedBox(
                                                        constraints: const BoxConstraints(maxHeight: 290),
                                                        child: StatefulBuilder(
                                                          builder: (ctx, setStateColumn) {
                                                            String searchText = timTenDauSachController.text;
                                                            if (searchText.isEmpty) {
                                                              filteredDauSachs = List.of(_dausachs);
                                                            } else {
                                                              filteredDauSachs = _dausachs.where((element) => element.tenDauSach.toLowerCase().contains(searchText.toLowerCase())).toList();
                                                            }
                                                            return Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                                  child: TextField(
                                                                    controller: themDauSachController,
                                                                    decoration: InputDecoration(
                                                                      prefixIcon: const Padding(
                                                                        padding: EdgeInsets.only(
                                                                          right: 8,
                                                                        ),
                                                                        child: Icon(Icons.add_rounded),
                                                                      ),
                                                                      prefixIconConstraints: const BoxConstraints(
                                                                        maxWidth: 32,
                                                                      ),
                                                                      hintText: 'Thêm Đầu sách',
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        borderSide: BorderSide.none,
                                                                      ),
                                                                      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                                                                    ),
                                                                    onEditingComplete: () async {
                                                                      // Thêm Đầu sách mới vào Database
                                                                      DauSach newDauSach = DauSach(
                                                                        null,
                                                                        themDauSachController.text,
                                                                      );
                                                                      int returningId = await dbProcess.insertDauSach(newDauSach);
                                                                      newDauSach.id = returningId;
                                                                      setState(() {
                                                                        _dausachs.insert(0, newDauSach);
                                                                        themDauSachController.text = "";
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                                  child: TextField(
                                                                    controller: timTenDauSachController,
                                                                    decoration: InputDecoration(
                                                                      prefixIcon: const Padding(
                                                                        padding: EdgeInsets.only(
                                                                          right: 8,
                                                                        ),
                                                                        child: Icon(Icons.search),
                                                                      ),
                                                                      prefixIconConstraints: const BoxConstraints(
                                                                        maxWidth: 32,
                                                                      ),
                                                                      hintText: 'Tìm tên Đầu sách',
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        borderSide: BorderSide.none,
                                                                      ),
                                                                      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                                                                    ),
                                                                    onEditingComplete: () {
                                                                      setStateColumn(() {});
                                                                    },
                                                                    onChanged: (value) async {
                                                                      if (value.isEmpty) {
                                                                        await Future.delayed(const Duration(milliseconds: 50));
                                                                        setStateColumn(() {});
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: ListView(
                                                                    children: List.generate(
                                                                      filteredDauSachs.length,
                                                                      (index) => ListTile(
                                                                        onTap: () {
                                                                          setStateInWell(
                                                                            () => selectedIndex = index,
                                                                          );
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                        title: Text(filteredDauSachs[index].tenDauSach),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          barrierColor: Colors.transparent,
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                selectedIndex == -1 ? "" : filteredDauSachs[selectedIndex].tenDauSach,
                                              ),
                                            ),
                                            const Icon(Icons.arrow_drop_down)
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 14),
                                LabelTextFormField(
                                  labelText: 'Lần tái bản',
                                ),
                                const SizedBox(height: 14),
                                LabelTextFormField(
                                  labelText: 'Nhà xuất bản',
                                ),
                                const Spacer(),
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
                                        horizontal: 20,
                                      ),
                                    ),
                                    child: const Text('Thêm'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(0),
            child: SizedBox(
              width: double.infinity,
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
                            widget.editEnterBookDetail == null ? 'THÊM CHI TIẾT NHẬP SÁCH' : 'SỬA CHI TIẾT NHẬP SÁCH',
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
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: LabelTextFormField(
                              labelText: 'Mã Sách',
                              controller: _soLuongController,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: LabelTextFormField(
                              labelText: 'Số lượng',
                              controller: _soLuongController,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: LabelTextFormField(
                              labelText: 'Đơn Giá',
                              controller: _donGiaController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _isProcessing
                          ? const SizedBox(
                              height: 44,
                              width: 44,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FilledButton(
                                  onPressed: () {},
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 20,
                                    ),
                                  ),
                                  child: const Text(
                                    'Thêm và Đóng',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () {},
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 20,
                                    ),
                                  ),
                                  child: const Text(
                                    'Thêm tiếp',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
