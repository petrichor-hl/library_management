import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  final TextEditingController controller;
  final void Function() onSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.search),
              ),
              prefixIconColor: const Color.fromARGB(255, 81, 81, 81),
              hintText: 'Tìm kiếm',
              hintStyle: const TextStyle(
                color: Color.fromARGB(255, 81, 81, 81),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            ),
            onEditingComplete: onSearch,
            onChanged: (value) async {
              if (value.isEmpty) {
                await Future.delayed(
                  const Duration(milliseconds: 50),
                );
                onSearch();
              }
            },
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        FilledButton(
          onPressed: () => onSearch(),
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 38),
          ),
          child: const Icon(Icons.search),
        )
      ],
    );
  }
}
