import 'package:flutter/material.dart';
import 'package:kaaju/screens/splashScreen/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kaaju/controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() => GetMaterialApp(
      title: 'KaaJu Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff3c096c), brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xffF8F9FA),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffE0AAFF), brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xff121212),
        useMaterial3: true,
      ),
      themeMode: themeController.themeMode,
      home: const SplashScreen(),
    ));
  }
}
