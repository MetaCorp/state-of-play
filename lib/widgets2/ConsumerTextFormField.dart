import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tests/providers/NewStateOfPlayProvider.dart';

class ConsumerTextFormField extends StatelessWidget {
  ConsumerTextFormField({this.controller, this.decoration, this.validator, this.modelVariable});

  // Fields in a Widget subclass are always marked "final".

  final TextEditingController controller;
  final InputDecoration decoration;
  final Function validator;
  final String modelVariable;

  @override
  Widget build(BuildContext context) {
    return Consumer<NewStateOfPlayProvider>(
      builder: (context, newStateOfPlayState, child) {
        debugPrint("in builder for consumer: ");
        debugPrint(newStateOfPlayState.value.property.reference);// TODO Abstraire ca via la variable modelVariable
        if (controller.text != newStateOfPlayState.value.property.reference) {
          controller.text = newStateOfPlayState.value.property.reference ?? '';
        }
        return TextFormField(
          controller: controller,
          onChanged: (value) {
            debugPrint("TextField new value: ");
            debugPrint(value);
            newStateOfPlayState.value.property.reference = value;
            context.read<NewStateOfPlayProvider>().update(newStateOfPlayState.value);
          },
          decoration: decoration,
          validator: validator,
        );
      },
    );
  }
}
