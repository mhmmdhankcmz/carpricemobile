import 'package:carpricemobile/pages/favorite_page.dart';
import 'package:carpricemobile/pages/forgot_password.dart';
import 'package:carpricemobile/pages/home.dart';
import 'package:carpricemobile/pages/login_page.dart';
import 'package:carpricemobile/pages/register_page.dart';
import 'package:carpricemobile/services/auth_service.dart';
import 'package:carpricemobile/services/firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => FireStoreDB()),
      ],
      child: MaterialApp(
        title: 'CarPrice',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.dark,

          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.white,

              unselectedItemColor: Colors.grey,

          ),
        textTheme: GoogleFonts.acmeTextTheme().copyWith(
              bodySmall: GoogleFonts.acme(fontSize: 10),
              bodyMedium: GoogleFonts.acme(fontSize: 15),
              bodyLarge: GoogleFonts.acme(fontSize: 20),
              titleSmall: GoogleFonts.acme(fontSize: 15),
              titleMedium:  GoogleFonts.acme(fontSize: 20),
              titleLarge:  GoogleFonts.acme(fontSize: 25),
              labelSmall:  GoogleFonts.acme(fontSize: 8),
              labelMedium:  GoogleFonts.acme(fontSize: 12),
              labelLarge:  GoogleFonts.acme(fontSize: 15),
              headlineSmall:  GoogleFonts.acme(fontSize: 25),
              headlineMedium:  GoogleFonts.acme(fontSize: 30),
              headlineLarge:  GoogleFonts.acme(fontSize: 35),
        ),
          scaffoldBackgroundColor: Colors.grey.shade600,
        ),
        routes: {
              '/home': (context) => const Home(),
              '/login': (context) =>  const LoginPage(),
              '/forgotPass': (context) =>  const ForgotPassword(),
              '/register': (context) =>  const RegisterPage(),
              '/favoriler': (context)=> const FavoritePage(),

        },
        // initialRoute: '/home',
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text(
                'Birşeyler ters Gitti..',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
        home:  AuthService().loginAuth(),
      ),
    );
  }
}

