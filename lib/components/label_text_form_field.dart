import 'package:flutter/material.dart';

class LabelTextFormField extends StatelessWidget {
  const LabelTextFormField({
    super.key,
    required this.labelText,
    this.controller,
    this.isEnable = true,
    this.hint = "",
  });

  final String labelText;
  final TextEditingController? controller;
  final bool isEnable;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          enabled: isEnable,
          decoration: InputDecoration(
            filled: true,
            fillColor: isEnable
                ? const Color.fromARGB(255, 245, 246, 250)
                : const Color(0xffEFEFEF),
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF888888)),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(14),
            isCollapsed: true,
            // isDense: true,
          ),
        ),
      ],
    );
  }
}
