import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Services/services.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension = 'pdf';
  bool _isLoading = false;
  bool _userAborted = false;
  FileType _pickingType = FileType.custom;

  Future _pickFiles() async {
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
      print(_paths!.length);
      print(_paths![0].path!);
      File file = File(_paths![0].path!);
      await Services().addPhotoTStorage(file);
      return true;
    } on PlatformException catch (e) {
    } catch (e) {}
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('File Picker example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _pickFiles(),
                child: Text('Pick file'),
              ),
              Builder(
                builder: (BuildContext context) => _isLoading
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: const CircularProgressIndicator(),
                      )
                    : _userAborted
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: const Text(
                              'User has aborted the dialog',
                            ),
                          )
                        : _directoryPath != null
                            ? ListTile(
                                title: const Text('Directory path'),
                                subtitle: Text(_directoryPath!),
                              )
                            : _paths != null
                                ? Container(
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
                                    height: MediaQuery.of(context).size.height *
                                        0.50,
                                    child: Scrollbar(
                                        child: ListView.separated(
                                      itemCount:
                                          _paths != null && _paths!.isNotEmpty
                                              ? _paths!.length
                                              : 1,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final bool isMultiPath =
                                            _paths != null &&
                                                _paths!.isNotEmpty;
                                        final String name = 'File $index: ' +
                                            (isMultiPath
                                                ? _paths!
                                                    .map((e) => e.name)
                                                    .toList()[index]
                                                : _fileName ?? '...');
                                        final path = kIsWeb
                                            ? null
                                            : _paths!
                                                .map((e) => e.path)
                                                .toList()[index]
                                                .toString();

                                        return ListTile(
                                          title: Text(
                                            name,
                                          ),
                                          subtitle: Text(path ?? ''),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(),
                                    )),
                                  )
                                : _saveAsFileName != null
                                    ? ListTile(
                                        title: const Text('Save file'),
                                        subtitle: Text(_saveAsFileName!),
                                      )
                                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
