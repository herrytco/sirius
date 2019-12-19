import 'package:flutter/material.dart';

class AddFruitDialog extends StatefulWidget {
  @override
  _AddFruitDialogState createState() => _AddFruitDialogState();

  AddFruitDialog(this.onSave);

  final Function(String, String, int) onSave;
}

class _AddFruitDialogState extends State<AddFruitDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _description;
  int _weight;

  void _onSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.of(context).pop();
      widget.onSave(_name, _description, _weight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Fruit"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Name of the Fruit",
              ),
              validator: (String value) {
                if (value.trim().isEmpty) return "Value must not be emtpy!";

                return null;
              },
              onSaved: (String value) => _name = value,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Description of the Fruit",
              ),
              validator: (String value) {
                if (value.trim().isEmpty) return "Value must not be emtpy!";

                return null;
              },
              onSaved: (String value) => _description = value,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Weight",
              ),
              validator: (String value) {
                if (value.trim().isEmpty) return "Value must not be emtpy!";

                try {
                  int.parse(value);
                } catch (_) {
                  return "Value must be numeric!";
                }

                return null;
              },
              onSaved: (String value) => _weight = int.parse(value),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Abbrechen"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text("Hinzufügen"),
          onPressed: _onSubmit,
        ),
      ],
    );
  }
}
