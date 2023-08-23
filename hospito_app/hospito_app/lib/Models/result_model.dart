class ResultModel {
  final String url;
  final String testType;
  final String labName;
  final String docName;
  final String docConsultation;
  final String nodeId;
  ResultModel(
      {required this.docConsultation,
      required this.docName,
      required this.nodeId,
      required this.testType,
      required this.labName,
      required this.url});
}
