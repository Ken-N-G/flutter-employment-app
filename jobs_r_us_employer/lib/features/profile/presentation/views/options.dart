import 'package:flutter/material.dart';
import 'package:jobs_r_us_employer/core/navigation/routes.dart';
import 'package:jobs_r_us_employer/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryTextButton.dart';
import 'package:jobs_r_us_employer/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: SubPageAppBar(
        onBackTap: () {
          Navigator.pop(context);
        },
        title: "Account Settings",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Account",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 20,),

              Center(
                child: SecondaryTextButton(
                  label: "Sign Out",
                   onTap: () async{
                    await authProvider.signOutUser();
                    if (context.mounted) {
                      Navigator.popUntil(context, ModalRoute.withName(ScreenRoutes.signIn.route));
                    }
                   }
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}