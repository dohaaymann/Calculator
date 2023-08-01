import 'package:flutter/material.dart';
import 'package:stack/stack.dart' as route;
import 'dart:math';
import 'package:flutter/src/widgets/basic.dart';

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
      theme: ThemeData(),debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Calculator'),
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
  String output = "0", expp = "", cac = "";
  int x = 0, j = 0;
  double o1 = 0, o2 = 0;
  String res = "", text = "0";
  route.Stack<String> s = route.Stack();
  route.Stack<double> q = route.Stack();

  double calc(double o1, double o2, var c) {
    if (c == '+') return o1 + o2;
    if (c == '-') return o1 - o2;
    if (c == '×') return o1 * o2;
    if (c == '÷') return (o1 / o2);
    return 0;
  }

  //--------------------------------------
  String evaluate(String exp) {
    double r = 0;
    double dig = 0;
    String a = " ";
    int i = 0;

    while (i < exp.length) {
      var e = exp[i];
      var c = '.';
      if (Isdigit(exp[i]) && exp[i] != ' ' && exp[i] != '.') {
        dig = dig * 10 + (double.parse(exp[i]));
        a += exp[i];
      } else if (exp[i] == '.') {
        a += '.';
      } else if (exp[i] == ' ') {
        for (int j = 0; j < a.length; j++) {
          if (a[j] == '.') {
            {
              x = ((a.length - 1) - j);
              break;
            }
          }
        }
        double z = (dig / pow(10, x));
        q.push(z);
        dig = 0;
        a = ' ';
        x = 0;
      } else {
        o2 = q.top();
        q.pop();
        o1 = q.top();
        q.pop();
        r = calc(o1, o2, e);
        q.push(r);
        i++;
      }
      i++;
    }
    //expp=q.top().toString();
    String cac = q.top().toString();
    setState(() {
      cac = q.top().toString();
    });
    setState(() {
      cac = q.top().toString();
    });
    return cac;
  }

  //---------------------------------------------
  bool isOperator(var c) {
    if (c == '+' || c == '-' || c == '×' || c == '÷' || c == '^') {
      return true;
    } else {
      return false;
    }
  }

  int precedence(var c) {
    if (c == '^')
      return 3;
    else if (c == '×' || c == '÷')
      return 2;
    else if (c == '+' || c == '-')
      return 1;
    else
      return -1;
  }

  bool Isdigit(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  //---------------------------------------------------
  String InfixToPostfix(String infix) {
    // int postfix=0;

    String postfix = "";
    for (int i = 0; i < infix.length; i++) {
      int d = 0;
      var c = '.';
      if (Isdigit(infix[i])) {
        postfix += infix[i];
      }

      if (infix[i] == c) {
        postfix += c;
      } else if (infix[i] == '(') {
        s.push((infix[i]));
      } else if (infix[i] == ')') {
        while ((s.top() != '(') && (!s.isEmpty)) {
          var temp = s.top();
          postfix = postfix + " ";
          postfix += temp;
          s.pop();
        }
        if (s.top() == '(') {
          s.pop();
        }
      } else if (isOperator(infix[i])) {
        postfix = postfix + " ";
        if (s.isEmpty) {
          s.push((infix[i]));
        } else {
          if (precedence(infix[i]) > precedence(s.top())) {
            s.push((infix[i]));
          } else if ((precedence(infix[i]) == precedence(s.top())) &&
              (infix[i] == '^')) {
            s.push((infix[i]));
          } else {
            while (
                (!s.isEmpty) && (precedence(infix[i]) <= precedence(s.top()))) {
              postfix += s.top();
              s.pop();
              postfix = postfix + " ";
            }
            s.push((infix[i]));
          }
        } //postfix = postfix + " ";
      }
    }
    while (!s.isEmpty) {
      postfix = postfix + " ";
      postfix += s.top();
      s.pop();
    }
    expp = postfix;
    setState(() {
      expp = postfix;
    });
    return postfix;
  }

  //--------------------------------------------------------------------
  void btnClicked(String btnText) {
    if (btnText == 'del') {
      setState(() {
        text = "0";
        res = "";
        expp = "";
        cac = "";
        output = "0";
      });
    } else if (btnText == '=') {
      expp = text;
      InfixToPostfix(text);
      output = evaluate(expp);
    } else if (btnText == 'Ans') {
      res = text + evaluate(expp);
    }
    else if (btnText == '+') {
      res = text + btnText;
    } else if (btnText == '×') {
      res = text + btnText;
    } else if (btnText == '-') {
      res = text + btnText;
    } else if (btnText == '0') {
      res = text + btnText;
    } else if (btnText == '^') {
      print("---------------");
      print("text:" + text);
      print("expp:" + expp);
      print("cac:" + cac);
      print("cac2:" + evaluate(expp));
      print("res:" + res);
      print("---------------");
    } else {
      res = text + btnText;
    }
    setState(() {
      text = res;
    });
  }

  @override
  Widget TextButton(String val) {
    return Expanded(
      child:
        Container(height: 65,decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.red),
          margin: EdgeInsets.all(2),
          child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              btnClicked(val);
            },
            child: Text(
              val,
              style: TextStyle(fontSize: 37, color: Colors.white),
            ),
          ),
        ),
      // ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.deepPurple,
          title: Text("Calculator",style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,color: Colors.white)),
        ),
        body: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                width: double.infinity,
                height: 100,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 8, top: 6),
                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Stack(children: [
                  Text(text,
                      style: TextStyle(color: Colors.white, fontSize: 40))
                ])),
            Container(
              width: double.infinity,
              height: 100,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Text(output,
                  style: TextStyle(color: Colors.white, fontSize: 40)),
            ),
            Container(
                margin: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: <Widget>[
                        TextButton("AC"),
                        TextButton("del"),
                        TextButton("Ans"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        TextButton("("),
                        TextButton(")"),
                        TextButton("^"),
                        TextButton("÷"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        TextButton("7"),
                        TextButton("8"),
                        TextButton("9"),
                        TextButton("×"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        TextButton("4"),
                        TextButton("5"),
                        TextButton("6"),
                        TextButton("-"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        TextButton("1"),
                        TextButton("2"),
                        TextButton("3"),
                        TextButton("+"),

                      ],
                    ),
                    Row(
                      children: <Widget>[
                        TextButton("0"),
                        TextButton("."),
                        Container(height: 65,width: 160,decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10), color: Colors.red),
                          margin: EdgeInsets.all(2),
                          child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                            onPressed: () {
                              btnClicked('=');
                            },
                            child: Text(
                              '=',
                              style: TextStyle(fontSize: 37, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        )));
  }
}

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String output = "0";
//
//   String _output = "0";
//   double num1 = 0.0;
//   double num2 = 0.0;
//   String operand = "";
//
//   buttonPressed(String buttonText) {
//     if (buttonText == "CLEAR") {
//       _output = "0";
//       num1 = 0.0;
//       num2 = 0.0;
//       operand = "";
//     } else if (buttonText == "+" ||
//         buttonText == "-" ||
//         buttonText == "/" ||
//         buttonText == "X") {
//       num1 = double.parse(output);
//
//       operand = buttonText;
//
//       _output = "0";
//     } else if (buttonText == ".") {
//       if (_output.contains(".")) {
//         return;
//       } else {
//         _output = _output + buttonText;
//       }
//     } else if (buttonText == "=") {
//       num2 = double.parse(output);
//
//       if (operand == "+") {
//         _output = (num1 + num2).toString();
//       }
//       if (operand == "-") {
//         _output = (num1 - num2).toString();
//       }
//       if (operand == "X") {
//         _output = (num1 * num2).toString();
//       }
//       if (operand == "/") {
//         _output = (num1 / num2).toString();
//       }
//
//       num1 = 0.0;
//       num2 = 0.0;
//       operand = "";
//     } else {
//       _output = _output + buttonText;
//     }
//
//     setState(() {
//       output = double.parse(_output).toStringAsFixed(2);
//     });
//   }
//
//   Widget buildButton(String buttonText) {
//     return Expanded(
//         child: OutlinedButton(
//           style: OutlinedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(0.0),
//             ),
//             side: const BorderSide(width: 1, color: Colors.grey),
//             minimumSize: const Size.fromHeight(50.0), // Set this
//             padding: EdgeInsets.zero, // and this
//           ),
//           child: Text(
//             buttonText,
//             style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//           ),
//           onPressed: () => buttonPressed(buttonText),
//         ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Calculator"),
//         ),
//         body: Column(
//           children: <Widget>[
//             const Expanded(
//               child: Divider(
//                 color: Colors.white,
//               ),
//             ),
//             Column(children: [
//               Container(
//                   alignment: Alignment.centerRight,
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 24.0, horizontal: 12.0),
//                   child: Text(output,
//                       style: const TextStyle(
//                         fontSize: 48.0,
//                         fontWeight: FontWeight.bold,
//                       ))),
//               Row(children: [
//                 buildButton("7"),
//                 buildButton("8"),
//                 buildButton("9"),
//                 buildButton("/")
//               ]),
//               Row(children: [
//                 buildButton("4"),
//                 buildButton("5"),
//                 buildButton("6"),
//                 buildButton("X")
//               ]),
//               Row(children: [
//                 buildButton("1"),
//                 buildButton("2"),
//                 buildButton("3"),
//                 buildButton("-")
//               ]),
//               Row(children: [
//                 buildButton("."),
//                 buildButton("0"),
//                 buildButton("00"),
//                 buildButton("+")
//               ]),
//               Row(children: [
//                 buildButton("CLEAR"),
//                 buildButton("="),
//               ])
//             ])
//           ],
//         ));
//   }
// }
