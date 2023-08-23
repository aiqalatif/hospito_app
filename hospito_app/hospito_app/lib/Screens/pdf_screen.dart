import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PdfScreen extends StatelessWidget {
  final String url;
  final dynamic doc;
  const PdfScreen({Key? key, required this.url, required this.doc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(url);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Results',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: Container(
          child: PDFViewer(
            document: doc,
          ),
        ),
      ),
    );
  }
}
