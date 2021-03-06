import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController heightController;
  TextEditingController weightController;
  TextEditingController agoController;
  bool isResultDisabled;

  @override
  void initState() {
    super.initState();
    heightController = new TextEditingController(text: '');
    weightController = new TextEditingController(text: '');
    isResultDisabled = true;
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text('BMI Calculator'),
        ),
        body: new Column(
          children: [
            new Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              child: new Column(
                children: <Widget>[
                  new Text('BMIを計算します。\n身長/体重/年齢を入力してください。',
                      textAlign: TextAlign.center),
                  new Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: new TextField(
                      inputFormatters: <TextInputFormatter>[
                        new WhitelistingTextInputFormatter(
                            new RegExp(r'[0-9]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: '身長(cm)を入力(整数)',
                        hintText: '170',
                        suffixText: 'cm',
                      ),
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      maxLength: 3,
                      autofocus: true,
                      onChanged: _editing,
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: new TextField(
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: '体重(kg)を入力(整数)',
                        hintText: '67',
                        suffixText: 'kg',
                      ),
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      maxLength: 3,
                      autofocus: true,
                      onChanged: _editing,
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                  Result()
                ],
              ),
            ),
          ],
        ),
      );

  String _editing(String newValue) {
    setState(() {
      isResultDisabled =
          weightController.text.isEmpty || heightController.text.isEmpty;
    });
    return newValue;
  }

  Widget Result() {
    if (isResultDisabled) {
      return new Text('(・∀・)スンスンスーン');
    }
    double _weight = double.parse(weightController.text);
    double _height = double.parse(heightController.text);
    // Dartってべき乗演算子ないんだね(´・ω・`)
    String _bmi = (_weight / math.pow(_height, 2) * 10000).toStringAsFixed(2);
    String _standard_weight =
        (22 * math.pow(_height, 2) / 10000).toStringAsFixed(2);
    var status = double.parse(_bmi) >= 25
        ? '肥満'
        : double.parse(_bmi) > 18.5 ? '標準' : '低体重';

    return new Column(children: <Widget>[
      new RichText(
        textAlign: TextAlign.center,
        text: new TextSpan(
          text: 'あなたのBMIは…\n',
          style: new TextStyle(color: Colors.black),
          children: <TextSpan>[
            new TextSpan(text: _bmi, style: DefaultTextStyle.of(context).style),
          ],
        ),
      ),
      new Padding(padding: EdgeInsets.only(top: 30.0)),
      new RichText(
        textAlign: TextAlign.center,
        text: new TextSpan(
          text: 'あなたは…\n',
          style: new TextStyle(color: Colors.black),
          children: <TextSpan>[
            new TextSpan(
                text: '$statusです！',
                style: new TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
      new Padding(padding: EdgeInsets.only(top: 30.0)),
      new Text('標準体重は$_standard_weightでした。')
    ]);
  }
}
