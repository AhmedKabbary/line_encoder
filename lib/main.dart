import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'encoding.dart';
import 'graph.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data communication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();
  String type = "nrz";
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "DIGITAL TO DIGITAL CONVERSION",
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              DropdownButton<String>(
                value: type,
                items: const [
                  DropdownMenuItem(
                    value: "nrz",
                    child: Text("Non-return to zero"),
                  ),
                  DropdownMenuItem(
                    value: "nrz-i",
                    child: Text("Non-return to zero inverted"),
                  ),
                  DropdownMenuItem(
                    value: "pzr",
                    child: Text("Polar RZ scheme"),
                  ),
                  DropdownMenuItem(
                    value: "me",
                    child: Text("Manchester Encoding"),
                  ),
                  DropdownMenuItem(
                    value: "dme",
                    child: Text("Differential Manchester Encoding"),
                  ),
                  DropdownMenuItem(
                    value: "ml",
                    child: Text("Multilevel"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    type = value!;
                  });
                },
                alignment: Alignment.center,
              ),
              const SizedBox(height: 32),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75),
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: "e.g. 011001"),
                  onChanged: (text) {
                    setState(() {});
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[01]"))
                  ],
                ),
              ),
              const SizedBox(height: 128),
              Builder(
                builder: (context) {
                  double cellSize = 50.0;
                  double signalSize =
                      ({"pzr", "me", "dme"}.contains(type)) ? 25.0 : 50.0;

                  String input = _controller.text.trim();
                  List<int> data = List.empty();

                  if (input.isNotEmpty) {
                    data =
                        input.characters.map<int>((e) => int.parse(e)).toList();
                  }

                  LineEncoding encoding = LineEncoding(data);

                  return Stack(
                    children: [
                      GestureDetector(
                        child: CustomPaint(
                          size: const Size(800, 400),
                          painter: Graph(encoding.convert(type), offset,
                              cellSize, signalSize),
                        ),
                        onPanUpdate: (details) {
                          setState(() {
                            offset += details.delta;
                          });
                        },
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              offset = Offset.zero;
                            });
                          },
                          splashRadius: 20.0,
                          icon: const Icon(Icons.home_rounded),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
