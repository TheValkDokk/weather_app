import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class NoInternetConnectionDialog extends StatelessWidget {
  const NoInternetConnectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('No Internet Connection'),
      content: const Text(
        'Please check your internet connection and try again',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (Platform.isAndroid) {
              AppSettings.openAppSettingsPanel(
                AppSettingsPanelType.internetConnectivity,
              );
            } else {
              AppSettings.openAppSettings(type: AppSettingsType.wifi);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
