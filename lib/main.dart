import 'package:flutter/material.dart';
import 'package:learn/HOMEPage.dart';
import 'package:learn/HOME_takephotoPage.dart';
import 'package:learn/HOME_imagesPage.dart';
import 'package:learn/HOME_inventoryPage.dart';
import 'package:learn/settings_aboutPage.dart';
import 'package:learn/settings_helpPage.dart';
import 'package:learn/settings_legalPage.dart';
import 'package:learn/HOME_settingsPage.dart';
import 'package:learn/theme_provider.dart';
import 'package:learn/dark_theme.dart';
import 'package:learn/light_theme.dart';

import 'inventory_addpiecesPage.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:learn/camera_provider.dart';
import 'package:provider/provider.dart';
import 'package:learn/takephoto_checkphotoPage.dart';
import 'package:learn/images_viewimagePage.dart';
import 'package:learn/VARIOUS_analyzePage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //load cameras before app starts
  final cameraProvider = CameraProvider();
  await cameraProvider.loadCameras();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  //provider used to manage camera state
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => cameraProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Demo',

          theme: AppLightTheme.theme,
          darkTheme: AppDarkTheme.theme,
          themeMode: themeProvider.themeMode,

          home: const HOMEPage(),
          routes: {
          '/HOME' : (_) => HOMEPage(),

          '/takephoto' : (_) => TakePhotoPage(),
          '/images' : (_) => ImagesPage(),
          '/inventory' : (_) => InventoryPage(),
          '/about' : (_) => AboutPage(),
          '/help' : (_) => HelpPage(),
          '/legal' : (_) => LegalPage(),
          '/settings' : (_) => SettingsPage(),
          '/addpieces' : (_) => AddPiecesPage(),
          '/checkphoto' : (_) => CheckPhotoPage(),
          '/viewimage' : (_) => ViewImagePage(),
          '/analyze' : (_) => AnalyzePage(),
          }
        );
      }
    );
  }
}