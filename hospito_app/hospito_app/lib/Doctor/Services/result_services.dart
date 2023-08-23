import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultServices {
  String? fileName;
  String? saveAsFileName;
  List<PlatformFile>? paths;
  String? directoryPath;
  String? _extension = 'pdf';
  bool isLoading = false;
  bool userAborted = false;
  FileType _pickingType = FileType.custom;

  Future<File> pickFiles() async {
    directoryPath = null;
    paths = (await FilePicker.platform.pickFiles(
      type: _pickingType,
      allowedExtensions: (_extension?.isNotEmpty ?? false)
          ? _extension?.replaceAll(' ', '').split(',')
          : null,
    ))
        ?.files;
    print('cheeeeeeeeeeeeeeeck');
    print(paths!.length);
    print(paths![0].path!);
    File file = File(paths![0].path!);
    return file;
  }
}
