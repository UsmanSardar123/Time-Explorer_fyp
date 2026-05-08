import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeexplorer/core/widgets/app_image_loader.dart';
import '../../core/wikimedia_headers.dart';

import '../../domain/entities/event_category.dart';

class FullscreenImagePage extends StatefulWidget {
  final dynamic imageUrl;
  final String heroTag;
  final String title;
  final EventCategory? category;

  const FullscreenImagePage({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    required this.title,
    this.category,
  });

  @override
  State<FullscreenImagePage> createState() => _FullscreenImagePageState();
}

class _FullscreenImagePageState extends State<FullscreenImagePage> {
  final _transformController = TransformationController();
  bool _showUI = true;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _toggleUI() => setState(() => _showUI = !_showUI);

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleUI,
          child: Stack(
            fit: StackFit.expand,
            children: [
              InteractiveViewer(
                transformationController: _transformController,
                minScale: 0.8,
                maxScale: 5.0,
                child: Center(
                  child: AppImageLoader(
                    imageUrl: widget.imageUrl,
                    category: widget.category,
                    headers: kWikimediaHeaders,
                    fit: BoxFit.contain,
                    heroTag: widget.heroTag,
                    errorWidget: const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white38,
                      size: 64,
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _showUI ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black45,
                          shape: const CircleBorder(),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _resetZoom,
                        icon: const Icon(Icons.zoom_out_map_rounded,
                            color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black45,
                          shape: const CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
