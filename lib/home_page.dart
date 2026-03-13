import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:spiritlevel/ad_manager.dart';
import 'package:spiritlevel/ad_banner_widget.dart';
import 'package:spiritlevel/l10n/app_localizations.dart';
import 'package:spiritlevel/const_value.dart';
import 'package:spiritlevel/setting_page.dart';
import 'package:spiritlevel/model.dart';
import 'package:spiritlevel/main.dart';
import 'package:spiritlevel/theme_mode_number.dart';
import 'package:spiritlevel/theme_color.dart';
import 'package:spiritlevel/parse_locale_tag.dart';
import 'package:spiritlevel/loading_screen.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});
  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> with SingleTickerProviderStateMixin {
  late AdManager _adManager;
  final GlobalKey _aspectRatioKey = GlobalKey();
  double _accelerometerEventX = 0;
  double _accelerometerEventY = 0;
  double _stageWidth = 0;
  double _needleOffsetX = 0;
  double _needleOffsetY = 0;
  //
  late ThemeColor _themeColor;
  bool _isReady = false;
  bool _isFirst = true;


  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    _adManager = AdManager();
    accelerometerEventStream().listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerEventX = event.x + (Model.tweakX * 0.1);
        _accelerometerEventY = event.y + (Model.tweakY * 0.1);
        _needleOffsetX = _stageWidth * Model.sensitivity * _accelerometerEventX;
        _needleOffsetY = _stageWidth * Model.sensitivity * _accelerometerEventY * -1;
        if (_needleOffsetX < - _stageWidth * ConstValue.needleLimit) {
          _needleOffsetX = - _stageWidth * ConstValue.needleLimit;
        } else if (_needleOffsetX > _stageWidth * ConstValue.needleLimit) {
          _needleOffsetX = _stageWidth * ConstValue.needleLimit;
        }
        if (_needleOffsetY < - _stageWidth * ConstValue.needleLimit) {
          _needleOffsetY = - _stageWidth * ConstValue.needleLimit;
        } else if (_needleOffsetY > _stageWidth * ConstValue.needleLimit) {
          _needleOffsetY = _stageWidth * ConstValue.needleLimit;
        }
      });
    });
    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }

  @override
  void dispose() {
    _adManager.dispose();
    super.dispose();
  }

  Future<void> _onOpenSetting() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const SettingPage()),
    );
    if (!mounted) {
      return;
    }
    if (updated == true) {
      final mainState = context.findAncestorStateOfType<MainAppState>();
      if (mainState != null) {
        mainState
          ..themeMode = ThemeModeNumber.numberToThemeMode(Model.themeNumber)
          ..locale = parseLocaleTag(Model.languageCode)
          ..setState(() {});
      }
      _isFirst = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return Scaffold(
        body: LoadingScreen(),
      );
    }
    if (_isFirst) {
      _isFirst = false;
      _themeColor = ThemeColor(themeNumber: Model.themeNumber, context: context);
    }
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _themeColor.mainBackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: _themeColor.mainForeColor,
            tooltip: l.setting,
            onPressed: _onOpenSetting,
          ),
          const SizedBox(width:10),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Stack(children:[
              _preStageArea(),
              _stage(),
              _needleX(),
              _needleY(),
              _needleXY(),
              _textXY(),
            ]),
          ),
        ])
      ),
      bottomNavigationBar: AdBannerWidget(adManager: _adManager),
    );
  }
  Widget _preStageArea() {
    return AspectRatio(
      key: _aspectRatioKey,
      aspectRatio: 1,
    );
  }
  Widget _stage() {
    try {
      RenderBox renderBox = _aspectRatioKey.currentContext?.findRenderObject() as RenderBox;
      _stageWidth = renderBox.size.width;
    } catch (_) {
      return Container();
    }
    return Center(
      child: Image.asset(ConstValue.imageStages[Model.scaleType],
        width: _stageWidth,
        height: _stageWidth,
      ),
    );
  }
  Widget _needleX() {
    return Center(
      child: Transform.translate(
        offset: Offset(_needleOffsetX,0),
        child: Image.asset(ConstValue.imageNeedleX,
          width: _stageWidth,
          height: _stageWidth,
        ),
      ),
    );
  }
  Widget _needleY() {
    return Center(
      child: Transform.translate(
        offset: Offset(0,_needleOffsetY),
        child: Image.asset(ConstValue.imageNeedleY,
          width: _stageWidth,
          height: _stageWidth,
        ),
      ),
    );
  }
  Widget _needleXY() {
    double offsetX = _needleOffsetX;
    double offsetY = _needleOffsetY;
    double length = sqrt(_needleOffsetX * _needleOffsetX + _needleOffsetY * _needleOffsetY);
    if (length > _stageWidth * ConstValue.needleLimit) {
      double scaleFactor = _stageWidth * ConstValue.needleLimit / length;
      offsetX = _needleOffsetX * scaleFactor;
      offsetY = _needleOffsetY * scaleFactor;
    }
    return Center(
      child: Transform.translate(
        offset: Offset(offsetX,offsetY),
        child: Image.asset(ConstValue.imageNeedleXY,
          width: _stageWidth,
          height: _stageWidth,
        ),
      ),
    );
  }
  Widget _textXY() {
    double angleX = double.parse((_accelerometerEventX * 9).toStringAsFixed(1));
    double angleY = double.parse((_accelerometerEventY * 9).toStringAsFixed(1));
    return Center(
      child: Column(children:[
        const Spacer(),
        Text('X: $angleX °',
          style: TextStyle(
            fontSize: _stageWidth * 0.06,
            color: Colors.black,
          )
        ),
        SizedBox(height: _stageWidth * 0.2),
        Text('Y: $angleY °',
          style: TextStyle(
            fontSize: _stageWidth * 0.06,
            color: Colors.black,
          )
        ),
        const Spacer(),
      ])
    );
  }
}
