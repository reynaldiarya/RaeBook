import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ebook/src/pages/auth/login.dart';
import 'package:ebook/src/theme/theme.dart';
import 'package:ebook/src/settings/settings_controller.dart';
import 'package:ebook/src/pages/home/home.dart';
import 'api.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          scrollBehavior: MyCustomScrollBehavior(),
          debugShowCheckedModeBanner: false,
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: Themes.lightTheme,
          darkTheme: Themes.darkTheme,
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                return FutureBuilder<bool>(
                    future:
                        Api.sessionUser(settingsController: settingsController),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      bool isSessionValid = snapshot.data ?? false;

                      if (isSessionValid) {
                        return HomePage(settingsController: settingsController);
                      } else {
                        return Login(
                          settingsController: settingsController,
                        );
                      }
                    });
              },
            );
          },
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
