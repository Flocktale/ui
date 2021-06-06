import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/internet_error_flushbar.dart';
import 'package:flocktale/services/connectivityCheck.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppConstants {
  static AppConfigs appConfigs;

  static String installedVersion;

  static final internetErrorFlushBar = InternetErrorFlushbar();

  static ConnectionStatusSingleton connectionStatus;

  static BuildContext rootContext;

  static void launchCreateCommunityForm() {
    try {
      launch(
          'https://docs.google.com/forms/d/e/1FAIpQLSfRrRTaSJ2_1n3cCSShRYpDmd4FaJqdm50s3wTR69PMHqCHcw/viewform');
    } catch (e) {}
  }
}
