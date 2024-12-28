import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shandynotes/sections/bannerSection.dart';
import 'package:shandynotes/sections/commonQueriesSection.dart';
import 'package:shandynotes/sections/footerSection.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sections/LatestReleaseSection.dart';
import '../sections/categorySection.dart';
import '../sections/featuredSection.dart';
import '../sections/popularSection.dart';
import '../sections/procedure_to_create_notes.dart';
import '../widgets/appbarWidgets.dart';
import '../widgets/navigationDrawer.dart';
import '../widgets/quoteBox.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          const url =
              'https://wa.me/9113315775'; // Replace with your WhatsApp number
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          } else {
            throw 'Could not launch $url';
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ), // Customize the color as needed
      ),
      appBar: const ModernNavBar(),
      endDrawer: MediaQuery.of(context).size.width < 420
          ? const MyNavigationDrawer()
          : null,
      body: ListView(
        shrinkWrap: true,
        children: [
          const BannerSection(),

          // Category Section
          Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 80.0,
                      bottom: 20,
                    ),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          color: Colors.white),
                    ),
                  ),
                  CategorySection()
                ],
              )),
          // Latest Release Section
          Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Text(
                          'Latest Release Notes',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: ElevatedButton(
                            child: const Row(
                              children: [
                                Text("View all"),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                )
                              ],
                            ),
                            onPressed: () => context.go('/shop'),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Center(child: LatestMainScreen()),
                ],
              )),

          // Popular Section
          Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Text(
                          'Popular Notes',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: ElevatedButton(
                            child: const Row(
                              children: [
                                Text("View all"),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                )
                              ],
                            ),
                            onPressed: () => context.go('/shop'),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const PopularMainScreen(),
                ],
              )),

          // Featured Section
          Expanded(
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.deepPurpleAccent,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          const Text(
                            'Featured Notes',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: ElevatedButton(
                              child: const Row(
                                children: [
                                  Text("View all"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                  )
                                ],
                              ),
                              onPressed: () => context.go('/shop'),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const FeaturedMainScreen(), // {{ edit_1 }} Check data fetching and rendering here
                    const SizedBox(
                      height: 100,
                    )
                  ],
                )),
          ),
          // Procedure of creating notes
          const ProcedureToCreateNotes(),

          //Quote Section
          const QuoteBox(),

          // Common Queries Section
          const CommonQueries(),

          //footer Section
          const Expanded(child: Footer()),
        ],
      ),
    );
  }
}
