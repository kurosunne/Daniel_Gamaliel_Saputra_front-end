import 'package:flutter/material.dart';
import 'package:tes_coding/extension/string_extension.dart';

class CustomTextfield extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool buttonPressed;
  final Function onChanged;
  const CustomTextfield(
      {super.key,
      required this.title,
      required this.controller,
      required this.keyboardType,
      required this.buttonPressed,
      required this.onChanged});

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${widget.title}*",
            style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: 55,
          child: TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
                hintText: "Masukkan ${widget.title.toLowerCase()}"),
            onChanged: (value) {
              widget.onChanged(value);
            },
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        widget.buttonPressed && widget.controller.text.isEmpty
            ? Row(
                children: [
                  Icon(
                    Icons.warning,
                    size: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text("${widget.title.capitalizeFirstLetter()} belum diisi",
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.error))
                ],
              )
            : const SizedBox(
                height: 12,
              ),
      ],
    );
  }
}
