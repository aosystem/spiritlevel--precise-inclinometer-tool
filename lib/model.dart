import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:spiritlevel/const_value.dart';
import 'package:spiritlevel/l10n/app_localizations.dart';

class Model {
  Model._();

  static const String _prefSensitivity = 'sensitivity';
  static const String _prefScaleType = 'scaleType';
  static const String _prefTweakX = 'tweakX';
  static const String _prefTweakY = 'tweakY';
  static const String _prefThemeNumber = 'themeNumber';
  static const String _prefLanguageCode = 'languageCode';

  static bool _ready = false;
  static double _sensitivity = ConstValue.sensitivityMin;
  static int _scaleType = 0;
  static double _tweakX = 0;
  static double _tweakY = 0;
  static int _themeNumber = 0;
  static String _languageCode = '';

  static double get sensitivity => _sensitivity;
  static int get scaleType => _scaleType;
  static double get tweakX => _tweakX;
  static double get tweakY => _tweakY;
  static int get themeNumber => _themeNumber;
  static String get languageCode => _languageCode;

  static Future<void> ensureReady() async {
    if (_ready) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    _sensitivity = (prefs.getDouble(_prefSensitivity) ?? ConstValue.sensitivityDefault).clamp(ConstValue.sensitivityMin, ConstValue.sensitivityMax);
    _scaleType = (prefs.getInt(_prefScaleType) ?? 0).clamp(0, ConstValue.imageStages.length - 1);
    _tweakX = (prefs.getDouble(_prefTweakX) ?? 0).clamp(-5.0, 5.0);
    _tweakY = (prefs.getDouble(_prefTweakY) ?? 0).clamp(-5.0, 5.0);
    _themeNumber = (prefs.getInt(_prefThemeNumber) ?? 0).clamp(0, 2);
    _languageCode = prefs.getString(_prefLanguageCode) ?? ui.PlatformDispatcher.instance.locale.languageCode;
    _languageCode = _resolveLanguageCode(_languageCode);
    _ready = true;
  }

  static String _resolveLanguageCode(String code) {
    final supported = AppLocalizations.supportedLocales;
    if (supported.any((l) => l.languageCode == code)) {
      return code;
    } else {
      return '';
    }
  }

  static Future<void> setSensitivity(double value) async {
    _sensitivity = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefSensitivity, value);
  }

  static Future<void> setScaleType(int value) async {
    _scaleType = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefScaleType, value);
  }

  static Future<void> setTweakX(double value) async {
    _tweakX = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefTweakX, value);
  }

  static Future<void> setTweakY(double value) async {
    _tweakY = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefTweakY, value);
  }

  static Future<void> setThemeNumber(int value) async {
    _themeNumber = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefThemeNumber, value);
  }

  static Future<void> setLanguageCode(String value) async {
    _languageCode = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefLanguageCode, value);
  }

}
