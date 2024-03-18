import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:pdf_downloader_task/downloading_card.dart';
import 'package:pdf_downloader_task/download_controller.dart';

class PDFViewerScreen extends StatefulWidget {
  final int index;

  const PDFViewerScreen({required this.index, super.key});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  DownloaderController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.downloadingList[widget.index].taskStatus !=
                TaskStatus.complete
            ? Center(
                child: DownloadingCard(
                  downloadModel: controller.downloadingList[widget.index],
                  onPressed: () {
                    controller.buttonClick(
                      controller.downloadingList[widget.index].taskStatus,
                      controller
                          .downloadingList[widget.index].backgroundDownloadTask,
                    );
                  },
                ),
              )
            : Stack(
                children: <Widget>[
                  PDFView(
                    filePath: controller.downloadingList[widget.index].pdfUrl,
                    enableSwipe: false,
                    swipeHorizontal: false,
                    autoSpacing: false,
                    pageFling: true,
                    pageSnap: true,
                    defaultPage: currentPage!,
                    fitPolicy: FitPolicy.BOTH,
                    preventLinkNavigation: false,
                    onRender: (pages) {
                      setState(() {
                        this.pages = pages;
                        isReady = true;
                      });
                    },
                    onError: (error) {
                      setState(() {
                        errorMessage = error.toString();
                      });
                      if (kDebugMode) {
                        print(error.toString());
                      }
                    },
                    onPageError: (page, error) {
                      setState(() {
                        errorMessage = '$page: ${error.toString()}';
                      });
                      if (kDebugMode) {
                        print('$page: ${error.toString()}');
                      }
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      _controller.complete(pdfViewController);
                    },
                    onLinkHandler: (String? uri) {
                      if (kDebugMode) {
                        print('goto uri: $uri');
                      }
                    },
                    onPageChanged: (int? page, int? total) {
                      if (kDebugMode) {
                        print('page change: $page/$total');
                      }
                      setState(() {
                        currentPage = page;
                      });
                    },
                  ),
                  errorMessage.isEmpty
                      ? !isReady
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container()
                      : Center(
                          child: Text(errorMessage),
                        )
                ],
              ),
      ),
    );
  }
}
