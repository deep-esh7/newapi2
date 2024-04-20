import 'package:firedart/firedart.dart';

class Constants {
  final db = Firestore.instance;
  String? didNumber;
  String? callerNumber;
  String? companyID;

  String? empID;
  String? empDesignation;

  String? empName;
  String? empStatus;
  String? empPhoneno;
  String? callStartStamp;
  String? CIUD;
  String? baseID;
  List agentNumbers = [];
  var tokenformainapi = "hello";
  String? answeredAgentNo;
  String? recordingLink;
  String? callduration;
  String? endTime;
  String? callDirection;
  String? ivrId;
  String? ivrName;
  String? department;
  String? callStatus;
  String? callAnsweredStamp;
  String? callEndStamp;
  String? hangUpCause;
  bool? isNewLeadCall;
  String? source;
  bool? leadAssigned;
  String? callerName;
  String? callId;
  List<Map<String,dynamic>> agentDetails = [];
}
