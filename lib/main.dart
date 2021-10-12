import 'dart:math';
import 'package:flutter/material.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CALCULATOR',
      theme: ThemeData(
        backgroundColor: Colors.yellow,
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'simple calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dispVal = "";
  double answer = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "${answer == 0.0 ? 0 : answer}",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("$dispVal",
                    style: TextStyle(fontSize: 18, color: Colors.black)),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeyPadButton(
                        label: "7",
                        action: () {
                          setState(() {
                            dispVal += "7";
                          });
                        }),
                    KeyPadButton(
                        label: "8",
                        action: () {
                          setState(() {
                            dispVal += "8";
                          });
                        }),
                    KeyPadButton(
                        label: "9",
                        action: () {
                          setState(() {
                            dispVal += "9";
                          });
                        }),
                    OperationButton(
                        label: "/",
                        action: () {
                          if (dispVal.isNotEmpty) {
                            if (dispVal.characters.last != "/") {
                              dispVal += "/";
                            }
                          }
                          setState(() {});
                        }),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeyPadButton(
                        label: "4",
                        action: () {
                          setState(() {
                            dispVal += "4";
                          });
                        }),
                    KeyPadButton(
                        label: "5",
                        action: () {
                          setState(() {
                            dispVal += "5";
                          });
                        }),
                    KeyPadButton(
                        label: "6",
                        action: () {
                          setState(() {
                            dispVal += "6";
                          });
                        }),
                    OperationButton(
                        label: "-",
                        action: () {
                          setState(() {
                            dispVal += "-";
                          });
                        }),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeyPadButton(
                        label: "1",
                        action: () {
                          setState(() {
                            dispVal += "1";
                          });
                        }),
                    KeyPadButton(
                        label: "2",
                        action: () {
                          setState(() {
                            dispVal += "2";
                          });
                        }),
                    KeyPadButton(
                        label: "3",
                        action: () {
                          setState(() {
                            dispVal += "3";
                          });
                        }),
                    OperationButton(
                        label: "x",
                        action: () {
                          setState(() {
                            dispVal += "x";
                          });
                        }),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeyPadButton(
                        label: ".",
                        action: () {
                          setState(() {
                            dispVal += ".";
                          });
                        }),
                    KeyPadButton(
                        label: "0",
                        action: () {
                          if (dispVal.isNotEmpty) {
                            setState(() {
                              dispVal += "0";
                            });
                          }
                        }),
                    KeyPadButton(
                        label: "=",
                        action: () {
                          Parser buildParser() {
                            final builder = ExpressionBuilder();
                            builder.group()
                              ..primitive((pattern('+-').optional() &
                                      digit().plus() &
                                      (char('.') & digit().plus()).optional() &
                                      (pattern('eE') &
                                              pattern('+-').optional() &
                                              digit().plus())
                                          .optional())
                                  .flatten('number expected')
                                  .trim()
                                  .map(num.tryParse))
                              ..wrapper(char('(').trim(), char(')').trim(),
                                  (left, value, right) => value);
                            builder
                                .group()
                                .prefix(char('-').trim(), (op, num a) => -a);
                            builder.group().right(char('^').trim(),
                                (num a, op, num b) => pow(a, b));
                            builder.group()
                              ..left(
                                  char('x').trim(), (num a, op, num b) => a * b)
                              ..left(char('/').trim(),
                                  (num a, op, num b) => a / b);
                            builder.group()
                              ..left(
                                  char('+').trim(), (num a, op, num b) => a + b)
                              ..left(char('-').trim(),
                                  (num a, op, num b) => a - b);
                            return builder.build().end();
                          }

                          final parser = buildParser();

                          final result = parser.parse(dispVal);

                          setState(() {
                            answer = double.parse('${result.value}');
                          });
                          // _history.add(dispVal);
                        }),
                    OperationButton(
                        label: "+",
                        action: () {
                          setState(() {
                            dispVal += "+";
                          });
                        }),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                KeyPadButton(
                    label: "CLEAR",
                    action: () {
                      setState(() {
                        dispVal = "";
                        answer = 0;
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KeyPadButton extends StatelessWidget {
  const KeyPadButton({
    Key? key,
    required String label,
    required Function action,
  })  : text = label,
        this.action = action,
        super(key: key);
  final String text;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => action(),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      style: TextButton.styleFrom(
        elevation: 10,
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),*/
        padding: const EdgeInsets.all(20),
        primary: Colors.blue,
        backgroundColor:
            text == "=" ? Color.fromRGBO(30, 38, 53, 1) : Colors.yellow,
      ),
    );
  }
}

class OperationButton extends StatelessWidget {
  const OperationButton({
    Key? key,
    required String label,
    required Function action,
  })  : text = label,
        this.action = action,
        super(key: key);
  final String text;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          action();
        },
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
        style: TextButton.styleFrom(
          shape: CircleBorder(),
          padding: const EdgeInsets.all(20),
          primary: Colors.blue,
          backgroundColor: Color.fromRGBO(30, 38, 53, 1),
        ));
  }
}

class ClearButton extends StatelessWidget {
  const ClearButton({
    Key? key,
    required String label,
    required Function action,
  })  : text = label,
        this.action = action,
        super(key: key);
  final String text;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          action();
        },
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
        style: TextButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 120),
            primary: Colors.blue,
            backgroundColor: Colors.white));
  }
}
