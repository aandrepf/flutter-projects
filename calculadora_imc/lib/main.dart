import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

// StatefullWidget - Porque na tela temos estados que serão colocados e podem ser alterados
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = 'Informe seus dados de peso e altura.';

  void _resetFields() {
    weightController.text = '';
    heightController.text = '';
    setState(() {
      _infoText = 'Informe seus dados de peso e altura.';
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;

      double imc = weight / (height * height);

      print('IMC: ${imc.toStringAsPrecision(4)}');

      _imcRange(imc);
    });
  }

  void _imcRange(double imcValue) {
    if (imcValue < 18.6) {
      _infoText = 'Abaixo do Peso: (${imcValue.toStringAsPrecision(4)})';
    } else if (imcValue >= 18.6 && imcValue < 24.9) {
      _infoText = 'Peso Ideal: (${imcValue.toStringAsPrecision(4)})';
    } else if (imcValue >= 24.9 && imcValue < 29.9) {
      _infoText =
          'Levemente Acima do Peso: (${imcValue.toStringAsPrecision(4)})';
    } else if (imcValue >= 29.9 && imcValue < 34.9) {
      _infoText = 'Obesidade Grau I: (${imcValue.toStringAsPrecision(4)})';
    } else if (imcValue >= 34.9 && imcValue < 39.9) {
      _infoText = 'Obesidade Grau II: (${imcValue.toStringAsPrecision(4)})';
    } else if (imcValue >= 40) {
      _infoText = 'Obesidade Grau III: (${imcValue.toStringAsPrecision(4)})';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
        centerTitle: true,
        backgroundColor: Color(0xffa5d6a7),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
      ),
      backgroundColor: Color(0xFF81C784),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.person_outline,
                size: 120,
                color: Color(0xFFFFFFFF),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Peso (KG)',
                  labelStyle: TextStyle(color: Color(0xffffffff)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffffffff)),
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xffffffff), fontSize: 20.0),
                controller: weightController,
                validator: (value) => value.isEmpty ? 'Insira seu peso' : null,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Altura (CM)',
                  labelStyle: TextStyle(color: Color(0xffffffff)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffffffff)),
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xffffffff), fontSize: 20.0),
                controller: heightController,
                validator: (value) =>
                    value.isEmpty ? 'Insira sua altura' : null,
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _calculate();
                      }
                    },
                    child: Text(
                      'Calcular',
                      style:
                          TextStyle(color: Color(0xffffffff), fontSize: 20.0),
                    ),
                    color: Color(0xff1b5e20),
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xffffffff), fontSize: 20.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
