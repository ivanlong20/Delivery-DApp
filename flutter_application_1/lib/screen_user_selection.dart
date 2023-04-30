import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';

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
          statusBarColor: Colors.transparent, //top status bar
          systemNavigationBarColor: Color.fromARGB(255, 255, 255,
              255), // navigation bar color, the one Im looking for
          statusBarIconBrightness: Brightness.dark, // status bar icons' color
          systemNavigationBarIconBrightness:
              Brightness.dark, //navigation bar icons' color
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: 'Montserrat',
            useMaterial3: true,
            colorSchemeSeed: Color.fromARGB(255, 255, 216, 45),
          ),
          home: const UserSelectionPage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class UserSelectionPage extends StatefulWidget {
  const UserSelectionPage({super.key, required this.title});

  final String title;

  @override
  State<UserSelectionPage> createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(

      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: Size(350, 75),
                  backgroundColor: Color.fromRGBO(170, 170, 170, 1)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const ConnectMetamaskPage(
                        title: 'Connect Your Crypto Wallet');
                  }),
                );
              },
              child: Text(
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  'Customer / Business'),
            ),
            SizedBox(
              height: 30,
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: Size(350, 75),
                  backgroundColor: Color.fromRGBO(170, 170, 170, 1)),
              onPressed: () {},
              child: Text(
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                  'Delivery Partner'),
            )
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ConnectMetamaskPage extends StatelessWidget {
  const ConnectMetamaskPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    final String assetName = 'assets/icon/metamask-fox.svg';
    final Widget svg = SvgPicture.asset(assetName);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
          child: FilledButton(
        style: FilledButton.styleFrom(
            minimumSize: Size(100, 75),
            maximumSize: Size(350, 75),
            backgroundColor: Color.fromARGB(255, 0, 0, 0)),
        onPressed: () {},
        child: FloatingActionButton.extended(
          label: Text(
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
              'Login with Metamask'), // <-- Text
          backgroundColor: Colors.black,
          icon: Container(child: svg, width: 50, height: 50),
          onPressed: () {},
        ),
      )),
    );
  }
}
