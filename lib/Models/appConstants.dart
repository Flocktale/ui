import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/internet_error_flushbar.dart';
import 'package:flocktale/services/connectivityCheck.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static AppConfigs appConfigs;

  static String installedVersion;

  static final internetErrorFlushBar = InternetErrorFlushbar();

  static ConnectionStatusSingleton connectionStatus;

  static BuildContext rootContext;
}