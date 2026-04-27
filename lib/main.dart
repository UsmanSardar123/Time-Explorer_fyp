import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/router/app_router.dart';
import 'package:timeexplorer/core/theme/app_theme.dart';
import 'package:timeexplorer/features/auth/presentation/providers/auth_provider.dart';
import 'package:timeexplorer/features/profile/presentation/providers/profile_provider.dart';
import 'package:timeexplorer/features/explore/presentation/providers/place_provider.dart';
import 'package:timeexplorer/features/bookmarks/presentation/providers/bookmark_provider.dart';
import 'package:timeexplorer/features/explore/presentation/providers/personality_provider.dart';
import 'package:timeexplorer/features/profile/presentation/providers/settings_provider.dart';
import 'package:timeexplorer/features/admin/data/repositories/firestore_admin_repository.dart';
import 'package:timeexplorer/features/admin/presentation/manager/admin_provider.dart';
import 'package:timeexplorer/features/learn/presentation/daily_fact_provider.dart';
import 'package:timeexplorer/features/places/presentation/providers/era_provider.dart';
import 'package:timeexplorer/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:timeexplorer/core/config/app_config.dart';
import 'package:timeexplorer/features/personalities/data/repositories/character_firestore_repository.dart';
import 'package:timeexplorer/features/personalities/data/services/remote_config_service.dart';

import 'firebase_options.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('[App] No .env file found. Relying on --dart-define.');
  }


  // Centralized key validation.
  AppConfig.validate();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  unawaited(
    RemoteConfigService.checkForUpdates(CharacterFirestoreRepository()),
  );

  await Hive.initFlutter();
  await Hive.openBox<String>('wikipedia_cache');

  runApp(const ProviderScope(child: MyApp()));
}

class ProviderScope extends StatelessWidget {
  final Widget child;
  const ProviderScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Setup MultiProvider here
    return MultiProvider(

      
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PlaceProvider()),
        ChangeNotifierProvider(create: (_) => PersonalityProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (_) => AdminProvider(repository: FirestoreAdminRepository()),
        ),
        ChangeNotifierProvider(create: (_) => DailyFactProvider()),
        ChangeNotifierProvider(create: (_) => EraProvider()),
        ChangeNotifierProvider(create: (_) => GamificationProvider()..init()),
      ],
      child: child,
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _router = AppRouter.createRouter(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp.router(
          title: 'TimeExplorer',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
