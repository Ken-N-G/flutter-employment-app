import 'package:flutter/material.dart';
import 'package:jobs_r_us/core/navigation/routes.dart';
import 'package:jobs_r_us/features/authentication/domain/authProvider.dart';
import 'package:jobs_r_us/features/view_employers/domain/employerProvider.dart';
import 'package:jobs_r_us/features/view_employers/presentation/widgets/employerCard.dart';
import 'package:jobs_r_us/general_widgets/customDropdownMenu.dart';
import 'package:jobs_r_us/general_widgets/customLoadingOverlay.dart';
import 'package:jobs_r_us/general_widgets/customSearchField.dart';
import 'package:jobs_r_us/general_widgets/secondaryButton.dart';
import 'package:jobs_r_us/general_widgets/subPageAppBar.dart';
import 'package:provider/provider.dart';

class Employers extends StatefulWidget {
  const Employers({super.key});

  @override
  State<Employers> createState() => _EmployersState();
}

class _EmployersState extends State<Employers> {
  List<String> searchFilters = ["Date Joined", "Name"];
  List<String> orderFilters = [
    "Descending",
    "Ascending",
  ];
  List<String> typeFilters = ["All", "Micro", "Small", "Medium"];
  EmployerSearchOrder filter = EmployerSearchOrder.dateJoined;
  EmployerType typeFilter = EmployerType.all;
  bool isDescending = true;

  late TextEditingController searchController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
    Future.microtask(() {
      var employerProvider = Provider.of<EmployerProvider>(context, listen: false);
      employerProvider.resetSearch();
      employerProvider.getAllEmployers();
    });

  }

  @override
  Widget build(BuildContext context) {
    final employerProvider = Provider.of<EmployerProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: SubPageAppBar(
        onBackTap: () {
          Navigator.pop(context);
        },
        title: "Employers",
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
                      hintText: "Search employer",
                      controller: searchController,
                      onSubmitted: (searchKey) async {
                        employerProvider.getEmployersWithQuery(
                            searchKey.trim(), filter, typeFilter, isDescending);
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
                        employerProvider.getEmployersWithQuery(
                            searchController.text.trim(),
                            filter,
                            typeFilter,
                            isDescending);
                      })
                ]),
                const SizedBox(
                  height: 10,
                ),
                Row(children: [
                  CustomDropdownMenu(
                    initialSelection: searchFilters.first,
                    entries: <DropdownMenuEntry<String>>[
                      DropdownMenuEntry(
                          value: searchFilters[0], label: searchFilters[0]),
                      DropdownMenuEntry(
                          value: searchFilters[1], label: searchFilters[1]),
                    ],
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      switch (value) {
                        case "Name":
                          filter = EmployerSearchOrder.name;
                          break;
                        case "Date Joined":
                          filter = EmployerSearchOrder.dateJoined;
                          break;
                      }
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomDropdownMenu(
                    initialSelection: orderFilters.first,
                    entries: <DropdownMenuEntry<String>>[
                      DropdownMenuEntry(
                          value: orderFilters[0], label: orderFilters[0]),
                      DropdownMenuEntry(
                          value: orderFilters[1], label: orderFilters[1]),
                    ],
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      switch (value) {
                        case "Ascending":
                          isDescending = false;
                          break;
                        case "Descending":
                          isDescending = true;
                          break;
                      }
                    },
                  ),
                ]),
                const SizedBox(
                  height: 10,
                ),
                CustomDropdownMenu(
                  initialSelection: typeFilters.first,
                  entries: <DropdownMenuEntry<String>>[
                    DropdownMenuEntry(
                        value: typeFilters[0], label: typeFilters[0]),
                    DropdownMenuEntry(
                        value: typeFilters[1], label: typeFilters[1]),
                    DropdownMenuEntry(
                        value: typeFilters[2], label: typeFilters[2]),
                    DropdownMenuEntry(
                        value: typeFilters[3], label: typeFilters[3]),
                  ],
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    switch (value) {
                      case "All":
                        typeFilter = EmployerType.all;
                        break;
                      case "Micro":
                        typeFilter = EmployerType.micro;
                        break;
                      case "Small":
                        typeFilter = EmployerType.small;
                        break;
                      case "Medium":
                        typeFilter = EmployerType.medium;
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
              child: employerProvider.employerStatus ==
                      EmployerStatus.retrieving
                  ? const Center(
                      child: CustomLoadingOverlay(),
                    )
                  : employerProvider.searchStatus == EmployerStatus.unloaded
                      ? ListView.builder(
                          itemCount: employerProvider.allEmployerList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: EmployerCard(
                                name: employerProvider
                                    .allEmployerList[index].name,
                                type: employerProvider
                                    .allEmployerList[index].type,
                                address: employerProvider
                                    .allEmployerList[index].businessAddress,
                                profileUrl: employerProvider
                                    .allEmployerList[index].profileUrl,
                                dateJoined: employerProvider
                                    .allEmployerList[index].dateJoined,
                                onCardTap: () async {
                                  await employerProvider.setSelectedEmployer(employerProvider.allEmployerList[index].id, authProvider.currentUser?.uid ?? "");
                                  if (context.mounted) {
                                    Navigator.pushNamed(context, ScreenRoutes.employerDetails.route);
                                  }
                                },
                              ),
                            );
                          })
                      : employerProvider.searchStatus ==
                              EmployerStatus.retrieving
                          ? const Center(
                              child: CustomLoadingOverlay(),
                            )
                          : employerProvider.searchedEmployerList.isNotEmpty
                              ? ListView.builder(
                                  itemCount: employerProvider
                                      .searchedEmployerList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: EmployerCard(
                                        name: employerProvider
                                            .searchedEmployerList[index].name,
                                        type: employerProvider
                                            .searchedEmployerList[index].type,
                                        address: employerProvider
                                            .searchedEmployerList[index]
                                            .businessAddress,
                                        profileUrl: employerProvider
                                            .searchedEmployerList[index]
                                            .profileUrl,
                                        dateJoined: employerProvider
                                            .searchedEmployerList[index]
                                            .dateJoined,
                                        onCardTap: () async {
                                          await employerProvider.setSelectedEmployer(employerProvider.searchedEmployerList[index].id, authProvider.currentUser?.uid ?? "");
                                          if (context.mounted) {
                                            Navigator.pushNamed(context, ScreenRoutes.employerDetails.route);
                                          }
                                        },
                                      ),
                                    );
                                  })
                              : Center(
                                  child: Text(
                                    "There are no employers that match your search",
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
