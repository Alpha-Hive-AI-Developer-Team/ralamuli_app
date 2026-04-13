import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ralamuli_translator/features/Help%20&%20Support/help_screen.dart';
import 'package:ralamuli_translator/features/Home/Home%20Screen/home_screen.dart';
import 'package:ralamuli_translator/features/Learning/UI/learning_screen.dart';
import 'package:ralamuli_translator/features/Setting/setting_screen.dart';
import 'package:ralamuli_translator/features/Splash%20Screen/splash_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const settings = '/settings';
  static const notificationSetting = '/notificationSetting';
  static const help = '/help';
  static const learning = '/learning';
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.help,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: AppRoutes.learning,
        builder: (context, state) => const LearningModeScreen(),
      ),
      // GoRoute(
      //   path: AppRoutes.otpVerification,
      //   builder: (context, state) {
      //     final purpose = state.uri.queryParameters['purpose'] == 'signup'
      //         ? OtpPurpose.signup
      //         : OtpPurpose.forgotPassword;
      //     return OtpVerificationScreen(purpose: purpose);
      //   },
      // ),
      // GoRoute(
      //   path: AppRoutes.forgotPassword,
      //   builder: (context, state) => const ForgotPasswordScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.createNewPassword,
      //   builder: (context, state) => const CreateNewPasswordScreen(),
      // ),
      // GoRoute(
      //   name: 'home',
      //   path: AppRoutes.home,
      //   builder: (context, state) => const HomeShell(),
      // ),
      // GoRoute(
      //   name: 'mission',
      //   path: AppRoutes.mission,
      //   builder: (context, state) => const NewMissionScreen(),
      // ),
      // GoRoute(
      //   name: 'notifications',
      //   path: AppRoutes.notifications,
      //   builder: (context, state) => const NotificationsScreen(),
      // ),
      // GoRoute(
      //   name: 'reset',
      //   path: AppRoutes.reset,
      //   builder: (context, state) => const ResetScreen(),
      // ),
      // GoRoute(
      //   name: 'resetTrigger',
      //   path: AppRoutes.resetTrigger,
      //   builder: (context, state) => const ResetTriggerScreen(),
      // ),
      // GoRoute(
      //   name: 'resetEmotion',
      //   path: AppRoutes.resetEmotion,
      //   builder: (context, state) => const ResetEmotionScreen(),
      // ),
      // GoRoute(
      //   name: 'weeklyReview',
      //   path: AppRoutes.weeklyReview,
      //   builder: (context, state) => const WeeklyReviewScreen(),
      // ),
      // GoRoute(
      //   name: 'pricing',
      //   path: AppRoutes.pricing,
      //   builder: (context, state) => const PricingPlansScreen(),
      // ),
      // GoRoute(
      //   name: 'settings',
      //   path: AppRoutes.settings,
      //   builder: (context, state) => const SettingsScreen(),
      // ),
      // GoRoute(
      //   name: 'account',
      //   path: AppRoutes.account,
      //   builder: (context, state) => const AccountScreen(),
      // ),
      // GoRoute(
      //   name: 'help-center',
      //   path: AppRoutes.helpCenter,
      //   builder: (context, state) => const HelpCenterScreen(),
      // ),
      // GoRoute(
      //   name: 'legal',
      //   path: AppRoutes.legal,
      //   builder: (context, state) => const LegalScreen(),
      // ),
      // GoRoute(
      //   name: 'notificationSetting',
      //   path: AppRoutes.notificationSetting,
      //   builder: (context, state) => const NotificationsSetting(),
      // ),
      // GoRoute(
      //   path: AppRoutes.privacyPolicy,
      //   builder: (context, state) {
      //     final args = state.extra as PolicyScreenArgs;
      //     return PolicyScreen(
      //       title: args.title,
      //       lastUpdated: args.lastUpdated,
      //       sections: args.sections,
      //     );
      //   },
      // ),
    ],
  );
});
