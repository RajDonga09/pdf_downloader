import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:pdf_downloader_task/download_model.dart';

class DownloadingCard extends StatelessWidget {
  final DownloadModel downloadModel;
  final VoidCallback? onPressed;
  final VoidCallback? onOpenCallBack;

  const DownloadingCard(
      {required this.downloadModel,
      this.onPressed,
      this.onOpenCallBack,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(downloadModel.name),
            Text(downloadModel.pdfUrl, maxLines: 2),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0,
                      end: downloadModel.downloadPercentage / 100,
                    ),
                    builder: (context, value, _) => ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: LinearProgressIndicator(
                        value: value,
                        color: Colors.deepPurple,
                        backgroundColor: Colors.grey.shade300,
                        minHeight: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text("${downloadModel.downloadPercentage}%"),
              ],
            ),
            Align(
              child: Row(
                children: [
                  if (downloadModel.taskStatus != TaskStatus.complete)
                    IconButton(
                        onPressed: onPressed != null
                            ? () {
                                onPressed!.call();
                              }
                            : null,
                        icon: Text(downloadModel.taskStatus ==
                                TaskStatus.waitingToRetry
                            ? 'Running'
                            : downloadModel.taskStatus == TaskStatus.failed ||
                                    downloadModel.taskStatus ==
                                        TaskStatus.notFound
                                ? 'Error'
                                : downloadModel.taskStatus == TaskStatus.paused
                                    ? 'Resume'
                                    : 'Pause')),
                  if (onOpenCallBack != null)
                    IconButton(
                        onPressed: onOpenCallBack != null
                            ? () {
                                onOpenCallBack!.call();
                              }
                            : null,
                        icon: const Text('Open')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
