import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDeniedDialog extends StatelessWidget {
  const PermissionDeniedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Permission Denied'),
      content: const Text('Please grant permission to use the app'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            openAppSettings();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
