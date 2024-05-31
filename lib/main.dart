import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:olxm_project/firebase_options.dart';
import 'package:olxm_project/screen/favorite_screen.dart';
import 'package:olxm_project/screen/home_screen.dart';
import 'package:olxm_project/screen/posting_screen.dart';
import 'package:olxm_project/screen/profile_screen.dart';
import 'package:olxm_project/screen/sign_in_screen.dart';
import 'package:olxm_project/screen/sign_up_screen.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await FlutterConfig.loadEnvVariables();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoes Shop',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          primary: Colors.deepPurple,
          surface: Colors.deepPurple[50],
        ),
        useMaterial3: true,
      ),
      // home: const MainSreen(),
      home: const MainScreen(),
      initialRoute: '/',
      routes: {
        '/homescreen': (context) => const HomeScreen(),
        '/favorite': (context) => const FavoriteScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //TODO: 1 Deklarasikan variable
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomeScreen(),
    const FavoriteScreen(),
    const PostingScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO:  2 Buat properti body berupa widget yang ditampilkan
      body: _children[_currentIndex],
      //TODO: 3 Buat properti bottomNavigasiBar dengan nilai Theme
      bottomNavigationBar: Theme(
        //TODO: 4 Buat data dan child dari Theme
        data: Theme.of(context).copyWith(canvasColor: Colors.deepPurple[50]),
        child: Container(
          child: BottomNavigationBar(
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.deepPurple[100],
              showSelectedLabels: true,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                //Home
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: Colors.orange,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.orange,
                  ),
                  label: 'Favorite',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: Colors.orange,
                  ),
                  label: 'Posting',
                ),
                //Profile
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: Colors.orange,
                  ),
                  label: 'Profile',
                )
              ]),
        ),
      ),
    );
  }
}
