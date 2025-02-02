import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/partners_screen.dart';
import 'package:frontend/screens/redeem_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/transfer_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:go_router/go_router.dart';

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
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/partners', builder: (context, state) => const PartnersScreen()),
      GoRoute(
        path: '/redeem',
        builder: (context, state) => RedeemScreen(),
      ),
      GoRoute(path: '/transfer', builder: (context, state) => TransferScreen()),
    ]);
