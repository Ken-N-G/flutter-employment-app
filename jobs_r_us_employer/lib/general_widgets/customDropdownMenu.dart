import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  const CustomDropdownMenu({
    super.key,
    required this.initialSelection,
    required this.entries,
    required this.onSelected
  });

  final void Function(String?)? onSelected;
  final List<DropdownMenuEntry<String>> entries;
  final String initialSelection;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        helperStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.outline
        ),
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.outline
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(16)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline
          ),
        )
      ),
      initialSelection: initialSelection,
      dropdownMenuEntries: entries,
      onSelected: onSelected,
    );
  }
}