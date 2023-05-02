import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen_user_selection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Color.fromARGB(255, 251, 255, 255),
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: 'Montserrat',
            useMaterial3: true,
            colorSchemeSeed: Color.fromARGB(255, 255, 197, 81),
          ),
          home: const UserSelectionPage(title: 'Flutter Demo Home Page'),
        ));
  }
}
