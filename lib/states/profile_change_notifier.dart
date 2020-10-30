import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_client_app/common/global.dart';
import 'package:github_client_app/models/index.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    Global.saveProfile();
    super.notifyListeners();
  }
}

class UserModel extends ProfileChangeNotifier {
  User get user => _profile.user;

  bool get isLogin => user != null;

  set user(User user) {
    if (user.login != _profile.user.login) {
      _profile.lastLogin = _profile.user.login;
      _profile.user = user;
      print("Usera:${_profile.user}");
      notifyListeners();
    }
  }
}

class ThemeModel extends ProfileChangeNotifier {
  //获取当前主体，
  ColorSwatch get theme =>
      Global.themes.firstWhere((element) => element.value == _profile.theme,
          orElse: () => Colors.blue);

  set theme(ColorSwatch color) {
    if (color != theme) {
      _profile.theme = color[500].value;
      notifyListeners();
    }
  }
}

class LocaleModel extends ProfileChangeNotifier {
  Locale getLocal() {
    if (_profile.locale == null) return null;
    var t = _profile.locale.split("_");
    return Locale(t[0], t[1]);
  }

  //获取当前Local的字符串表示
  String get local => _profile.locale;
  set locale(String local) {
    if (local != _profile.locale) {
      _profile.locale = local;
      notifyListeners();
    }
  }
}
