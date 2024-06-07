import 'package:flutter/material.dart';

void main() {
  runApp(BMICalculator());
}

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BMICalculatorHomePage(),
    );
  }
}

class BMICalculatorHomePage extends StatefulWidget {
  @override
  _BMICalculatorHomePageState createState() => _BMICalculatorHomePageState();
}

class _BMICalculatorHomePageState extends State<BMICalculatorHomePage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double _bmi = 0;
  String _bmiCategory = '';
  IconData _bmiIcon = Icons.error;
  Color _bmiColor = Colors.black;
  bool _showResult = false;
  bool _inputValid = true;

  @override
  void initState() {
    super.initState();
    _showResult = false;
    _heightController.addListener(_onTextFieldChanged);
    _weightController.addListener(_onTextFieldChanged);
  }

  @override
  void dispose() {
    _heightController.removeListener(_onTextFieldChanged);
    _weightController.removeListener(_onTextFieldChanged);
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _onTextFieldChanged() {
    final double height = double.tryParse(_heightController.text) ?? 0;
    final double weight = double.tryParse(_weightController.text) ?? 0;
    setState(() {
      _inputValid = height > 0 && weight > 0;
      if (_inputValid) {
        _calculateBMI();
      } else {
        _showResult = false;
      }
    });
  }

  void _calculateBMI() {
    final double height = double.tryParse(_heightController.text) ?? 0;
    final double weight = double.tryParse(_weightController.text) ?? 0;
    setState(() {
      _bmi = weight / (height * height);
      if (_bmi < 18.5) {
        if (_bmi < 16) {
          _bmiCategory = 'Severely Underweight';
        } else {
          _bmiCategory = 'Underweight';
        }
        _bmiIcon = Icons.sentiment_very_dissatisfied;
        _bmiColor = Colors.blue;
      } else if (_bmi < 24.9) {
        _bmiCategory = 'Normal weight';
        _bmiIcon = Icons.sentiment_satisfied;
        _bmiColor = Colors.green;
      } else if (_bmi < 29.9) {
        _bmiCategory = 'Overweight';
        _bmiIcon = Icons.sentiment_dissatisfied;
        _bmiColor = Colors.orange;
      } else if (_bmi < 40) {
        // Show prompt for high BMI
        _bmiCategory = 'Obese';
        _bmiIcon = Icons.sentiment_very_dissatisfied;
        _bmiColor = Colors.red;
      } else {
        // Show prompt for very high BMI
        _bmiCategory = 'Extremely Obese';
        _bmiIcon = Icons.sentiment_very_dissatisfied;
        _bmiColor = Colors.red;
      }
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Height (m)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.height),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.line_weight),
                ),
              ),
              SizedBox(height: 20),
              if (_showResult)
                SizedBox(
                  width: double.infinity,
                  height: 100, // Fixed height for the card
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            _bmiIcon,
                            size: 40,
                            color: _bmiColor,
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _bmiCategory,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: _bmiColor,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Your BMI is ${_bmi.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!_inputValid && !_showResult)
                SizedBox(
                  width: double.infinity,
                  height: 100, // Fixed height for the card
                  child: Card(
                    elevation: 4,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Please enter valid height and weight.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
