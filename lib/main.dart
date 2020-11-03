import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:github_client_app/common/global.dart';
import 'package:github_client_app/l10n/location_intl.dart';
import 'package:github_client_app/routes/home_page.dart';
import 'package:github_client_app/routes/index.dart';
import 'package:github_client_app/states/index.dart';
import 'package:provider/provider.dart';

void main() {
  Global.init().then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: LocaleModel()),
      ],
      child: Consumer2<ThemeModel, LocaleModel>(
        builder: (BuildContext context, themeModel, localeModel, Widget child) {
         return MaterialApp(
            theme: ThemeData(

              primarySwatch: themeModel.theme,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            onGenerateTitle: (context) {
              return GmLocalizations.of(context).title;
            },
            locale: localeModel.getLocal(),
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('zh', 'CN'),
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GmLocalizationsDelegate(),
            ],
           localeResolutionCallback: (Locale _locale, Iterable<Locale> supportedLocales) {
              if (localeModel.getLocal() != null) {
                return localeModel.getLocal();
              } else {
                Locale locale;
                if (supportedLocales.contains(_locale)) {
                  locale = _locale;
                } else {
                  locale = Locale('en', 'US');
                }
                return locale;
              }
            },
            home: HomeRoute(),
            routes: {
              "/login": (context) => Login(),
              "/language": (context) => LanguageRoute(),
              "/themes": (context) => ThemeChangeRoute(),
            },
          );
        },
      ),
    );
  }
}

