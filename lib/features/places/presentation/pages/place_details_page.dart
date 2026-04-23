import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeexplorer/features/places/data/datasources/places_remote_data_source.dart';
import 'package:timeexplorer/features/places/data/repositories/places_repository_impl.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/places/domain/usecases/get_nearby_places.dart';
import 'package:timeexplorer/features/places/domain/usecases/get_place_details.dart';
import 'package:timeexplorer/features/places/presentation/cubit/place_details_cubit.dart';
import 'package:timeexplorer/features/places/presentation/cubit/place_details_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/features/bookmarks/presentation/providers/bookmark_provider.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart' as explore;
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/core/widgets/tap_scale.dart';

class PlaceDetailsPage extends StatelessWidget {
  final String placeId;

  const PlaceDetailsPage({super.key, required this.placeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaceDetailsCubit(
        getPlaceDetails: GetPlaceDetailsUseCase(
          PlacesRepositoryImpl(remoteDataSource: PlacesRemoteDataSourceImpl()),
        ),
        getNearbyPlaces: GetNearbyPlacesUseCase(
          PlacesRepositoryImpl(remoteDataSource: PlacesRemoteDataSourceImpl()),
        ),
      )..loadPlaceDetails(placeId),
      child: BlocBuilder<PlaceDetailsCubit, PlaceDetailsState>(
        builder: (context, state) {
          if (state is PlaceDetailsInitial || state is PlaceDetailsLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is PlaceDetailsError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 20),
                    Text('Error: ${state.message}', textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.read<PlaceDetailsCubit>().loadPlaceDetails(placeId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is PlaceDetailsLoaded) {
            final place = state.place;
            final images = place.images ?? [];

            return Scaffold(
              backgroundColor: AppTheme.scaffoldBackgroundColor,
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(context, place),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAnimatedSection(child: _buildHistoricHeader(place), delay: 0),
                          const SizedBox(height: 32),
                          _buildAnimatedSection(child: _buildSectionTitle('Overview'), delay: 100),
                          const SizedBox(height: 12),
                          _buildAnimatedSection(child: _buildHistoricalOverview(place), delay: 200),
                          const SizedBox(height: 32),
                          if (images.isNotEmpty) ...[
                            _buildAnimatedSection(child: _buildSectionTitle('Visual Gallery'), delay: 300),
                            const SizedBox(height: 16),
                            _buildAnimatedSection(child: _buildImageGallery(place), delay: 400),
                            const SizedBox(height: 32),
                          ],
                          if (place.timeline != null && place.timeline!.isNotEmpty) ...[
                            _buildAnimatedSection(child: _buildSectionTitle('Historical Timeline'), delay: 500),
                            const SizedBox(height: 16),
                            _buildAnimatedSection(child: _buildTimeline(place), delay: 600),
                            const SizedBox(height: 32),
                          ],
                          _buildAnimatedSection(child: _buildSectionTitle('Quick Facts'), delay: 700),
                          const SizedBox(height: 16),
                          _buildAnimatedSection(child: _buildInfoGrid(place), delay: 800),
                          const SizedBox(height: 32),
                          if (place.significance != null || place.historicalSignificance != null) ...[
                            _buildAnimatedSection(child: _buildSectionTitle('Historical Significance'), delay: 900),
                            const SizedBox(height: 12),
                            _buildAnimatedSection(child: _buildSignificanceCard(place), delay: 1000),
                            const SizedBox(height: 32),
                          ],
                          if (place.facts != null && place.facts!.isNotEmpty) ...[
                            _buildAnimatedSection(child: _buildSectionTitle('Did You Know?'), delay: 1100),
                            const SizedBox(height: 16),
                            _buildAnimatedSection(child: _buildFunFactsList(place), delay: 1200),
                            const SizedBox(height: 32),
                          ],
                          _buildAnimatedSection(child: _buildSectionTitle('Knowledge Check'), delay: 1300),
                          const SizedBox(height: 16),
                          _buildAnimatedSection(child: _buildQuizSection(place), delay: 1400),
                          const SizedBox(height: 32),
                          _buildAnimatedSection(child: _buildMapIntegration(place), delay: 1500),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Scaffold(body: SizedBox.shrink());
        },
      ),
    );
  }

  Widget _buildAnimatedSection({required Widget child, required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Place place) {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      elevation: 0,
      backgroundColor: AppTheme.deepNavy,
      leading: TapScale(
        scale: 0.85,
        haptic: true,
        onTap: () => context.pop(),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: null,
        ),
      ),
      actions: [
        Consumer<BookmarkProvider>(
          builder: (context, bookmarkProvider, child) {
            final isSaved = bookmarkProvider.isBookmarked(place.id);
            return TapScale(
              scale: 0.82,
              haptic: true,
              onTap: () {
                final entity = explore.PlaceEntity(
                  id: place.id,
                  name: place.name,
                  description: place.description,
                  imageUrl: place.imageUrl,
                  category: place.category,
                  location: place.location,
                  rating: place.rating,
                );
                bookmarkProvider.toggleBookmark(entity);
              },
              child: IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isSaved ? AppTheme.accentOrange : Colors.white,
                ),
                onPressed: null,
              ),
            );
          },
        ),
        TapScale(
          scale: 0.82,
          haptic: true,
          onTap: () => Share.share(
            'Explore the secrets of ${place.name} with me on Time Explorer! 🏛️✨\n\nLocation: ${place.location}\nEra: ${place.era ?? place.category}',
            subject: 'Check out ${place.name} on Time Explorer',
          ),
          child: const IconButton(
            icon: Icon(Icons.share_rounded, color: Colors.white),
            onPressed: null,
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'place-hero-${place.id}',
              child: CachedNetworkImage(
                imageUrl: place.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFFE5E7EB),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFFF3F4F6),
                  child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 40),
                ),
              ),
            ),
            // Multi-layered gradient for depth and readability
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 1.0],
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      place.category.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    place.name,
                    style: GoogleFonts.merriweather(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        place.location,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF111827),
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildHistoricalOverview(Place place) {
    return Text(
      place.history ?? place.description,
      style: GoogleFonts.poppins(
        fontSize: 15,
        height: 1.7,
        color: const Color(0xFF4B5563),
      ),
    );
  }

  Widget _buildTimeline(Place place) {
    final timeline = place.timeline!;
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: timeline.length,
        itemBuilder: (context, index) {
          return _buildTimelineItem(
            timeline[index].year,
            timeline[index].event,
            index == 0,
            index == timeline.length - 1,
          );
        },
      ),
    );
  }

  Widget _buildTimelineItem(String year, String event, bool isFirst, bool isLast) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 4),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            year,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              event,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF4B5563),
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(Place place) {
    final images = place.images ?? [];
    if (images.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final imageUrl = images[index];
          return GestureDetector(
            onTap: () => _showFullImage(context, imageUrl),
            child: Container(
              margin: const EdgeInsets.only(right: 14),
              width: 240,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFFF3F4F6),
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFFF3F4F6),
                    child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricHeader(Place place) {
    return Row(
      children: [
        _buildHeaderStat('ERA', place.era ?? place.historicalPeriod ?? place.category),
        _buildVerticalDivider(),
        _buildHeaderStat('RATING', '${place.rating} ★'),
        _buildVerticalDivider(),
        _buildHeaderStat('SAVED', '2.4k'),
      ],
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.grey[500],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F2937),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.grey[200],
    );
  }

  Widget _buildInfoGrid(Place place) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildInfoTile(Icons.account_balance_rounded, 'CIVILIZATION', place.civilization ?? 'Unknown'),
              _buildInfoTile(Icons.architecture_rounded, 'STYLE', place.architecturalStyle ?? 'Classical'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, color: Colors.grey[100]),
          ),
          Row(
            children: [
              _buildInfoTile(Icons.person_rounded, 'BUILT BY', place.builtBy ?? 'Unknown'),
              _buildInfoTile(Icons.calendar_today_rounded, 'DATE', place.constructionDate ?? 'TBA'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF374151),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignificanceCard(Place place) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF3F4F6),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote_rounded, color: AppTheme.primaryColor, size: 24),
          const SizedBox(height: 12),
          Text(
            place.significance ?? place.historicalSignificance ?? 'Loading analysis...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.6,
              color: const Color(0xFF4B5563),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunFactsList(Place place) {
    final facts = place.facts ?? place.funFacts ?? [];
    return Column(
      children: facts.map((fact) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome, size: 16, color: Colors.orangeAccent),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                fact,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF374151),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildQuizSection(Place place) {
    final quizzes = place.quizzes ?? [
      PlaceQuiz(
        question: 'What is the most unique architectural feature of ${place.name}?',
        options: ['The structural material', 'The orientation', 'The geometric symmetry', 'The decoration'],
        correctAnswerIndex: 2,
      ),
      PlaceQuiz(
        question: 'Which civilization is primarily associated with this location?',
        options: [place.civilization ?? 'Roman', 'Greek', 'Persian', 'Mayan'],
        correctAnswerIndex: 0,
      ),
    ];

    return PlaceQuizCard(quizzes: quizzes);
  }

  Widget _buildMapIntegration(Place place) {
    if (place.latitude == null || place.longitude == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Location'),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Static Map Image (Optimized for performance)
                CachedNetworkImage(
                  imageUrl: 'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800', // Beautiful map background
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  color: Colors.white.withValues(alpha: 0.9),
                  colorBlendMode: BlendMode.screen,
                ),
                // Custom Map UI Layers
                Container(
                  color: AppTheme.primaryColor.withValues(alpha: 0.05),
                ),
                // Subtle Grid Lines for "Map" feel
                _buildMapGrid(),
                // Centered Marker
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppTheme.primaryColor, size: 40),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
                          ],
                        ),
                        child: Text(
                          place.name,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Interaction Layer
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openMap(place),
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => _openMap(place),
            icon: const Icon(Icons.directions_rounded, size: 18),
            label: const Text('Get Directions'),
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.08),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapGrid() {
    return CustomPaint(
      painter: _GridPainter(),
      child: const SizedBox.expand(),
    );
  }

  Future<void> _openMap(Place place) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..strokeWidth = 1.0;

    const step = 40.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PlaceQuizCard extends StatefulWidget {
  final List<PlaceQuiz> quizzes;
  const PlaceQuizCard({super.key, required this.quizzes});

  @override
  State<PlaceQuizCard> createState() => _PlaceQuizCardState();
}

class _PlaceQuizCardState extends State<PlaceQuizCard> {
  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;

  void _handleAnswer(int index) {
    if (_hasAnswered) return;
    setState(() {
      _selectedAnswerIndex = index;
      _hasAnswered = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.quizzes.length;
      _selectedAnswerIndex = null;
      _hasAnswered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.quizzes[_currentIndex];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QUESTION ${_currentIndex + 1}/${widget.quizzes.length}',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                  letterSpacing: 1.0,
                ),
              ),
              if (_hasAnswered)
                TextButton(
                  onPressed: _nextQuestion,
                  child: Text(
                    'NEXT',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            quiz.question,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(quiz.options.length, (index) {
            final option = quiz.options[index];
            Color borderColor = Colors.grey[200]!;
            Color bgColor = Colors.white;
            IconData? icon;

            if (_hasAnswered) {
              if (index == quiz.correctAnswerIndex) {
                borderColor = AppTheme.accentGreen;
                bgColor = AppTheme.accentGreen.withValues(alpha: 0.05);
                icon = Icons.check_circle_rounded;
              } else if (index == _selectedAnswerIndex) {
                borderColor = AppTheme.error;
                bgColor = AppTheme.error.withValues(alpha: 0.05);
                icon = Icons.cancel_rounded;
              }
            }

            return GestureDetector(
              onTap: () => _handleAnswer(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: _selectedAnswerIndex == index ? FontWeight.w700 : FontWeight.w500,
                          color: const Color(0xFF374151),
                        ),
                      ),
                    ),
                    if (icon != null)
                      Icon(icon, size: 20, color: borderColor),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}







