import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 245, 246, 250),
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
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
          ),
          child: const Icon(Icons.search),
        )
      ],
    );
  }
}
