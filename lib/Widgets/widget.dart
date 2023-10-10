import 'package:flutter/material.dart';

void showSnackBar(String message,BuildContext context,IconData iconData, Color iconColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const SizedBox(width: 8),
          Icon(iconData,color: iconColor,),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 2),
    ),
  );
}
class BorderedTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final int maxContentLines;
  final TextEditingController fieldController;

  const BorderedTextField(
      {super.key, required this.hintText,
        required this.labelText,
        required this.fieldController,
        required this.maxContentLines});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: TextField(
          maxLines: maxContentLines,
          controller: fieldController,
          decoration: InputDecoration(
              alignLabelWithHint: true,
              hintText: hintText,
              labelText: labelText,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        ));
  }
}

