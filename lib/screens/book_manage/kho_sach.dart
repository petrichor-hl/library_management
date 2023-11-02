import 'package:flutter/material.dart';
import 'package:library_management/components/my_search_bar.dart';
import 'package:library_management/screens/book_manage/book_manage.dart';

extension KhoSach on BookManageState {
  Widget buildKhoSach() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MySearchBar(
            controller: searchController,
            onSearch: () {},
          ),
          const SizedBox(height: 20),
          const Text(
            'Danh sách Sách',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Expanded(
            child: Row(
              children: [
                Expanded(child: Text('Đầu sách')),
                Expanded(
                  flex: 2,
                  child: Text('Sách'),
                ),
                Expanded(child: Text('Cuốn sách')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
