import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'search_job_titles.dart';
import 'search_skills.dart';
import 'my_profile.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");

  // Initialise the Hive NoSQL package
  await Hive.initFlutter();

  // Open a hive db box
  var box = await Hive.openBox('my_skills_profile_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/search_job_title': (BuildContext context) => const SearchJobTitles(),
        '/search_skills': (BuildContext context) => const SearchSkills(),
        '/my_profile': (BuildContext context) => MyProfile(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Jobs & Skills API Spike'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidgetPage = const Text("");

    switch (_selectedIndex) {
      case 0:
        currentWidgetPage = const SearchJobTitles();
        break;
      case 1:
        currentWidgetPage = const SearchSkills();
        break;
      case 2:
        currentWidgetPage = MyProfile();
        break;
    }
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: currentWidgetPage,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Job Title'),
          BottomNavigationBarItem(icon: Icon(Icons.art_track), label: 'Skills'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Profile')
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
