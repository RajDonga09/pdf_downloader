import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_downloader_task/downloading_card.dart';
import 'package:pdf_downloader_task/download_controller.dart';
import 'package:pdf_downloader_task/download_model.dart';
import 'package:pdf_downloader_task/pdf_viewer.dart';
import 'package:pdf_downloader_task/temp.dart';

class DownloadingScreen extends StatefulWidget {
  const DownloadingScreen({super.key});

  @override
  State<DownloadingScreen> createState() => _DownloadingScreenState();
}

class _DownloadingScreenState extends State<DownloadingScreen> {
  DownloaderController controller = Get.put(DownloaderController())
    ..loadPdfData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloading'),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.separated(
          itemCount: controller.downloadingList.length,
          padding: const EdgeInsets.all(15),
          itemBuilder: (context, index) {
            DownloadModel downloadModel = controller.downloadingList[index];
            return DownloadingCard(
              downloadModel: downloadModel,
              onPressed: () {
                controller.buttonClick(
                  controller.downloadingList[index].taskStatus,
                  controller.downloadingList[index].backgroundDownloadTask,
                );
              },
              onOpenCallBack: () {
                Get.to(PDFViewerScreen(index: index));
              },
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 5);
          },
        ),
      ),
    );
  }
}
