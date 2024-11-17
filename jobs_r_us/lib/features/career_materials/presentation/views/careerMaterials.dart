import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/career_materials/domain/careerProvider.dart';
import 'package:jobs_r_us/features/career_materials/presentation/widgets/careerCard.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/customSearchField.dart';
import 'package:jobs_r_us/general_widgets/secondaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class CareerMaterials extends StatefulWidget {
  const CareerMaterials({super.key});

  @override
  State<CareerMaterials> createState() => _CareerMaterialsState();
}

class _CareerMaterialsState extends State<CareerMaterials> {
  late TextEditingController searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
    Future.microtask(() {
      final applicationProvider =
          Provider.of<CareerProvider>(context, listen: false);
      applicationProvider.resetSearch();
      applicationProvider.getAllArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final careerProvider = Provider.of<CareerProvider>(context);

    return Scaffold(
      appBar: SubPageAppBar(
        onBackTap: () {
          Navigator.pop(context);
        },
        title: "Career Articles",
      ),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: CustomSearchField(
                      hintText: "Search career articles",
                      controller: searchController,
                      onSubmitted: (searchKey) async {
                        careerProvider.getArticleWithQuery(searchKey.trim());
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SecondaryButton(
                      child: Icon(
                        Icons.search_rounded,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        careerProvider
                            .getArticleWithQuery(searchController.text.trim());
                      })
                ]),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
              child: careerProvider.careerStatus == CareerStatus.retrieving
                  ? const Center(
                      child: CustomLoadingOverlay(),
                    )
                  : careerProvider.searchStatus == CareerStatus.unloaded
                      ? ListView.builder(
                          itemCount: careerProvider.careerArticles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: CareerCard(
                                name: careerProvider
                                    .careerArticles[index].articleTitle,
                                author:
                                    careerProvider.careerArticles[index].author,
                                onCardTap: () {
                                  careerProvider.setSelectedArticle(
                                      careerProvider.careerArticles[index].id);
                                  Navigator.pushNamed(context,
                                      ScreenRoutes.careerArticle.route);
                                },
                              ),
                            );
                          })
                      : careerProvider.searchStatus == CareerStatus.retrieving
                          ? const Center(
                              child: CustomLoadingOverlay(),
                            )
                          : careerProvider.searchedArticles.isNotEmpty
                              ? ListView.builder(
                                  itemCount:
                                      careerProvider.searchedArticles.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: CareerCard(
                                        name: careerProvider
                                            .searchedArticles[index]
                                            .articleTitle,
                                        author: careerProvider
                                            .searchedArticles[index].author,
                                        onCardTap: () {
                                          careerProvider.setSelectedArticle(
                                              careerProvider
                                                  .searchedArticles[index].id);
                                          Navigator.pushNamed(context,
                                              ScreenRoutes.careerArticle.route);
                                        },
                                      ),
                                    );
                                  })
                              : Center(
                                  child: Text(
                                    "Tidak ada artikel karir yang Anda cari",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ))
        ]),
      ),
    );
  }
}
