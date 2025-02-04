import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/partners_screen.dart';
import 'package:frontend/screens/profile_page.dart';
import 'package:frontend/screens/redeem_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/transfer_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Unified Reward Systems',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF00C6FF),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Inter',
            ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFFD700)),
      ),
    );
  }
}

final GoRouter _router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      AuthService authService = AuthService();
      bool isLoggedIn = await authService.checkLoggedInUser();

      // final user = FirebaseAuth.instance.currentUser;
      final isAuthPath = state.uri.path == '/login' || state.uri.path == '/register';

      if (!isLoggedIn && !isAuthPath) {
        return '/login';
      } else if (isLoggedIn && isAuthPath) {
        return '/home';
      } else {
        return state.uri.path;
      }
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return PageTransition(
              type: PageTransitionType.fade,
              child: child,
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              alignment: Alignment.center,
              childCurrent: child,
            ).buildTransitions(context, animation, secondaryAnimation, child);
          },
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return PageTransition(
              type: PageTransitionType.fade,
              child: child,
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              alignment: Alignment.center,
              childCurrent: child,
            ).buildTransitions(context, animation, secondaryAnimation, child);
          },
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return PageTransition(
              type: PageTransitionType.fade,
              child: child,
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              alignment: Alignment.center,
              childCurrent: child,
            ).buildTransitions(context, animation, secondaryAnimation, child);
          },
        ),
      ),
      GoRoute(
        path: '/partners',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PartnersScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return PageTransition(
              type: PageTransitionType.fade,
              child: child,
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              alignment: Alignment.center,
              childCurrent: child,
            ).buildTransitions(context, animation, secondaryAnimation, child);
          },
        ),
      ),
      GoRoute(
        path: '/redeem',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RedeemScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return PageTransition(
              type: PageTransitionType.fade,
              child: child,
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              alignment: Alignment.center,
              childCurrent: child,
            ).buildTransitions(context, animation, secondaryAnimation, child);
          },
        ),
      ),
      GoRoute(
        path: '/transfer',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const TransferScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return PageTransition(
              type: PageTransitionType.fade,
              child: child,
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              alignment: Alignment.center,
              childCurrent: child,
            ).buildTransitions(context, animation, secondaryAnimation, child);
          },
        ),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return PageTransition(
              type: PageTransitionType.fade,
              child: child,
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              alignment: Alignment.center,
              childCurrent: child,
            ).buildTransitions(context, animation, secondaryAnimation, child);
          },
        ),
      )
    ]);
