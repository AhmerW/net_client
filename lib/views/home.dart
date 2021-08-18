import 'package:flutter/material.dart';
import 'package:net_client/controllers/themec.dart';
import 'package:net_client/views/api_screen.dart';
import 'package:net_client/views/client_screen.dart';
import 'package:net_client/views/saved.dart';
import 'package:provider/provider.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
              child: Text(
                'Welcome to NetClient',
                style: TextStyle(fontSize: 20),
              ),
              padding: EdgeInsets.all(20),
            ),
          ),
          Divider(),
          Text('Helper manual')
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;

  List<Widget> _tabScreens = [
    // HomePageScreen(),
    ClientScreen(),
    ApiScreen(),
  ];

  void _tabClicked(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NetClient"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Center(
                child: Container(
              padding: EdgeInsets.all(20),
              child: Text('NetClient'),
            )),
            Divider(),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SavedWebsitesScreen()));
              },
              child: Text('Saved websites'),
            ),
            Divider(),
            Consumer<ThemeController>(
              builder: (context, controller, _) {
                return SwitchListTile(
                  value: controller.isDarkTheme(),
                  onChanged: (value) {
                    controller.setDarkTheme(value);
                  },
                  title: Text('Dark theme'),
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _tabClicked,
        currentIndex: _tabIndex,
        items: const <BottomNavigationBarItem>[
          /* BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ), */
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Client',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud_queue), label: 'Api tool'),
        ],
        selectedItemColor: Colors.cyan,
      ),
      body: _tabScreens[_tabIndex],
    );
  }
}
