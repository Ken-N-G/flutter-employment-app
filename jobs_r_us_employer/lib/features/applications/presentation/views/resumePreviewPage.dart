import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/features/applications/domain/applicationProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us_employer/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class ResumePreview extends StatelessWidget {
  const ResumePreview({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final applicationProvider = Provider.of<ApplicationProvider>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: SubPageAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
            title: "Preview Resume",
          ),
          body: applicationProvider.resumeStatus == ApplyStatus.retrieving ? 
          const CustomLoadingOverlay() : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: PDFViewer(
              document: applicationProvider.document!,
            ),
          ),
        ),
      ],
    );
  }
}