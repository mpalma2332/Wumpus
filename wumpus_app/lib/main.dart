import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final imageMap = {
  'none': Image.asset('assets/images/black_square.png'),
  'moved': Image.asset('assets/images/light_square.png'),
  'current': Image.asset('assets/images/green_square.png'),
};

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hunt the Wumpus',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Hunt the Wumpus'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 50.0, minHeight: 120.0),
            child: AspectRatio(
              aspectRatio: 5 / 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Stack(
                          children: [
                            GridView.builder(
                                itemCount: 25,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5),
                                itemBuilder: (context, index) {
                                  return TextButton(
                                    // onPressed: () => _processPress(index),
                                    onPressed: null,
                                    child: imageMap['green'] ?? Container(),
                                  );
                                })
                          ],
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              'Text here',
                              style: TextStyle(fontSize: 36),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
