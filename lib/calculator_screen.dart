import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {

  String number1 = ""; // 1-9
  String operand = ""; // *-+/
  String number2 = ""; // 1-9

  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
          //output

          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$number1$operand$number2".isEmpty?"0"
                  :"$number1$operand$number2",
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
            children:  Btn.buttonValues
            .map((value) => SizedBox(
              width: screenSize.width/4,
              height: screenSize.width/5,
              child: buildButton(value)),
            )
            .toList(),
          )
        ],),
      ),
    );
  }


  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
          borderRadius: BorderRadius.circular(32)
          ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            
            child: Text(value,style: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 24),
              ),
            ),
        ),
      ),
    );
  }

//funtion for the value
void onBtnTap(String value){
  if(value==Btn.del){
    delete();
    return;
  }

  if(value==Btn.clr){
    clearAll();
    return;
  }

  if(value==Btn.per){
    convertToPercentage();
    return;
  }

  if(value==Btn.equal){
    calculate();
    return;
  }

appendValue(value);

}

// calculate the value
void calculate(){
  if(number1.isEmpty) return;
  if(operand.isEmpty) return;
  if(number2.isEmpty) return;

  final double n1 = double.parse(number1);
  final double n2 = double.parse(number2);

  var result = 0.0;
  switch(operand){
    case Btn.add:
    result = n1 + n2;
    break;
    case Btn.subtract:
    result = n1 - n2;
    break;
    case Btn.multiply:
    result = n1 * n2;
    break;
    case Btn.devide:
    result = n1 / n2;
    break;
    default:
  }
  setState(() {
    number1 = "$result";

    if(number1.endsWith(".0")){
      number1=number1.substring(0, number1.length - 2);
    }

    operand = "";
    number2 = "";
  });
}

// converting to percentage
void convertToPercentage(){
  if(number1.isNotEmpty&&operand.isNotEmpty&&number2.isNotEmpty){
    // calculate before convertion
    calculate();
  }
  if(operand.isNotEmpty){
    // cannot be converted
    return;
  }
  final number = double.parse(number1); // setting it to double number
  setState(() {
    number1 = "${(number / 100)}";
    operand = "";
    number2 = "";
  });
}

// clear all values on the screen
void clearAll(){
  setState(() {
    number1 = "";
    operand = "";
    number2 = "";
  });
}

// delete function
void delete(){
  if(number2.isNotEmpty){
    number2=number2.substring(0, number2.length - 1);
  }else if(operand.isNotEmpty){
    operand = "";
  }else if(number1.isNotEmpty){
    number1=number1.substring(0,number1.length - 1);
  }
  setState(() {});
}

//append value to the end
void appendValue(String value){

  if(value!=Btn.dot&&int.tryParse(value)==null){//not number value, operand is pressed
    //check if not empty
    if(operand.isNotEmpty&&number2.isNotEmpty){
      //calculate the assign value
      calculate();
    }
    operand = value;
    //assiging value to number1 variable

  }else if(number1.isEmpty || operand.isEmpty){ //checking the number if empty and if number1 = 1.2
    if(value==Btn.dot && number1.contains(Btn.dot)) return;
    if(value==Btn.dot && (number1.isEmpty || number1==Btn.dot)) { // check if number is empty or 0
      value = "0.";
    }
    
    number1 += value;
  }else if(number2.isEmpty || operand.isNotEmpty){ //checking the number if empty and if number1 = 1.2
    if(value==Btn.dot && number2.contains(Btn.dot)) return;
    if(value==Btn.dot && (number2.isEmpty || number2==Btn.dot)) { // check if number is empty or 0
      value = "0.";
    }
    
    number2 += value;
  }

  setState(() {});//showing the press button on the screen
  
}

//Button color
  Color getBtnColor(value){
    return [Btn.del,Btn.clr].contains(value)?Colors.blueGrey:
        [
          Btn.per,
          Btn.multiply,
          Btn.add,
          Btn.subtract,
          Btn.devide,
          Btn.equal].contains(value)?
          Colors.orange: 
          Colors.black87;
  }
}