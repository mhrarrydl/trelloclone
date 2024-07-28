import 'package:flutter/material.dart';
import 'package:tutero_test/config/utils/utility.dart';
import 'package:tutero_test/view_model/board_view_model.dart';

class AlertDialogWidget extends StatefulWidget {
  final int listIndex;
  final BoardViewModel viewModel;
  const AlertDialogWidget({
    super.key,
    required this.listIndex,
    required this.viewModel,
  });

  @override
  State<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  String cardTitle = '';
  final formKey = GlobalKey<FormState>();
  String? imagePath = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Card'),
      content: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: imagePath != null && imagePath!.isNotEmpty,
              replacement: ElevatedButton(
                onPressed: () {
                  Utility().imagePicker().then(
                    (value) {
                      setState(() {
                        imagePath = value;
                      });
                    },
                  );
                },
                child: const Text('Select Image'),
              ),
              child: Image.network(
                imagePath!,
                height: 200,
                width: 200,
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter title';
                }
                return null;
              },
              onChanged: (value) {
                cardTitle = value;
              },
              decoration: const InputDecoration(hintText: "Card Title"),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          child: const Text('Add'),
          onPressed: () {
            if (formKey.currentState!.validate() && cardTitle.isNotEmpty) {
              widget.viewModel.addCard(
                listIndex: widget.listIndex,
                title: cardTitle,
                imagePath: imagePath,
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
