import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_r_us/features/career_materials/domain/careerProvider.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class CareerArticle extends StatelessWidget {
  CareerArticle({super.key});

  final DateFormat formatter = DateFormat("d MMM yyyy");

  Widget setBody(CareerProvider careerProvider, BuildContext context) {
    List<Widget> entries = [];

    for (int x = 0; x < careerProvider.selectedArticle.bodyHeaders.length; x++) {
      entries.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            careerProvider.selectedArticle.bodyHeaders[x],
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 20,),
          
          Text(
          careerProvider.selectedArticle.bodyContent[x],
          style: Theme.of(context)
                .textTheme
                .bodyMedium
        ),
        
        const SizedBox(height: 30,)
        ],
      ));
    }

    return Column(
      children: entries,
    );
  }

  @override
  Widget build(BuildContext context) {  
    final careerProvider = Provider.of<CareerProvider>(context);

    return Scaffold(
      appBar: SubPageAppBar(
        onBackTap: () {
          Navigator.pop(context);
        },
        title: "Artikel Karir",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5,),
        
                Text(
                  careerProvider.selectedArticle.articleTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 10,),

                Row(
                  children: [
                    Icon(
                      Icons.person_rounded,
                      color: Theme.of(context).colorScheme.outline,
                    ),

                    const SizedBox(width: 10,),

                    Text(
                  careerProvider.selectedArticle.author,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.outline
                  ),
                ),
                  ],
                ),

                const SizedBox(height: 10,),

                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: Theme.of(context).colorScheme.outline,
                    ),

                    const SizedBox(width: 10,),

                    Text(
                  formatter.format(careerProvider.selectedArticle.dateUploaded),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.outline
                  ),
                ),
                  ],
                ),
        
                const SizedBox(height: 30,),

                Text(
                  careerProvider.selectedArticle.introduction,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 30,),

                setBody(careerProvider, context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}