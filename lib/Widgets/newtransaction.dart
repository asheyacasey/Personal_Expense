import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class newTransaction extends StatefulWidget {

  late final Function addTx;

  newTransaction(this.addTx);

  @override
  State<newTransaction> createState() => _newTransactionState();
}

class _newTransactionState extends State<newTransaction> {
  DateTime _selectedDate = DateTime.now();
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void submitData() {
    if (amountController.text.isEmpty){
   return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if(enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
        enteredTitle,
        enteredAmount,
        _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker(){
    showDatePicker(context: context, initialDate: DateTime.now(),
    firstDate: DateTime(2019), lastDate: DateTime.now(),
    ).then((pickedDate) {
      if(pickedDate == null) {
        return;
      }
      setState((){
        _selectedDate = pickedDate;
      });

    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top:10,
            left:10,
            right:10,
            bottom:MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitData,
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData,
                // onChanged: (val) => amountInput = val,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text( _selectedDate == null
                          ? 'No date choosen'
                          : 'Picked Date: ${ DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    FlatButton(textColor: Theme.of(context).primaryColor,child: Text('Choose Date', style: TextStyle(fontWeight: FontWeight.bold),),
                      onPressed: _presentDatePicker,),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
