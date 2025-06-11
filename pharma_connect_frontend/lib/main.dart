import 'package:flutter/material.dart';
import 'package:pharma_connect_flutter/presentation/pages/auth/login_page.dart';
import 'package:pharma_connect_flutter/presentation/pages/auth/register_page.dart';
import 'package:pharma_connect_flutter/presentation/pages/home/home_page.dart';
import 'package:pharma_connect_flutter/presentation/pages/medicine/edit_medicine_screen.dart';
import 'package:pharma_connect_flutter/presentation/pages/owner/owner_home_page.dart';
import 'package:pharma_connect_flutter/presentation/pages/profile/profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/local/session_manager.dart';
import 'package:pharma_connect_flutter/presentation/pages/user/user_home_page.dart';
import 'package:pharma_connect_flutter/presentation/pages/admin/admin_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharma Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/medicine/edit': (context) => const EditMedicineScreen(),
        '/owner': (context) => const OwnerHomePage(),
        '/user': (context) => const UserHomePage(),
        '/profile': (context) => const ProfileScreen(),
        '/admin': (context) => const AdminHomePage(),
      },
    );
  }
}
