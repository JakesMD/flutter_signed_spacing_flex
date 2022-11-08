import 'package:flutter/material.dart';
import 'package:signed_spacing_flex/signed_spacing_flex.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SignedSpacingFlex Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _spacing = 0;
  StackingOrder _stackingOrder = StackingOrder.firstOnTop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SignedSpacingFlex Demo")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SignedSpacingColumn(
            spacing: 24,
            children: [
              Expanded(
                child: SignedSpacingColumn(
                  spacing: _spacing.toDouble(),
                  stackingOrder: _stackingOrder,
                  children: const [
                    Material(
                      elevation: 8,
                      color: Colors.red,
                      child: SizedBox(
                        height: 100,
                        child: Center(child: Text("I'm fixed")),
                      ),
                    ),
                    Expanded(
                      child: Material(
                        elevation: 8,
                        color: Colors.green,
                        child: Center(
                          child: Text("I'm expanded"),
                        ),
                      ),
                    ),
                    Material(
                      elevation: 8,
                      color: Colors.blue,
                      child: SizedBox(
                        height: 100,
                        child: Center(child: Text("I'm fixed")),
                      ),
                    ),
                    Material(
                      elevation: 8,
                      color: Colors.yellow,
                      child: SizedBox(
                        height: 100,
                        child: Center(child: Text("I'm fixed")),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Slider(
                        value: _spacing.toDouble(),
                        divisions: 48,
                        min: -24,
                        max: 24,
                        onChanged: (value) => setState(() => _spacing = value.toInt()),
                      ),
                      Text("Spacing: $_spacing"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Switch(
                        value: _stackingOrder == StackingOrder.lastOnTop ? true : false,
                        onChanged: (value) => setState(
                          () => _stackingOrder = value ? StackingOrder.lastOnTop : StackingOrder.firstOnTop,
                        ),
                      ),
                      Text(_stackingOrder == StackingOrder.firstOnTop ? "First on top" : "Last on top"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
