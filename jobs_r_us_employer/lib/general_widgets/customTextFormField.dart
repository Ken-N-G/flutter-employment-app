import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    this.validator,
    this.prefixLabel = "",
    this.keyboardInput,
    this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly= false,
    this.helperText,
    this.enabled = true
    }
  );

  final String label;
  final String prefixLabel;
  final TextInputType? keyboardInput;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? maxLength;
  final String? helperText;
  final bool readOnly;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 5,),
        
        TextFormField(
          enabled: enabled,
          style: Theme.of(context).textTheme.bodyLarge,
          controller: controller, 
          keyboardType: keyboardInput,
          validator: validator,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          decoration: InputDecoration(
              isDense: true,
              hintText: label,
              helperText: helperText,
              helperStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.outline
              ),
              prefixIcon: (prefixLabel != "") ?
               Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Text(
                    prefixLabel,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ) :
                null,
                prefixIconConstraints: (prefixLabel != "") ?
                  BoxConstraints(minHeight: 0,) :
                  null,
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
              )),
        ),
      ],
    );
  }
}
