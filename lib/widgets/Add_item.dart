import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:grocessory_app/data/categories.dart';
import 'package:grocessory_app/model/category.dart';
import 'package:grocessory_app/model/category.dart';
import 'package:grocessory_app/model/grocessory_item.dart';

class newItem extends StatefulWidget {
  const newItem({super.key});

  @override
  State<newItem> createState() => _newItemState();
}

class _newItemState extends State<newItem> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  //use global key to ensure that if build method is re-executed the form is not reexecuted

  var _title_name = "";
  var _Quantities = 1;
  var _display_category = categories[Categories.fruit]!;

  void saveform() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(
        GroceryItem(
          id: DateTime.now().toString(),
          name: _title_name,
          quantity: _Quantities,
          category: _display_category,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Items"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: "Item Name",
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must must be between 1 and 50';
                  }
                  return null;
                },
                onSaved: (value) => _title_name = value!,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Quantity",
                        border: UnderlineInputBorder(),
                      ),
                      initialValue: _Quantities.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! < 0) {
                          return 'Must be a valid, Poistive number';
                        }
                        return null;
                      },
                      onSaved: (value) => _Quantities = int.parse(value!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: _display_category,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 25,
                                    height: 25,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(category.value.name),
                                ],
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _display_category = value!;
                          });
                        }),
                  )
                ],
              ),
              //butthon
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text("clear"),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      saveform();
                    },
                    child: const Text("Add Item"),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.background)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
