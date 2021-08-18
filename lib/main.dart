import 'package:flutter/material.dart';
import 'package:net_client/controllers/logvc.dart';
import 'package:net_client/controllers/themec.dart';
import 'package:net_client/controllers/webl.dart';
import 'package:net_client/views/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<WebsiteListController>(
        create: (_) => WebsiteListController(),
      ),
      ChangeNotifierProvider<LogViewController>(
        create: (_) => LogViewController(),
      ),
      ChangeNotifierProvider<ThemeController>(
        create: (_) => ThemeController(),
      )
    ],
    child: NetClient(),
  ));
}

class NetClient extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, controller, _) {
        return MaterialApp(
          title: 'Net Client',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.cyan,
          ),
          darkTheme: ThemeData.dark(),
          themeMode:
              controller.isDarkTheme() ? ThemeMode.dark : ThemeMode.light,
          home: HomePage(),
        );
      },
    );
  }
}
