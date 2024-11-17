import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomFieldButton extends StatelessWidget {
  const CustomFieldButton({
    super.key,
    required this.label,
    required this.defaultInnerLabel,
    required this.suffixIcon,
    this.onFieldTap,
    this.controller,
    this.validator,
  });

  final String label;
  final String defaultInnerLabel;
  final Widget suffixIcon;
  final Function()? onFieldTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

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

        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onFieldTap,
          child: TextFormField( 
            validator: validator,
            controller: controller,
            style: Theme.of(context).textTheme.bodyLarge,
            enabled: false,
            decoration: InputDecoration(
              isDense: true,
              hintText: defaultInnerLabel,
              hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.outline
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline
                ),
                borderRadius: BorderRadius.circular(16)
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error
                ),
                borderRadius: BorderRadius.circular(16)
              ),
              suffixIcon: suffixIcon,
              suffixIconColor: Theme.of(context).colorScheme.onBackground
            ),
          ),
        ),
      ],
    );
  }
}