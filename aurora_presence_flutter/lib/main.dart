import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:aurora_presence_flutter/screens/presensi_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/personal_screen.dart';
import 'screens/confirm_password_screen.dart';
import 'screens/edit_personal_info_screen.dart';
import 'package:aurora_presence_flutter/models/personal_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('id', 'ID'),
        const Locale('en', 'US'),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/personal': (context) => PersonalScreen(),
        // Perbaikan di sini: Gunakan EditPersonalInfoScreen sebagai widget
        '/editPersonalInfo': (context) => EditPersonalInfoScreen(
                      personalInfo: PersonalInfo(
                        name: '',
                        phoneNumber: '',
                        email: '',
                        dob: '',
                        gender: '',
                        address: '',
                        emergencyPhone: '',
                        employeeID: '',
                        department: '',
                        position: '',
                      ),
                    ),
        '/confirmPassword': (context) => const ConfirmPasswordScreen(),
        '/presensi': (context) => PresensiScreen(),
      },
    );
  }
}
