import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us_employer/general_widgets/customFieldButton.dart';
import 'package:jobs_r_us_employer/general_widgets/customTextFormField.dart';

class EducationForm extends StatelessWidget {
  EducationForm({
    super.key,
    required this.institutionController,
    this.institutionValidator,
    required this.qualificationsController,
    this.qualificationsValidator,
    required this.locationController,
    this.locationValidator,
    required this.startDateController,
    this.startDateValidator,
    required this.endDateController,
    this.endDateValidator,
    this.startDate,
    this.endDate,
    required this.onStartDateTap,
    required this.onEndDateTap,
    this.readOnly = false,
  });

  final TextEditingController institutionController;
  final TextEditingController qualificationsController;
  final TextEditingController locationController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;

  final String? Function(String?)? institutionValidator;
  final String? Function(String?)? qualificationsValidator;
  final String? Function(String?)? locationValidator;
  final String? Function(String?)? startDateValidator;
  final String? Function(String?)? endDateValidator;

  final  DateTime? startDate;
  final  DateTime? endDate;

  final Function() onStartDateTap;
  final Function() onEndDateTap;

  final bool readOnly;

  final DateFormat formatter = DateFormat("d MMM yyyy");

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          readOnly: readOnly,
          label: "Institution",
          controller: institutionController,
        ),

        const SizedBox(height: 10,),

        CustomTextFormField(
          readOnly: readOnly,
          label: "Last Highest Qualification",
          controller: qualificationsController,
        ),

        const SizedBox(height: 10,),

        CustomTextFormField(
          readOnly: readOnly,
          label: "Location",
          keyboardInput: TextInputType.multiline,
          controller: locationController,
        ),

        const SizedBox(height: 10,),

        Row(
          children: [
            Expanded(
              child: CustomFieldButton(
                label: "Start Date",
                controller: startDateController,
                defaultInnerLabel: (startDateController.text.isNotEmpty) ? formatter.format(startDate!) : "Select Date",
                suffixIcon: const Icon(
                  Icons.calendar_month_rounded
                ),
                onFieldTap: readOnly ? null : onStartDateTap,
              ),
            ),

            const SizedBox(width: 10,),
            
            Expanded(
              child: CustomFieldButton(
                label: "Start End",
                  controller: endDateController,
                  defaultInnerLabel: (endDateController.text.isNotEmpty) ? formatter.format(endDate!) : "Select Date",
                  suffixIcon: const Icon(
                    Icons.calendar_month_rounded
                  ),
                  onFieldTap: readOnly ? null : onEndDateTap,
                ),
            ),
          ],
        ),
      ],
    );
  }
}