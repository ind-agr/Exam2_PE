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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  String numero1 = ""; // 0-9
  String operador = ""; // + - /
  String numero2 = ""; // 0-9

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      bottom: false,
      child: Column(children: [
        //output
        Expanded(
          child: SingleChildScrollView(
            reverse: true,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(10),

              //verifica si esta vacio
              child: Text(
                "$numero1 $operador $numero2 ".isEmpty
                    ? "0"
                    : "$numero1 $operador $numero2",
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ),

        //buttons
        Wrap(
          children: Btn.buttonvalues
              .map(
                (value) => SizedBox(
                    width: screenSize.width / 4,
                    height: screenSize.width / 5,
                    child: buildButton(value)),
              )
              .toList(),
        )
      ]),
    ));
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.white24,
        )),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
              child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          )),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  void calculate() {
    if (numero1.isEmpty) return;
    if (operador.isEmpty) return;
    if (numero2.isEmpty) return;

    final double num1 = double.parse(numero1);
    final double num2 = double.parse(numero2);

    var result = 0.0;

    switch (operador) {
      case Btn.suma:
        result = num1 + num2;
        break;

      case Btn.resta:
        result = num1 - num2;
        break;

      case Btn.multiplicacion:
        result = num2 * num1;
        break;

      case Btn.dividir:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      numero1 = "$result";

      if (numero1.endsWith(".0")) {
        numero1 = numero1.substring(0, numero1.length - 2);
      }
      operador = "";
      numero2 = "";
    });
  }

  void clearAll() {
    setState(() {
      numero1 = "";
      operador = "";
      numero2 = "";
    });
  }

  void convertToPercentage() {
    if (numero1.isNotEmpty && operador.isNotEmpty && numero2.isNotEmpty) {
      calculate();
    }
    if (operador.isNotEmpty) {
      return;
    }

    final number = double.parse(numero1);

    setState(() {
      numero1 = "${(number / 100)}";
      operador = "";
      numero2 = "";
    });
  }

  void delete() {
    if (numero2.isNotEmpty) {
      numero2 = numero2.substring(0, numero2.length - 1);
    } else if (operador.isNotEmpty) {
      operador = "";
    } else if (numero1.isNotEmpty) {
      numero1 = numero1.substring(0, numero1.length - 1);
    }

    setState(() {});
  }

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operador.isNotEmpty && numero2.isNotEmpty) {
        calculate();
      }
      operador = value;
    } else if (numero1.isEmpty || operador.isEmpty) {
      if (value == Btn.dot && numero1.contains(Btn.dot)) return;
      if (value == Btn.dot && (numero1.isEmpty || numero1 == Btn.n0)) {
        value = "0.";
      }

      numero1 += value;
    } else if (numero2.isEmpty || operador.isNotEmpty) {
      if (value == Btn.dot && numero2.contains(Btn.dot)) return;
      if (value == Btn.dot && (numero2.isEmpty || numero2 == Btn.n0)) {
        value = "0.";
      }

      numero2 += value;
    }
    setState(() {});
  }

  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Color.fromARGB(255, 238, 218, 218)
        : [
            Btn.per,
            Btn.multiplicacion,
            Btn.suma,
            Btn.resta,
            Btn.dividir,
            Btn.calculate,
          ].contains(value)
            ? Color.fromARGB(255, 255, 51, 0)
            : Color.fromARGB(221, 255, 255, 255);
  }
}

class Btn {
  static const String del = "D";
  static const String clr = "C";
  static const String per = "%";
  static const String dividir = "÷";
  static const String multiplicacion = "×";
  static const String resta = "-";
  static const String calculate = "=";
  static const String dot = ".";
  static const String suma = "+";
  static const String sumRes = "+/-";

  static const String n0 = "0";
  static const String n1 = "1";
  static const String n2 = "2";
  static const String n3 = "3";
  static const String n4 = "4";
  static const String n5 = "5";
  static const String n6 = "6";
  static const String n7 = "7";
  static const String n8 = "8";
  static const String n9 = "9";

  static const List<String> buttonvalues = [
    del,
    clr,
    per,
    dividir,
    n7,
    n8,
    n9,
    multiplicacion,
    n4,
    n5,
    n6,
    resta,
    n1,
    n2,
    n3,
    suma,
    sumRes,
    n0,
    dot,
    calculate,
  ];
}
