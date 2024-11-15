import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty_test/app/modules/home/widgets/home_body.dart';
import 'package:tentwenty_test/app/providers/home_provider/home_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 4,
          title: Consumer<HomeProvider>(
            builder: (context, searchProvider, child) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: child,
                    ),
                  );
                },
                child: searchProvider.isSearching
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          key: const ValueKey(1),
                          onChanged: (s) {
                            searchProvider.update();
                          },
                          controller: searchProvider.searchController,
                          autofocus: true,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "tv Shows, movies and more",
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.black),
                            suffixIcon: IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.black),
                              onPressed: () {
                                searchProvider.closeSearch();
                                searchProvider.searchController.clear();
                              },
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    : const Row(
                        key: ValueKey(2),
                        children: [
                          Text(
                            "Watch",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
              );
            },
          ),
          actions: [
            Consumer<HomeProvider>(
              builder: (context, searchProvider, child) {
                return searchProvider.isSearching
                    ? Container()
                    : IconButton(
                        icon: const Icon(Icons.search, color: Colors.black),
                        onPressed: searchProvider.toggleSearch,
                      );
              },
            ),
          ],
        ),
      ),
      body: const HomeBody(),
    );
  }
}
