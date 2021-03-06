import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_client_app/common/git_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';
import '../common/index.dart';
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red
];

class Global {
  //这个感觉相当于iOS userdefault、
  static SharedPreferences _prefs;
  static Profile profile = Profile();
  static NetCache netCache = NetCache();
  static List<MaterialColor> get themes => _themes;
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.get("profile");
    if (_profile != null ) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }

    profile.cache = profile.cache ?? CacheConfig()
    ..enable = true
    ..maxAge = 3600
    ..maxCount = 100;
    Git.init();
  }
  static saveProfile() {
    _prefs.setString("profile", jsonEncode(profile.toJson()));
  }
}
