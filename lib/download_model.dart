import 'package:background_downloader/background_downloader.dart';
import 'package:pdf_downloader_task/temp.dart';

class DownloadModel {
  String taskId;
  String pdfUrl;
  String name;
  int downloadPercentage;
  TaskStatus taskStatus;
  DownloadTask? backgroundDownloadTask;

  DownloadModel({
    this.taskId = '',
    required this.pdfUrl,
    this.name = '',
    this.downloadPercentage = 0,
    this.taskStatus = TaskStatus.waitingToRetry,
    this.backgroundDownloadTask,
  });
}
