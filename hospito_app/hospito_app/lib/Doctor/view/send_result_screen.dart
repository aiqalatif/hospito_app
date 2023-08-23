import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Services/services.dart';

class SendResultScreen extends StatefulWidget {
  final String uid;
  final String labName;
  final String testType;
  final String docName;
  final String docConsultation;
  final String pName;
  final String pFName;
  final String pAge;
  final String pNumber;
  const SendResultScreen(
      {Key? key,
      required this.pAge,
      required this.pName,
      required this.pFName,
      required this.pNumber,
      required this.uid,
      required this.labName,
      required this.testType,
      required this.docName,
      required this.docConsultation})
      : super(key: key);

  @override
  _SendResultScreenState createState() => _SendResultScreenState();
}

class _SendResultScreenState extends State<SendResultScreen> {
  bool check = false;
  var result;
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension = 'pdf';
  bool _isLoading = false;
  bool _userAborted = false;
  FileType _pickingType = FileType.custom;
  File? file;

  void _pickFiles() async {
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
      file = File(_paths![0].path!);
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
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrangeAccent.withOpacity(0.3),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Patient name: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.pName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Father Name: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.pFName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Age: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.pAge,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Test: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.testType,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Contact Number: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.pNumber,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'The result of the test should be in .pdf\nKindly pick it from gallery first',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                  child: InkWell(
                    onTap: () => _pickFiles(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Pick Document',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  child: Builder(
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.50,
                                        child: Scrollbar(
                                            child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: _paths != null &&
                                                  _paths!.isNotEmpty
                                              ? _paths!.length
                                              : 1,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final bool isMultiPath =
                                                _paths != null &&
                                                    _paths!.isNotEmpty;
                                            final String name =
                                                'File $index: ' +
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
                                              (BuildContext context,
                                                      int index) =>
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
                ),
                SizedBox(height: 30),
                check
                    ? CircularProgressIndicator()
                    : InkWell(
                        onTap: () async {
                          try {
                            setState(() {
                              check = true;
                            });
                            final url =
                                await Services().addPhotoTStorage(file!);
                            await Services().addResultsToDatabase(
                                this.widget.uid,
                                url,
                                this.widget.labName,
                                this.widget.testType,
                                this.widget.docName,
                                this.widget.docConsultation);
                            Navigator.pop(context);
                          } catch (e) {
                            setState(() {
                              check = false;
                            });
                          }
                        },
                        child: Container(
                          width: 150,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Send Results',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
