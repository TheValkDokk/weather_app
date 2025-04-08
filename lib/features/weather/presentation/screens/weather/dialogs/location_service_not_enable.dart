import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class LocationServiceNotEnabledDialog extends StatelessWidget {
  const LocationServiceNotEnabledDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Location service not enabled'),
      content: const Text('Please enable location service to use this app'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            AppSettings.openAppSettings(type: AppSettingsType.location);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
