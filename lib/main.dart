import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = '会社員の年収手取り計算機';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primaryColor: Colors.green[300],
        accentColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            appTitle,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final incomeBeforeTaxController = TextEditingController();
  int _socialInsurance = 0; // 社会保険料額
  int _employmentInsurance = 0; // 雇用保険料額
  int _salalyReduction = 0; // 給与所得控除
  int _basicReduction = 0; // 基礎控除
  int _annualIncome = 0; // 年収
  int _disposableIncome = 0; // 税引後収入
  double _incomeTaxRate = 0; // 所得税率
  int _incomeTaxReduction = 0; // 所得税控除額
  int _incomeTax = 0; // 所得税額
  int _taxableIncome = 0; // 課税所得
  int _residentTax = 0; // 住民税額

  void calculate() {
    _employmentInsurance = getEmploymentInsurance();
    _salalyReduction  = getSalalyReduction();
    _basicReduction   = getBasicReduction();
    _socialInsurance = getSocialInsurance();
    _incomeTaxRate    = getIncomeTaxRate();
    _incomeTaxReduction = getIncomeTaxReduction();
    print(_incomeTaxReduction);
    _incomeTax        = getIncomeTax();
    _residentTax      = getResidentTax();
    _disposableIncome = _annualIncome - _socialInsurance - _incomeTax - _residentTax - _employmentInsurance;
  }
  int getEmploymentInsurance() {
    return (_annualIncome.toDouble() * 0.003).round();
  }
  int getSalalyReduction() {
    int reduction;
    if (_annualIncome <= 1800000) {
      reduction  = (_annualIncome.toDouble() * 0.4).round() - 100000;
      if (reduction < 550000) {
        reduction = 550000;
      }
    } else if (_annualIncome <= 3600000) {
      reduction = (_annualIncome.toDouble() * 0.3).round() + 80000;
    } else if (_annualIncome <= 6600000) {
      reduction = (_annualIncome.toDouble() * 0.2).round() + 440000;
    } else if (_annualIncome <= 8500000) {
      reduction = (_annualIncome.toDouble() * 0.1).round() + 1100000;
    } else {
      reduction = 1950000;
    }
    return reduction;
  }
  int getBasicReduction() {
    int reduction;
    if (_annualIncome <= 240000) {
      reduction = 480000;
    } else if (_annualIncome <= 24500000) {
      reduction = 320000;
    } else if (_annualIncome <= 25000000) {
      reduction = 160000;
    } else {
      reduction = 0;
    }
    return reduction;
  }
  double getIncomeTaxRate() {
    double taxRate;
    _taxableIncome = _annualIncome -  _salalyReduction - _basicReduction - _socialInsurance - _employmentInsurance;
    if (_taxableIncome < 0) {
      _taxableIncome = 0;
    }
    if (_taxableIncome <= 1950000) {
      taxRate = 0.05;
    } else if (_taxableIncome <= 3300000) {
      taxRate = 0.1;
    } else if (_taxableIncome <= 6950000) {
      taxRate = 0.2;
    } else if (_taxableIncome <= 9000000) {
      taxRate = 0.23;
    } else if (_taxableIncome <= 18000000) {
      taxRate = 0.33;
    } else if (_taxableIncome <= 40000000) {
      taxRate = 0.4;
    } else {
      taxRate = 0.45;
    }
    return taxRate;
  }
  int getIncomeTaxReduction() {
    int incomeTaxReduction;
    if (_taxableIncome <= 1950000) {
      incomeTaxReduction = 0;
    } else if (_taxableIncome <= 3300000) {
      incomeTaxReduction = 97500;
    } else if (_taxableIncome <= 6950000) {
      incomeTaxReduction = 427500;
    } else if (_taxableIncome <= 9000000) {
      incomeTaxReduction = 636000;
    } else if (_taxableIncome <= 18000000) {
      incomeTaxReduction = 1536000;
    } else if (_taxableIncome <= 40000000) {
      incomeTaxReduction = 2796000;
    } else {
      incomeTaxReduction = 4790000;
    }
    return incomeTaxReduction;
  }
  int getIncomeTax() {
    return (_taxableIncome.toDouble() * _incomeTaxRate).round() - _incomeTaxReduction;
  }
  int getSocialInsurance() {
    if (_annualIncome >= 1355000*12) {
      return 1653204;
    } else if(_annualIncome >= 1210000*12) {
      return (_annualIncome.toDouble() * 0.105).round();
    } else if(_annualIncome >= 980000*12) {
      return (_annualIncome.toDouble() * 0.11).round();
    } else if(_annualIncome >= 830000*12) {
      return (_annualIncome.toDouble() * 0.126).round();
    } else if(_annualIncome >= 750000*12) {
      return (_annualIncome.toDouble() * 0.133).round();
    } else if(_annualIncome >= 680000*12) {
      return (_annualIncome.toDouble() * 0.141).round();
    }
    else {
      return (_annualIncome.toDouble() * 0.15).round();
    }
  }
  int getResidentTax() {
    return (_taxableIncome.toDouble() * 0.10).round();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(
                  '年収を入力してください',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: TextFormField(
                  controller: incomeBeforeTaxController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '6000000'
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '手取りを計算したい年収額を入力してください';
                    }
                    if (int.parse(value) < 0) {
                      return '0円より大きな金額を入力して下さい';
                    }
                    if (int.parse(value) > 1000000000000) {
                      return '1兆円より小さな金額を入力して下さい';
                    }
                    return null;
                  },
                  onSaved: (value) => setState(() {
                    _annualIncome = int.parse(value);
                    calculate();
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Center(
                  child: ButtonTheme(
                    minWidth: 150.0,
                    height: 50.0,
                    child: FlatButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        // otherw
                        if (_formKey.currentState.validate()) {
                          if (this._formKey.currentState.validate()) {
                            this._formKey.currentState.save();
                          }
                        }
                      },
                      child: Text(
                        '計算',
                        style: TextStyle(
                          color: Colors.green[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        )
                      ),
                      color: Colors.white,
                        shape: StadiumBorder(
                        side: BorderSide(color: Colors.green[300]),
                      ),
                    ),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Text(
                  "手取り額: " + _disposableIncome.toString() + "円",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  "給与所得控除: " + _salalyReduction.toString() + "円",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  "基礎控除: " + _basicReduction.toString() + "円",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  "社会保険料: " + _socialInsurance.toString() + "円",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  "課税所得: " + _taxableIncome.toString() + "円",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  "所得税率: " + (_incomeTaxRate * 100.0).toString() + "%",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  "所得税控除額: " + (_incomeTaxReduction).toString() + "円",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  "所得税額: " + _incomeTax.toString() + "円",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  "住民税額: " + _residentTax.toString() + "円",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(
                  "雇用保険料額: " + _employmentInsurance.toString() + "円",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "計算方法: \n年収 - 所得税額 - 住民税額 - 社会保険料 - 雇用保険料額 = " + _annualIncome.toString() + " - " + _incomeTax.toString() + " - " + _residentTax.toString() + " - " + _socialInsurance.toString() + " - " + _employmentInsurance.toString() + " = " + _disposableIncome.toString(),
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "この結果は簡易計算のため目安としてお考えください。",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  )
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
