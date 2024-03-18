import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_downloader_task/downloading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PDF Downloader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Downloader'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Start"),
          onPressed: () {
            Get.to(const DownloadingScreen());
          },
        ),
      ),
    );
  }
}
