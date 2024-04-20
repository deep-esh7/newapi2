import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:first_api/utis/constants.dart';
import '../createCallCollection/controller.dart';
import '../createCallCollection/models.dart';



// whenever call is missed by first agent and moves out to second agent if he also misses the call then CALLHANGUP webhook will update the first agent details instead of updating second in the same caller_id document under call collection . we need to create fubnctionality top achieve this by adding some array so we can detaect the log for botgh numbers if call wents to them. this work is pending




Constants constant = Constants();

Timer? _timer;

int done1 = 0, done2 = 0, done3 = 0;
var callAnswered = false;

void startFetchingApiPeriodically(
    String callID,
    String companyId,
    String conditionType,
    String callUID,
    String callerDid,
    List<dynamic> agentNumbers,
    String source,
    List<Map<String, dynamic>> agentDetails) {
  _timer = Timer.periodic(Duration(seconds: 2), (timer) {
    if (callAnswered == true) {
      stopFetchingPeriodically();
    } else {
      fetchLiveCallApiContinuously(callID, companyId, conditionType, callUID,
          callerDid, agentNumbers, source, agentDetails);
    }
  });
}

void stopFetchingPeriodically() {
  callAnswered = false;
  done1 = 0;
  done2 = 0;

  _timer?.cancel();
}

Future<void> fetchLiveCallApiContinuously(
    String callID,
    String companyId,
    String conditionType,
    String callUID,
    String callerDid,
    List<dynamic> agentNumbers,
    String source,
    List<Map<String, dynamic>> agentDetails) async {
  final response = await http.get(
    Uri.parse(
        'https://api-smartflo.tatateleservices.com/v1/live_calls?call_id=$callID'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0NTQ3MDgiLCJpc3MiOiJodHRwczovL2Nsb3VkcGhvbmUudGF0YXRlbGVzZXJ2aWNlcy5jb20vdG9rZW4vZ2VuZXJhdGUiLCJpYXQiOjE3MTAyMzgzMzMsImV4cCI6MjAxMDIzODMzMywibmJmIjoxNzEwMjM4MzMzLCJqdGkiOiJ2b1F4ZnNVeERJdkV6QlNqIn0.-Xu8um2F8ue1e4vkO2Ugg8l9sUB0t0m4Ypxaxp7OQOw'
    },
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    print(data.toString()); // check [] coming or what coming

    if (data.toString() == "[]" && (done1 == 1 || done2 == 1)) {
      stopFetchingPeriodically();
      // data = [];
    }

    // print(data.toString());
    // print("DETAILS BEFORE IF State of 1st number:" +
    //     data[0]["state"].toString() +
    //     " , Destination : " +
    //     data[0]["destination"].toString() +
    //     ",Agent  Number : " +
    //     agentDetails[0]["phoneNo"].toString());
    // print("DETAILS BEFORE IF State of 1st number:" +
    //     data[0]["state"].toString() +
    //     " , Destination : " +
    //     data[0]["destination"].toString() +
    //     ",Agent  Number : " +
    //     agentDetails[1]["phoneNo"].toString());

    if (data.toString() != "[]" && data[0]["state"] == "Ringing") {
      // Process your data here

      if (data[0]["state"].toString() == "Ringing" &&
          data[0]["destination"].toString() ==
              agentDetails[0]["phoneNumber"].toString() &&
          done1 == 0) {
        done1++;

        print("State of 1st number:" +
            data[0]["state"].toString() +
            " , Destination : " +
            data[0]["destination"].toString() +
            ",Agent  Number : " +
            agentDetails[0]["phoneNumber"].toString());

        CreateCallCollection callDetails = CreateCallCollection(
          companyID: companyId.toString(),
          cuid: callUID,
          callerDid: callerDid,
          callerNumber: data[0]["source"].toString(),
          agentDid: data[0]["did"].toString().substring(1),
          callStartStamp: DateTime.now().toString(),
          recordingLink: "",
          agentid: agentDetails[0]["id"].toString(),
          callStatus: "",
          callTranfer: false,
          callTransferIds: [],
          department: "Sales",
          isNewLeadCall: false,
          baseID: "",
          isSmsSent: false,
          callDateTime: DateTime.now().toString(),
          advertisedNumber: false,
          callDirection: "inbound",
          duration: "",
          source: source,
          endStamp: "",
          ivrId: "",
          ivrName: "",
          agentDesignation: agentDetails[0]["designation"].toString(),
          agentName: agentDetails[0]["name"].toString(),
          agentPhoneNo: agentDetails[0]["phoneNumber"].toString(),
          callAnswerStamp: DateTime.now().toString(),
          callEndStamp: "",
          currentCallStatus: "Started",
          hangUpCause: "",
          callerName: "",
          leadAssigned: false,
          callId: callID,
          condtitionType: conditionType.toString()
        );

        CallRecord callrecord = CallRecord();
        callrecord.addCallRecord(callDetails);
      }

      if (data[0]["state"].toString() == "Ringing" &&
          data[0]["destination"].toString() ==
              agentDetails[1]["phoneNumber"].toString() &&
          done2 == 0) {
        print("State of 2nd number:" +
            data[0]["state"].toString() +
            " , Destination : " +
            data[0]["destination"].toString() +
            ",Agent  Number : " +
            agentDetails[0]["phoneNumber"].toString());

        done2++;
        CreateCallCollection callDetails = CreateCallCollection(
          companyID: companyId.toString(),
          cuid: callUID,
          callerDid: callerDid,
          callerNumber: data[0]["source"].toString(),
          agentDid: data[0]["did"].toString().substring(1),
          callStartStamp: DateTime.now().toString(),
          recordingLink: "",
          agentid: agentDetails[1]["id"].toString(),
          callStatus: "",
          callTranfer: false,
          callTransferIds: [],
          department: "Sales",
          isNewLeadCall: false,
          baseID: "",
          isSmsSent: false,
          callDateTime: DateTime.now().toString(),
          advertisedNumber: false,
          callDirection: "inbound",
          duration: "",
          source: source,
          endStamp: "",
          ivrId: "",
          ivrName: "",
          agentDesignation: agentDetails[1]["designation"].toString(),
          agentName: agentDetails[1]["name"].toString(),
          agentPhoneNo: agentDetails[1]["phoneNumber"].toString(),
          callAnswerStamp: DateTime.now().toString(),
          callEndStamp: "",
          currentCallStatus: "Started",
          hangUpCause: "",
          callerName: "",
          leadAssigned: false,
          callId: callID,
             condtitionType: conditionType.toString()
        );

        CallRecord callrecord = CallRecord();
        callrecord.addCallRecord(callDetails);
      }
      // if (data[0]["state"].toString() == "Ringing" &&
      //     data[0]["destination"].toString() ==
      //         agentDetails[2]["phoneNo"].toString() &&
      //     done3 == 0) {
      //   done3++;

      //   CreateCallCollection callDetails = CreateCallCollection(
      //     companyID: companyId.toString(),
      //     cuid: constant.CIUD,
      //     callerDid: constant.didNumber,
      //     callerNumber: data[0]["source"].toString(),
      //     agentDid: data[0]["did"].toString().substring(1),
      //     callStartStamp: DateTime.now().toString(),
      //     recordingLink: "",
      //     agentid: agentDetails[2]["id"].toString(),
      //     callStatus: "",
      //     callTranfer: false,
      //     callTransferIds: [],
      //     department: "Sales",
      //     isNewLeadCall: false,
      //     baseID: "",
      //     isSmsSent: false,
      //     callDateTime: DateTime.now().toString(),
      //     advertisedNumber: false,
      //     callDirection: "inbound",
      //     duration: "",
      //     source: source,
      //     endStamp: "",
      //     ivrId: "",
      //     ivrName: "",
      //     agentDesignation: agentDetails[2]["designation"].toString(),
      //     agentName: agentDetails[2]["name"].toString(),
      //     agentPhoneNo: agentDetails[2]["phoneNo"].toString(),
      //     callAnswerStamp: DateTime.now().toString(),
      //     callEndStamp: "",
      //     currentCallStatus: "Started",
      //     hangUpCause: "",
      //     callerName: "",
      //     leadAssigned: false,
      //     callId: callID,
      //   );

      //   CallRecord callrecord = CallRecord();
      //   callrecord.addCallRecord(callDetails);
      // }
    } else if (data.toString() != "[]" && data[0]["state"] == "Answered") {
      // data = [];
      callAnswered = true;
      stopFetchingPeriodically();
    }
  } else {
    // Handle error response
  }
}
