import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/themed_loading.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/models/place_era.dart';
import 'package:timeexplorer/features/places/presentation/cubit/places_list_cubit.dart';
import 'package:timeexplorer/features/places/presentation/cubit/places_list_state.dart';
import 'package:timeexplorer/features/places/presentation/widgets/place_card.dart';
import 'package:timeexplorer/features/places/presentation/widgets/progress_header.dart';

class PlacesListPage extends StatefulWidget {
  const PlacesListPage({super.key});

  @override
  State<PlacesListPage> createState() => _PlacesListPageState();
}

class _PlacesListPageState extends State<PlacesListPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  PlaceEra? _selectedEra;

  @override
  void initState() {
    super.initState();
    context.read<PlacesListCubit>().fetchPlaces();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  void _onEraSelected(PlaceEra? era) {
    setState(() {
      _selectedEra = era == _selectedEra ? null : era; // toggle off if same selected
    });
  }

  List<Place> _applyFilters(List<Place> places) {
    var filtered = places;
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) => p.name.toLowerCase().contains(_searchQuery)).toList();
    }
    if (_selectedEra != null) {
      filtered = filtered.where((p) => p.eraEnum == _selectedEra).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: BlocBuilder<PlacesListCubit, PlacesListState>(
          builder: (context, state) {
            if (state is PlacesListLoading) {
              return const ThemedLoading(context: 'events');
            }
            if (state is PlacesListError) {
              return Center(
                child: Text(state.message, style: GoogleFonts.plusJakartaSans(color: Colors.redAccent)),
              );
            }
            if (state is PlacesListLoaded) {
              final allPlaces = state.allPlaces;
              final filteredPlaces = _applyFilters(allPlaces);

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: ProgressHeader(
                      totalPlaces: allPlaces.length,
                      knownPlaceIds: allPlaces.map((p) => p.id).toSet(),
                    ),
                  ),
                  // Search bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search places…',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: AppTheme.surfaceLow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Era filter chips
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 48,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: PlaceEra.values.map((era) {
                          final isSelected = _selectedEra == era;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(era.value),
                              selected: isSelected,
                              onSelected: (_) => _onEraSelected(era),
                              selectedColor: AppTheme.primaryElectric,
                              backgroundColor: AppTheme.surfaceLow,
                              labelStyle: GoogleFonts.plusJakartaSans(
                                color: isSelected ? Colors.white : AppTheme.textHighContrast,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // Grid of places
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final place = filteredPlaces[index];
                          return PlaceListCard(place: place);
                        },
                        childCount: filteredPlaces.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
