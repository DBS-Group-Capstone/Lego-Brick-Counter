import 'package:flutter/material.dart';
import 'package:learn/HOME_addPage.dart';
import 'package:learn/HOME_collectionPage.dart';
import 'package:learn/HOME_otherPage.dart';
import 'package:learn/add_addsetPage.dart';
import 'package:learn/add_takephotoPage.dart';
import 'package:learn/add_uploadphotoPage.dart';
import 'package:learn/collection_mypiecesPage.dart';
import 'package:learn/collection_piecelookupPage.dart';
import 'package:learn/collection_setlookupPage.dart';
import 'package:learn/collection_setmatchingPage.dart';
import 'package:learn/other_aboutPage.dart';
import 'package:learn/other_helpPage.dart';
import 'package:learn/other_legalPage.dart';
import 'package:learn/other_settingsPage.dart';
import 'data_page.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:learn/camera_provider.dart';
import 'package:provider/provider.dart';


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
    ChangeNotifierProvider(
      create: (_) => cameraProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 13, 207, 255)),
      ),
      home: const CollectionPage(),
      routes: {
        '/collection' : (_) => CollectionPage(),
        '/add' : (_) => AddPage(),
        '/other' : (_) => OtherPage(),

        '/addset' : (_) => AddsetPage(),
        '/takephoto' : (_) => TakephotoPage(),
        '/uploadphoto' : (_) => UploadphotoPage(),
        '/piecelookup' : (_) => PiecelookupPage(),
        '/mypieces' : (_) => MypiecesPage(),
        '/setlookup' : (_) => SetlookupPage(),
        '/setmatching' : (_) => SetmatchingPage(),
        '/about' : (_) => AboutPage(),
        '/help' : (_) => HelpPage(),
        '/legal' : (_) => LegalPage(),
        '/settings' : (_) => SettingsPage(),
        '/data' : (_) => DataPage()
      }
    );
  }
}

