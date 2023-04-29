import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        useMaterial3: true,
        colorSchemeSeed: Color.fromARGB(255, 255, 216, 45),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              onPressed: () {},
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
