import 'package:carpricemobile/design_config/color.dart';
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

            // brightness: Brightness.dark,
          // backgroundColor: const Color.fromRGBO(202, 213 , 235 , 100),
            colorScheme: ColorScheme.light(primary: MyColors().iconColor,),
          appBarTheme: const AppBarTheme(
              // color: const Color.fromRGBO(202, 213 , 235 , 100),
              backgroundColor: Color.fromRGBO(202, 213 , 235 , 100)
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(


          ),
        textTheme: GoogleFonts.dosisTextTheme().copyWith(
              bodySmall: GoogleFonts.dosis(fontSize: 10,fontWeight: FontWeight.bold),
              bodyMedium: GoogleFonts.dosis(fontSize: 15,fontWeight: FontWeight.bold),
              bodyLarge: GoogleFonts.dosis(fontSize: 20,fontWeight: FontWeight.bold),
              titleSmall: GoogleFonts.dosis(fontSize: 15,fontWeight: FontWeight.bold),
              titleMedium:  GoogleFonts.dosis(fontSize: 20,fontWeight: FontWeight.bold),
              titleLarge:  GoogleFonts.dosis(fontSize: 25,fontWeight: FontWeight.bold),
              labelSmall:  GoogleFonts.dosis(fontSize: 8,fontWeight: FontWeight.bold),
              labelMedium:  GoogleFonts.dosis(fontSize: 12,fontWeight: FontWeight.bold),
              labelLarge:  GoogleFonts.dosis(fontSize: 15,fontWeight: FontWeight.bold),
              headlineSmall:  GoogleFonts.dosis(fontSize: 25,fontWeight: FontWeight.bold),
              headlineMedium:  GoogleFonts.dosis(fontSize: 30,fontWeight: FontWeight.bold),
              headlineLarge:  GoogleFonts.dosis(fontSize: 35,fontWeight: FontWeight.bold),
        ),
          scaffoldBackgroundColor: MyColors().scaffoldBackground,
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

