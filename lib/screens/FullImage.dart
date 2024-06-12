import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class FullImageView extends StatefulWidget {
  final String imageUrl;

  const FullImageView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<FullImageView> createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  double? _progress;
  bool _isDownloading = false;

  Future<void> _downloadImage() async {
    final status = await Permission.storage.status;
    if (status.isGranted) {
      setState(() {
        _isDownloading = true;
        _progress = 0.0; // Reset progress to 0
      });
      await FileDownloader.downloadFile(
        url: widget.imageUrl,
        onProgress: (fileName, progress) {
          setState(() {
            _progress =
                progress / 100; // Normalize progress to be between 0.0 and 1.0
          });
        },
        onDownloadCompleted: (filePath) {
          setState(() {
            _isDownloading = false;
            _progress = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image downloaded to $filePath'),
            ),
          );
        },
      );
    } else {
      await _requestPermission();
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      await _downloadImage();
    } else if (status.isDenied) {
      // Show a dialog to request permission
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Storage Permission Required'),
            content: Text(
                'This app needs access to your device storage to download images. Please grant the permission.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Request the permission again
                  await Permission.storage.request();
                  Navigator.of(context).pop();
                },
                child: Text('Allow'),
              ),
            ],
          );
        },
      );
    } else if (status.isPermanentlyDenied) {
      // Permission has been permanently denied, open app settings
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(FeatherIcons.x),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_isDownloading)
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.grey,
                      color: Colors.blue, // Adjust color as needed
                    )
                  else
                    ElevatedButton(
                      onPressed: _downloadImage,
                      child: Text("Download"),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}