import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {

  String number1 = ""; 
  String operand = ""; 
  String number2 = ""; 

  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
            
          
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
                    fontWeight: FontWeight.normal,
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
                child: buildButton(value)),)
              .toList(),
            )
          ],),
        ),
      ),
    );
  }



  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
          borderRadius: BorderRadius.circular(4)
          ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            
            child: Text(value,style: const TextStyle(
              fontWeight: FontWeight.normal, 
              fontSize: 24),
              ),
            ),
        ),
      ),
    );
  }


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


void convertToPercentage(){
  if(number1.isNotEmpty&&operand.isNotEmpty&&number2.isNotEmpty){
    
    calculate();
  }
  if(operand.isNotEmpty){
    
    return;
  }
  final number = double.parse(number1);
  setState(() {
    number1 = "${(number / 100)}";
    operand = "";
    number2 = "";
  });
}


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

  if(value!=Btn.dot&&int.tryParse(value)==null){ 
    if(operand.isNotEmpty&&number2.isNotEmpty){
      calculate();
    }
    operand = value;

  }else if(number1.isEmpty || operand.isEmpty){
    if(value==Btn.dot && number1.contains(Btn.dot)) return;
    if(value==Btn.dot && (number1.isEmpty || number1==Btn.dot)) {
      value = "0.";
    }
    
    number1 += value;
  }else if(number2.isEmpty || operand.isNotEmpty){ 
    if(value==Btn.dot && number2.contains(Btn.dot)) return;
    if(value==Btn.dot && (number2.isEmpty || number2==Btn.dot)) { 
      value = "0.";
    }
    
    number2 += value;
  }

  setState(() {}); 
  
}

//Button color
  Color getBtnColor(value){
    if (value == Btn.del) {
    return Colors.red;  
  }

 if (value == Btn.equal) {
    return Colors.orange;  
  }
  
    if ([Btn.per, Btn.multiply, Btn.add, Btn.subtract, Btn.devide, Btn.clr].contains(value)) {
    return const Color.fromARGB(164, 103, 103, 103);  
  } else {
    return const Color.fromARGB(54, 28, 28, 28);  
  }
}
}