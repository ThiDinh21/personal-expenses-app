import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransactionInput extends StatefulWidget {
  final Function addTransaction;

  NewTransactionInput(this.addTransaction);

  @override
  _NewTransactionInputState createState() => _NewTransactionInputState();
}

class _NewTransactionInputState extends State<NewTransactionInput> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selecetedDate;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // Get the current year - 1 -> first date will be first day of the last year.
      firstDate: DateTime(DateTime.parse(DateTime.now().toString()).year - 1),
      lastDate: DateTime.now(),
    ).then((pickedData) {
      if (pickedData == null) return;
      setState(() {
        _selecetedDate = pickedData;
      });
    });
  }

  void _submitData() {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selecetedDate == null) {
      return;
    }
    var enteredTitle = _titleController.text;
    var enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    widget.addTransaction(
      enteredTitle,
      enteredAmount,
      _selecetedDate,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          height: MediaQuery.of(context).viewInsets.bottom * 100 +
              MediaQuery.of(context).size.height * 0.5 -
              MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(
            left: 10,
            top: 10,
            right: 10,
            bottom: 10, // For the soft keyboard
          ),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selecetedDate == null
                            ? 'No date chosen!'
                            : "Picked date: ${DateFormat.yMd().format(_selecetedDate)}",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'Chose date.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Add Transaction'),
              )
            ],
          ),
        ),
        elevation: 5,
      ),
    );
  }
}
