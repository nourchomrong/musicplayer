import 'package:flutter/foundation.dart';

class Logger {
  static void info(String msg) {
    debugPrint("info $msg");
  }

  static void success(String msg) {
    debugPrint("success $msg");
  }

  static void error(String msg) {
    debugPrint("error $msg");
  }

  static void api(String msg) {
    debugPrint("api $msg");
  }
}