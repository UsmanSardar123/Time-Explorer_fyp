import 'package:flutter/material.dart';
import 'package:timeexplorer/features/explore/presentation/pages/explore_page.dart';

class ExplorePlacesScreen extends StatelessWidget {
  const ExplorePlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We already redesigned the ExplorePage in a unified way. 
    // To maintain consistency, we will use the master ExplorePage here as well.
    return const ExplorePage();
  }
}
