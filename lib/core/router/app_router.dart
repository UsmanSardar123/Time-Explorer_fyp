import 'package:go_router/go_router.dart';
import 'package:timeexplorer/features/home/presentation/pages/home_page.dart';
import 'package:timeexplorer/features/auth/presentation/pages/register_page.dart';
import 'package:timeexplorer/features/auth/presentation/widgets/auth_wrapper.dart';
import 'package:timeexplorer/features/profile/presentation/pages/profile_page.dart';
import 'package:timeexplorer/features/profile/presentation/pages/settings_page.dart';
import 'package:timeexplorer/features/places/presentation/pages/place_details_page.dart' as new_ui;
import 'package:timeexplorer/features/explore/presentation/pages/paginated_list_page.dart';
import 'package:timeexplorer/features/explore/presentation/pages/explore_places_screen.dart';
import 'package:timeexplorer/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:timeexplorer/features/explore/presentation/pages/search_page.dart';
import 'package:timeexplorer/features/explore/domain/entities/place_entity.dart';
import 'package:timeexplorer/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:timeexplorer/features/auth/presentation/providers/auth_provider.dart';
import 'package:timeexplorer/features/profile/presentation/pages/change_password_page.dart';
import 'package:timeexplorer/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:timeexplorer/features/profile/presentation/pages/eras_preference_page.dart';
import 'package:timeexplorer/features/profile/presentation/pages/help_support_page.dart';
import 'package:timeexplorer/features/profile/presentation/pages/personal_info_page.dart';
import 'package:timeexplorer/features/profile/presentation/pages/policy_page.dart';
import 'package:timeexplorer/features/profile/presentation/pages/profile_privacy_page.dart';
import 'package:timeexplorer/features/profile/presentation/pages/update_email_page.dart';
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/admin/presentation/pages/user_management_page.dart';
import 'package:timeexplorer/features/admin/presentation/pages/user_detail_form_page.dart';
import 'package:timeexplorer/features/admin/presentation/pages/places_management_page.dart';
import 'package:timeexplorer/features/admin/presentation/pages/place_form_page.dart';
import 'package:timeexplorer/features/places/domain/entities/place.dart';
import 'package:timeexplorer/features/admin/presentation/pages/facts_management_page.dart';
import 'package:timeexplorer/features/admin/presentation/pages/fact_form_page.dart';
import 'package:timeexplorer/features/admin/presentation/pages/characters_management_page.dart';
import 'package:timeexplorer/features/admin/presentation/pages/character_form_page.dart';
import 'package:timeexplorer/features/learn/data/models/fact_model.dart';
import 'package:timeexplorer/features/places/domain/entities/era.dart';
import 'package:timeexplorer/features/places/presentation/pages/era_details_page.dart';
import 'package:timeexplorer/features/quiz/presentation/pages/quiz_dashboard_page.dart';
import 'package:timeexplorer/features/quiz/presentation/pages/quiz_page.dart';
import 'package:timeexplorer/features/gamification/presentation/pages/progress_page.dart';
import 'package:timeexplorer/core/router/app_transitions.dart';
import 'package:timeexplorer/features/onboarding/presentation/pages/splash_page.dart';
import 'package:timeexplorer/features/personalities/presentation/pages/categories_page.dart';
import 'package:timeexplorer/features/personalities/presentation/pages/personalities_list_page.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character_category.dart';
import 'package:timeexplorer/features/personalities/domain/entities/character.dart';
import 'package:timeexplorer/features/personalities/presentation/pages/personality_detail_page.dart';
import 'package:timeexplorer/features/personalities/presentation/pages/personality_chat_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isAdmin = authProvider.isAdmin;
        final isSplash = state.matchedLocation == '/splash';
        final isLoggingIn = state.matchedLocation == '/';
        final isRegistering = state.matchedLocation == '/register';

        // Allow staying on splash
        if (isSplash) return null;

        if (!isAuthenticated && !isLoggingIn && !isRegistering) {
          return '/';
        }

        if (isAuthenticated && (isLoggingIn || isRegistering)) {
          return isAdmin ? '/admin' : '/home';
        }

        return null;
      },
      routes: [
        // ── Onboarding ─────────────────────────────────────────────────────
        GoRoute(
          path: '/splash',
          pageBuilder: (context, state) =>
              AppTransitions.fade(const SplashPage(), state),
        ),

        // ── Root / Auth ────────────────────────────────────────────────────
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              AppTransitions.fade(const AuthWrapper(), state),
        ),
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const RegisterPage(), state),
        ),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) =>
              AppTransitions.fade(const HomePage(), state),
        ),
        GoRoute(
          path: '/admin',
          pageBuilder: (context, state) =>
              AppTransitions.fade(const AdminDashboardPage(), state),
        ),

        // ── Main Screens ───────────────────────────────────────────────────
        GoRoute(
          path: '/explore',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const ExplorePlacesScreen(), state),
        ),
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const SearchPage(), state),
        ),
        GoRoute(
          path: '/bookmarks',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const BookmarksPage(), state),
        ),

        // ── Detail Screens ─────────────────────────────────────────────────
        GoRoute(
          path: '/place-details',
          pageBuilder: (context, state) {
            final extra = state.extra;
            String id;
            if (extra is PlaceEntity) {
              id = extra.id;
            } else if (extra is String) {
              id = extra;
            } else {
              return AppTransitions.slide(
                const Scaffold(body: Center(child: Text('Invalid place data'))),
                state,
              );
            }
            return AppTransitions.portal(new_ui.PlaceDetailsPage(placeId: id), state);
          },
        ),
        GoRoute(
          path: '/paginated-list',
          pageBuilder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            return AppTransitions.slide(
              PaginatedListPage(
                type: args['type'] as ListType,
                title: args['title'] as String,
              ),
              state,
            );
          },
        ),
        GoRoute(
          path: '/era-details',
          pageBuilder: (context, state) => AppTransitions.portal(
            EraDetailsPage(era: state.extra as Era),
            state,
          ),
        ),

        // ── Profile ────────────────────────────────────────────────────────
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const ProfilePage(), state),
        ),
        GoRoute(
          path: '/profile/edit',
          pageBuilder: (context, state) => AppTransitions.slide(
            EditProfilePage(profile: state.extra as ProfileEntity),
            state,
          ),
        ),
        GoRoute(
          path: '/profile/change-password',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const ChangePasswordPage(), state),
        ),
        GoRoute(
          path: '/profile/update-email',
          pageBuilder: (context, state) => AppTransitions.slide(
            UpdateEmailPage(currentEmail: state.extra as String),
            state,
          ),
        ),
        GoRoute(
          path: '/profile/personal-info',
          pageBuilder: (context, state) => AppTransitions.slide(
            PersonalInfoPage(profile: state.extra as ProfileEntity),
            state,
          ),
        ),
        GoRoute(
          path: '/profile/privacy',
          pageBuilder: (context, state) => AppTransitions.slide(
            ProfilePrivacyPage(profile: state.extra as ProfileEntity),
            state,
          ),
        ),
        GoRoute(
          path: '/profile/era-preference',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const ErasPreferencePage(), state),
        ),

        // ── Settings & Static ──────────────────────────────────────────────
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const SettingsPage(), state),
        ),
        GoRoute(
          path: '/policy',
          pageBuilder: (context, state) =>
              AppTransitions.slide(PolicyPage(title: state.extra as String), state),
        ),
        GoRoute(
          path: '/help-support',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const HelpSupportPage(), state),
        ),

        // ── Gamification ───────────────────────────────────────────────────
        GoRoute(
          path: '/progress',
          pageBuilder: (context, state) =>
              AppTransitions.bottomUp(const ProgressPage(), state),
        ),

        // ── Quiz ───────────────────────────────────────────────────────────
        GoRoute(
          path: '/quiz',
          pageBuilder: (context, state) =>
              AppTransitions.bottomUp(const QuizDashboardPage(), state),
        ),
        GoRoute(
          path: '/quiz-play',
          pageBuilder: (context, state) => AppTransitions.bottomUp(
            QuizPage(category: state.extra as String?),
            state,
          ),
        ),

        // ── Personalities / Chat ───────────────────────────────────────────
        GoRoute(
          path: '/personalities-categories',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const CategoriesPage(), state),
        ),
        GoRoute(
          path: '/personalities-list',
          pageBuilder: (context, state) => AppTransitions.slide(
            PersonalitiesListPage(category: state.extra as CharacterCategory),
            state,
          ),
        ),
        GoRoute(
          path: '/personality-detail',
          pageBuilder: (context, state) => AppTransitions.portal(
            PersonalityDetailPage(character: state.extra as Character),
            state,
          ),
        ),
        GoRoute(
          path: '/personality-chat',
          pageBuilder: (context, state) => AppTransitions.slide(
            PersonalityChatPage(character: state.extra as Character),
            state,
          ),
        ),

        // ── Admin ──────────────────────────────────────────────────────────
        GoRoute(
          path: '/admin/users',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const UserManagementPage(), state),
        ),
        GoRoute(
          path: '/admin/users/form',
          pageBuilder: (context, state) => AppTransitions.slide(
            UserDetailFormPage(user: state.extra as ProfileEntity?),
            state,
          ),
        ),
        GoRoute(
          path: '/admin/places',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const PlacesManagementPage(), state),
        ),
        GoRoute(
          path: '/admin/places/form',
          pageBuilder: (context, state) => AppTransitions.slide(
            PlaceFormPage(place: state.extra as Place?),
            state,
          ),
        ),
        GoRoute(
          path: '/admin/characters',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const CharactersManagementPage(), state),
        ),
        GoRoute(
          path: '/admin/characters/form',
          pageBuilder: (context, state) => AppTransitions.slide(
            CharacterFormPage(character: state.extra as Character?),
            state,
          ),
        ),
        GoRoute(
          path: '/admin/facts',
          pageBuilder: (context, state) =>
              AppTransitions.slide(const FactsManagementPage(), state),
        ),
        GoRoute(
          path: '/admin/facts/form',
          pageBuilder: (context, state) => AppTransitions.slide(
            FactFormPage(fact: state.extra as FactModel?),
            state,
          ),
        ),
      ],
    );
  }
}
