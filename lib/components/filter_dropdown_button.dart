import 'package:flutter/material.dart';

class FilterDropDownButton extends StatelessWidget {
  const FilterDropDownButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
          color: Colors.white,
          child: const Icon(
            Icons.filter_list,
          ),
        ),
        const SizedBox(
          height: 30,
          width: 1,
          child: ColoredBox(color: Colors.black),
        ),
        SizedBox(
          width: 150,
          child: DropdownButtonFormField(
            value: 1,
            items: const [
              DropdownMenuItem(value: 0, child: Text('Tất cả')),
              DropdownMenuItem(value: 1, child: Text('Còn hạn')),
              DropdownMenuItem(value: 2, child: Text('Quá hạn')),
            ],
            onChanged: (value) {},
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(0),
              ),
              contentPadding: const EdgeInsets.all(14),
              isCollapsed: true,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
