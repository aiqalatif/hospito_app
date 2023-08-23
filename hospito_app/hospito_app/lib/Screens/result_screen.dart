import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Models/result_model.dart';
import '../Services/auth_services.dart';
import '../Services/database_services.dart';
import 'pdf_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
                stream: DatabaseServices().getResult(AuthServices().getUid()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Container(
                        height: 100,
                        child: Lottie.asset('assets/heart.json'),
                      ),
                    );
                  }
                  List<ResultModel> results = [];
                  var listData = snapshot.data!.docs;
                  for (var item in listData) {
                    ResultModel model = ResultModel(
                        nodeId: item.id,
                        docName: item.get('Doctor Name'),
                        docConsultation: item.get('Doctor Consultation'),
                        testType: item.get('Test Type'),
                        labName: item.get('Lab Name'),
                        url: item.get('Result Url'));

                    results.add(model);
                  }
                  if (results.length == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'No results, please wait for Admin response',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: results.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onLongPress: () {
                            AlertDialog alert = AlertDialog(
                              title: Text("Warning"),
                              content:
                                  Text("Do you want to delete the results"),
                              actions: [
                                InkWell(
                                  onTap: () {
                                    DatabaseServices().deleteResult(
                                        results[i].nodeId,
                                        AuthServices().getUid());
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.red[800],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            );

                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          },
                          onTap: () async {
                            PDFDocument doc =
                                await PDFDocument.fromURL(results[i].url);

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PdfScreen(url: results[i].url, doc: doc);
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      offset: Offset(0, 0),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                    )
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your ${results[i].testType} Results at ${results[i].labName} ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  results[i].docConsultation == 'Yes'
                                      ? Text(
                                          'Under Supervision of ${results[i].docName} ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text('No Doctor Supervision'),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }
}
