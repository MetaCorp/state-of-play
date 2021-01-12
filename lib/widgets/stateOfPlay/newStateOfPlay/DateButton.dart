import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef ChangeCallback = void Function(DateTime);

class DateButton extends StatefulWidget {
  DateButton({ Key key, this.onChange, this.value, this.labelText }) : super(key: key);

  final ChangeCallback onChange;
  final DateTime value;
  final String labelText;

  @override
  _DateButtonState createState() => _DateButtonState();
}

class _DateButtonState extends State<DateButton> {

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.value != null ? widget.value : DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101)
    );
    if (picked != null && picked != widget.value)
      widget.onChange(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.labelText + ' :'),
        FlatButton(
          child: Text(widget.value != null ? DateFormat('dd/MM/yyyy').format(widget.value) : 'Selectionner une date'),
          onPressed: () => _selectDate(context),
        )
      ]
    );
  }
}