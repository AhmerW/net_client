import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PingStatus {
  static String finished() {
    return "Finished";
  }

  static String pinging() {
    return "Pinging";
  }

  static String notPinged() {
    return "NotPinged";
  }
}

class Website {
  final String url;

  String status = PingStatus.notPinged();

  int? pingts;

  Website(
    this.url, {
    String status: 'NotPinged',
    int? pingts,
  });

  Map<String, dynamic> toJson() {
    return {
      'pingts': pingts,
      'status': status,
      'url': url,
    };
  }

  factory Website.fromJson(Map<String, dynamic> json) {
    return Website(
      json['url'],
      status: json['status'],
      pingts: json['pingts'],
    );
  }
}

class WebsiteListController extends ChangeNotifier {
  String? pingaddr;
  final String key = 'websites';
  List<Website> websites = <Website>[];

  SharedPreferences? _prefs;

  void setPingaddr(String addr) {
    pingaddr = addr;
    notifyListeners();
  }

  Future<SharedPreferences> getPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }

  Future<int> add(Website website) async {
    if (websites.isEmpty) {
      await get();
    }
    if (websites.isNotEmpty) {
      if (websites.any((element) => element.url == website.url)) {
        return -1;
      }
    }
    websites.add(website);
    notifyListeners();
    return websites.length - 1;
  }

  void save() async {
    var prefs = await getPrefs();

    prefs.setStringList(
      key,
      websites
          .map(
            (website) => jsonEncode(
              website.toJson(),
            ),
          )
          .toList(),
    );
  }

  void remove(int index) async {
    var prefs = await getPrefs();
    if (0 <= index && index < websites.length) {
      websites.removeAt(index);
      save();
      notifyListeners();
    }
  }

  Future<List<Website>> get() async {
    var prefs = await SharedPreferences.getInstance();

    if (websites.isEmpty) {
      websites = (prefs.getStringList('websites') ?? [])
          .map((website) => Website.fromJson(jsonDecode(website)))
          .toList();
    }
    return websites;
  }
}
