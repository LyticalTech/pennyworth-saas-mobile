import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residents/components/input_label.dart';

class LabelledDateTimePicker extends StatelessWidget {
  LabelledDateTimePicker({
    Key? key,
    required this.label,
    required this.controller,
    this.initialDate,
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputLabel(title: label),
        DateTimeField(
          format: format,
          controller: controller,
          initialValue: initialDate ?? DateTime.now(),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: Colors.black54,
              ),
            ),
          ),
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
              context: context,
              initialDate: initialDate ?? DateTime.now(),
              firstDate: initialDate ??
                  DateTime.now().subtract(
                    Duration(days: 30),
                  ),
              lastDate: DateTime.now().add(Duration(days: 90)),
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(
                  currentValue ?? DateTime.now(),
                ),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
        ),
      ],
    );
  }
}
