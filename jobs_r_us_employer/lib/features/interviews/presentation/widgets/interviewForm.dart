import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us_employer/general_widgets/customFieldButton.dart';

class InterviewForm extends StatelessWidget {
  InterviewForm({
    super.key,
    required this.dateController,
    this.dateValidator,
    required this.timeController,
    this.timeValidator,
    this.date,
    this.time,
    required this.onDateTap,
    required this.onTimeTap,
    this.readOnly = false,
  });

  final TextEditingController dateController;
  final TextEditingController timeController;

  final String? Function(String?)? dateValidator;
  final String? Function(String?)? timeValidator;

  final  DateTime? date;
  final  TimeOfDay? time;

  final Function() onDateTap;
  final Function() onTimeTap;

  final bool readOnly;

  final DateFormat formatter = DateFormat("d MMM yyyy");

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomFieldButton(
            label: "Date",
            controller: dateController,
            validator: dateValidator,
            defaultInnerLabel: (dateController.text.isNotEmpty) ? formatter.format(date!) : "Select Date",
            suffixIcon: const Icon(
              Icons.calendar_month_rounded
            ),
            onFieldTap: readOnly ? null : onDateTap,
          ),
        ),
    
        const SizedBox(width: 10,),
        
        Expanded(
          child: CustomFieldButton(
            label: "Time",
              controller: timeController,
              validator: timeValidator,
              defaultInnerLabel: (timeController.text.isNotEmpty) ? "${time!.hour.toString()} : ${time!.hour.toString()}" : "Select Time",
              suffixIcon: const Icon(
                Icons.schedule_rounded
              ),
              onFieldTap: readOnly ? null : onTimeTap,
            ),
        ),
      ],
    );
  }
}