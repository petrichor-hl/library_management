import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LabelTextFieldDatePicker extends StatelessWidget {
  const LabelTextFieldDatePicker({
    super.key,
    required this.labelText,
    required this.controller,
  });

  final String labelText;
  final TextEditingController controller;

  Future<void> openDatePicker(BuildContext context) async {
    DateTime? chosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (chosenDate != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(chosenDate);
    }
  }

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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => openDatePicker(context),
                child: TextFormField(
                  controller: controller,
                  enabled: false,
                  mouseCursor: SystemMouseCursors.click,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 245, 246, 250),
                    hintText: 'dd/MM/yyyy',
                    hintStyle: const TextStyle(color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.all(14),
                    isCollapsed: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bạn chưa nhập $labelText'; // 68 44
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () => openDatePicker(context),
              icon: const Icon(Icons.calendar_today),
              padding: const EdgeInsets.all(10),
            ),
          ],
        ),
      ],
    );
  }
}
