import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_downloader_task/download_model.dart';
import 'package:http/http.dart' as http;

class DownloaderController extends GetxController {
  RxList<DownloadModel> downloadingList = <DownloadModel>[].obs;
  List<String> staticUrl = [
    "https://research.nhm.org/pdfs/10840/10840.pdf",
    "https://research.nhm.org/pdfs/10840/10840.pdf",
  ];

  void loadPdfData() async {
    for (int i = 0; i < staticUrl.length; i++) {
      downloadingList.add(DownloadModel(pdfUrl: staticUrl[i]));
    }

    for (int i = 0; i < downloadingList.length; i++) {
      String url = downloadingList[i].pdfUrl;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          url.split('/').last;
      downloadingList[i].backgroundDownloadTask = DownloadTask(
        url: url,
        filename: fileName,
        directory: 'my/directory',
        baseDirectory: BaseDirectory.applicationDocuments,
        updates: Updates.statusAndProgress,
        retries: 3,
        allowPause: true,

      );
      downloadingList[i].taskId =
          downloadingList[i].backgroundDownloadTask?.taskId ?? '';
      downloadingList[i].name =
          downloadingList[i].backgroundDownloadTask?.filename ?? '';
      bool isCalled = false;

      int total = await getFileBytes(url);
      FileDownloader()
          .configureNotification(
              running:
                  const TaskNotification('Downloading', 'file: {filename}'),
              progressBar: false)
          .registerCallbacks(
        taskProgressCallback: (TaskProgressUpdate update) async {
          print("update: $i : ${update.toJson()}");
          if(update.progress < 0) return;
          int progress = (update.progress * 100).round();
          int received = ((progress * total) / 100).round();
          if (progress == 100 && !isCalled) {
            isCalled = true;
            var tempPath = await getApplicationDocumentsDirectory();
            downloadingList[i].downloadPercentage = 100;
            downloadingList[i].pdfUrl =
                "${tempPath.path}/${update.task.directory}/${update.task.filename}";
            downloadingList.refresh();
          } else {
            downloadingList[i].downloadPercentage =
                ((received * 100) / total).round();
            downloadingList.refresh();
          }
        },
        taskStatusCallback: (TaskStatusUpdate taskStatusUpdate) async {
          downloadingList[i].taskStatus = taskStatusUpdate.status;
          downloadingList.refresh();
        },
      );
      FileDownloader().enqueue(downloadingList[i].backgroundDownloadTask!);
    }
  }

  Future<void> buttonClick(
      TaskStatus taskStatus, DownloadTask? downloadTask) async {
    if (taskStatus == TaskStatus.paused) {
      if (downloadTask != null) {
        await FileDownloader().resume(downloadTask);
      }
    } else if (taskStatus == TaskStatus.running ||
        taskStatus == TaskStatus.enqueued) {
      if (downloadTask != null) {
        await FileDownloader().pause(downloadTask);
      }
    }
  }

  Future<int> getFileBytes(String filesUrl) async {
    DateTime startDateTime = DateTime.now();
    http.Response response = await http.Client().head(Uri.parse(filesUrl));
    int fileBytes = int.parse(response.headers["content-length"] ?? '0');
    print(
        "getFileSize Size $fileBytes Bytes || Time: ${DateTime.now().difference(startDateTime).inSeconds} Second");
    return fileBytes;
  }
}
