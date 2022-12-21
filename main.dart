import 'package:flutter/material.dart';
import 'home.dart';
import 'package:window_manager/window_manager.dart';
void main(List<String> args) async{

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    size: Size(400, 600),
    center: true,
    skipTaskbar: false,
    title: "File Pursuit",
    titleBarStyle: TitleBarStyle.normal,
    maximumSize: Size(400, 600),
    minimumSize: Size(400, 600),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(brightness: Brightness.dark, scaffoldBackgroundColor: Colors.black, useMaterial3: true),
      theme: ThemeData(brightness: Brightness.light, scaffoldBackgroundColor: Colors.white, useMaterial3: true),
      home: Home(),
    );
  }
}