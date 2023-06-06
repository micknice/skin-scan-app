import 'package:flutter/material.dart';
import 'package:skin_scan_app/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'An error occurred',
    content: text,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
