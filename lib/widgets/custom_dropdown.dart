import 'package:flutter/material.dart';
import 'package:tes_coding/extension/string_extension.dart';

class CustomDropdown extends StatefulWidget {
  final String title;
  final List<DropdownMenuEntry> dropdownMenuEntries;
  final TextEditingController controller;
  final Function onChange;
  final bool buttonPressed;
  const CustomDropdown(
      {super.key,
      required this.title,
      required this.dropdownMenuEntries,
      required this.controller,
      required this.onChange,
      required this.buttonPressed});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
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
          child: DropdownMenu(
            onSelected: (value) {
              widget.onChange(value);
            },
            width: MediaQuery.of(context).size.width - 40,
            hintText: "${widget.title.capitalizeFirstLetter()}",
            controller: widget.controller,
            dropdownMenuEntries: widget.dropdownMenuEntries,
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
                height: 13,
              ),
      ],
    );
  }
}
