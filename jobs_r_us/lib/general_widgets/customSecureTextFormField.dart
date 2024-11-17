import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSecureTextFormField extends StatelessWidget {
  const CustomSecureTextFormField({
    super.key,
    required this.label,
    required this.obscureText,
    required this.onRevealTap,
    this.controller,
    this.validator,
    this.keyboardInput,
    this.helperText,
    }
  );

  final String label;
  final bool obscureText;
  final Function() onRevealTap;
  final TextInputType? keyboardInput;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? helperText;

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
          style: Theme.of(context).textTheme.bodyLarge,
          keyboardType: keyboardInput,
          obscureText: obscureText,
          validator: validator,
          controller: controller,
          maxLengthEnforcement: MaxLengthEnforcement.none,
          decoration: InputDecoration(
            isDense: true,
            helperText: helperText,
              helperStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.outline
              ),
            hintText: label,
            hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.outline
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(16)),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline
              ),
              borderRadius: BorderRadius.circular(16)
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded
              ),
              color: Theme.of(context).colorScheme.onBackground,
              onPressed: onRevealTap
            )
          ),
        ),
      ],
    );
  }
}