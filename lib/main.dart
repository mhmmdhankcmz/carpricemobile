import 'package:carpricemobile/pages/favorite_page.dart';
import 'package:carpricemobile/pages/forgot_password.dart';
import 'package:carpricemobile/pages/home.dart';
import 'package:carpricemobile/pages/login_page.dart';
import 'package:carpricemobile/pages/register_page.dart';
import 'package:carpricemobile/services/auth_service.dart';
import 'package:carpricemobile/services/firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
          primarySwatch: Colors.orange,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.yellow,
              selectedLabelStyle: TextStyle(color: Colors.grey),
              unselectedItemColor: Colors.grey,
              unselectedLabelStyle: TextStyle(color: Colors.yellow)),
          textTheme: TextTheme(

            bodyLarge: const TextStyle(
                color: Colors.yellow, fontSize: 30, fontWeight: FontWeight.bold),
            bodyMedium: const TextStyle(
                color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold),
            bodySmall: const TextStyle(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
            titleSmall: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 18,
                fontWeight: FontWeight.bold),
            titleMedium: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 28,
                fontWeight: FontWeight.bold),
            titleLarge: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 38,
                fontWeight: FontWeight.bold),
            labelSmall: TextStyle(
                color: Colors.yellow.shade600,
                fontSize: 10,
                fontWeight: FontWeight.bold),
            labelMedium: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold),
            labelLarge: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 18,
                fontWeight: FontWeight.bold),
            headlineLarge: const TextStyle( color: Colors.pink,fontSize: 9),
            headlineMedium: const TextStyle(color: Colors.pink,fontSize: 7),
            headlineSmall: const TextStyle(color: Colors.pink,fontSize: 5),
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

