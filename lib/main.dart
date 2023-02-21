import 'package:flutter/material.dart';
import 'package:hive_demo/pages/alarm.dart';
import 'package:hive_demo/pages/home.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final dir = await path.getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.initFlutter('hive_db');
  await Hive.openBox('Home');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final pages = const [
    HomeScreen(),
    AlarmScreen()
  ];







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Demo"),
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Colors.brown,
        type: BottomNavigationBarType.shifting,
        currentIndex: index,
        selectedItemColor: Colors.green,
        onTap: (value){
          print(value);
          setState(() {
            index = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.import_contacts_rounded,color:Colors.black),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm,color: Colors.black),
              backgroundColor: Colors.white,
              label: 'Alarm'
          ),
        ],
      ),
    );
  }
}

