import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'dart:io';
import 'package:firedart/firedart.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:first_api/utis/constants.dart';

import '../../../createCallCollection/controller.dart';
import '../../../createCallCollection/models.dart';
import '../../../fetchLiveCallApi/fetchLiveCallApiContinously.dart';

var constant = Constants();

var mainres;

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  switch (context.request.method) {
    case HttpMethod.post:
      return fetchCompanyID(context);

    case HttpMethod.delete:
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
  ;
}

//fetch company id

Future<Response> fetchCompanyID(RequestContext context) async {
  //checking token
  // if (context.request.headers['authorization'].toString() !=
  //     constant.tokenformainapi.toString()) {
  //   return Response(statusCode: HttpStatus.forbidden);
  // }

  //start process

  final body = await context.request.json() as Map<String, dynamic>;
  print(body.toString());
  constant.didNumber = body["call_to_number"] as String;
  constant.callerNumber = body["caller_id_number"].toString();

  if (constant.callerNumber.toString().length == 11) {
    constant.callerNumber = "+91" + constant.callerNumber!.substring(1);
  } else if (constant.callerNumber.toString().length == 13) {
    constant.callerNumber = "+91" + constant.callerNumber!.substring(3);
  }

  print(constant.callerNumber);

  constant.CIUD = body["uuid"] as String;
  constant.callStartStamp = body["start_stamp"] as String;
  constant.callerName = "";
  constant.callId = body["call_id"] as String;

  await constant.db
      .collection("masterCollection")
      .document("didNumbers")
      .collection("didNumbers")
      .where("didNo", isEqualTo: constant.didNumber)
      .get()
      .then(
    (value) {
      constant.companyID = value[0]["companyId"] as String;
      constant.source = value[0]["distributedAt"] as String;

      // print(constant.companyID);
    },
  );

  return checkLeadExists(context);
}

// check lead exists or not

Future<Response> checkLeadExists(
  RequestContext context,
) async {
  await constant.db
      .collection("Companies")
      .document(constant.companyID!)
      .collection("leads")
      .where("personalDetails.mobileNo", isEqualTo: constant.callerNumber)
      .get()
      .then((value) async {
    if (value.toString() != "[]" &&
        value[0]["owner"]["name"].toString() != "") {
      print(value.toString());

      // this means lead exists and data is extracted and now goto emplyee collection to check weather employee is avaialbe or busy
      constant.empID = value[0]["owner"]["id"] as String;
      constant.empName = value[0]["owner"]["name"] as String;
      constant.empDesignation = value[0]["owner"]["designation"] as String;
      constant.baseID = value[0]["id"] as String;

      constant.callerName = value[0]["personalDetails"]["name"] as String;


      await constant.db
          .collection("Companies")
          .document(constant.companyID!)
          .collection("Employees")
          .document(constant.empID!)
          .get()
          .then((value2) {
        constant.empPhoneno = value2.map["phoneNumber"] as String;

        constant.empStatus = value2.map["status"] as String;
        // now we have extracted the emp phone no and status for exisiting lead

        if (constant.empStatus == "available") {
          constant.agentNumbers
              .add(constant.empPhoneno.toString().split("+91")[1].toString());

          var resMap = [
            {
              "recording": {"type": "system", "data": 137452}
            },
            {
              "transfer": {
                "type": "number",
                "data": constant.agentNumbers,
                "moh": "137444"
              }
            }
          ];

          print("DAsadsasd");
          CreateCallCollection callDetails = CreateCallCollection(
            companyID: constant.companyID,
            cuid: constant.CIUD,
            callerDid: constant.didNumber,
            callerNumber: constant.callerNumber,
            agentDid: "",
            callStartStamp: constant.callStartStamp,
            recordingLink: "",
            agentid: constant.empID,
            callStatus: "",
            callTranfer: false,
            callTransferIds: [],
            department: "Sales",
            isNewLeadCall: false,
            baseID: constant.baseID,
            isSmsSent: false,
            callDateTime: DateTime.now().toString(),
            advertisedNumber: false,
            callDirection: "inbound",
            duration: "",
            source: constant.source,
            endStamp: "",
            ivrId: "",
            ivrName: "",
            agentDesignation: constant.empDesignation,

            agentName: constant.empName,
            agentPhoneNo: constant.empPhoneno,
            callAnswerStamp: "",
            callEndStamp: "",
            currentCallStatus: "Started",
            hangUpCause: "",
            callerName: constant.callerName,
            leadAssigned: true,
            callId: constant.callId,
          );

          CallRecord callrecord = CallRecord();
          callrecord.addCallRecord(callDetails);

          print("Number provided to customer : " +
              constant.agentNumbers.toString().split("+91")[1]);

          mainres = resMap;
          print(mainres);
          constant.agentNumbers = [];
          constant.callId = "";
          constant.companyID = "";
          constant.CIUD = "";
          constant.didNumber = "";
        } else {
          print("agent is busy on another call provided to customer");
          CallRecord callrecord = CallRecord();
          CreateCallCollection callDetails = CreateCallCollection(
              companyID: constant.companyID,
              cuid: constant.CIUD,
              callerDid: constant.didNumber,
              callerNumber: constant.callerNumber,
              agentDid: "",
              callStartStamp: constant.callStartStamp,
              recordingLink: "",
              agentid: constant.empID,
              callStatus: "Ended By IVR",
              callTranfer: false,
              callTransferIds: [],
              department: "Sales",
              isNewLeadCall: false,
              baseID: constant.baseID,
              isSmsSent: false,
              callDateTime: DateTime.now().toString(),
              advertisedNumber: false,
              callDirection: "inbound",
              duration: "",
              source: constant.source,
              endStamp: "",
              ivrId: "11111",
              ivrName: "testivr",
              agentDesignation: constant.empDesignation,
              agentName: constant.empName,
              agentPhoneNo: constant.empPhoneno,
              callAnswerStamp: "",
              callEndStamp: "",
              currentCallStatus: "Ended",
              hangUpCause: "Agent Busy Ended By IVR",
              callId: constant.callId,
              leadAssigned: false,
              callerName: "");

          callrecord.addCallRecord(callDetails);

          constant.agentNumbers.add("11111");

          // res = constant.agentNumbers;

          var resMap = [
            {
              "recording": {
                "type": "system",
                "data": 137452,
              },
              "transfer": {"type": "ivr", "data": constant.agentNumbers}
            }
          ];

          mainres = resMap;
          print(mainres);
          constant.agentNumbers = [];
          constant.callId = "";
          constant.companyID = "";
          constant.CIUD = "";
          constant.didNumber = "";
        }
      });
    } else {
      mainres = null;
    }
  });

  return leadNotExists(context);
}

// lead not exists

Future<Response> leadNotExists(RequestContext context) async {
  if (mainres != null) {
    return Response.json(body: mainres);
  }
  var resMap;

  {
    // if lead not exists fetch didnumbers under conversations and then telephony

    await constant.db
        .collection("Companies")
        .document(constant.companyID!)
        .collection("conversations")
        .document("telephony")
        .collection("telephony")
        .document(constant.didNumber!)
        .get()
        .then((value) async => {
              //after fetching details of did allocation we need to fetch all agents available for executing conditions like round robin or simantaneous for connecting to the non existing lead

              await constant.db
                  .collection("Companies")
                  .document(constant.companyID!)
                  .collection("conversations")
                  .document("telephony")
                  .collection("telephony")
                  .document("conditions")
                  .collection("conditions")
                  .document(value.map["departmentName"].toString() +
                      "," +
                      value.map["projectId"].toString())
                  .get()
                  .then((value2) async {
                if (value2["callingAlgorithm"].toString() == "ROUND_ROBIN") {
                  var agentNumbers;
                  for (int i = 0;
                      i < int.parse(value2.map["agents"].length.toString());
                      i++) {
                    print("adsklnadsadjs,");

                    print(i);
                    await constant.db
                        .collection("Companies")
                        .document(constant.companyID!)
                        .collection("Employees")
                        .document(value2.map["agents"]["$i"]["id"].toString())
                        .get()
                        .then((value) {
                      if (value.map["status"].toString() == "available") {
                        constant.agentNumbers.add(value.map["phoneNumber"]
                            .toString()
                            .split("+91")[1]);

                        constant.agentDetails.add(value.map);
                      }
                    });
                  }

                  if (constant.agentNumbers.length != 0) {
                    resMap = [
                      {
                        "recording": {"type": "system", "data": 137452}
                      },
                      {
                        "transfer": {
                          "type": "number",
                          "data": constant.agentNumbers,
                          "ring_type": "order_by",
                          "moh": "137444"
                        }
                      }
                    ];
                  } else {
                    print("agent is busy on another call");
                    CallRecord callrecord = CallRecord();
                    CreateCallCollection callDetails = CreateCallCollection(
                        companyID: constant.companyID,
                        cuid: constant.CIUD,
                        callerDid: constant.didNumber,
                        callerNumber: constant.callerNumber,
                        agentDid: "",
                        callStartStamp: constant.callStartStamp,
                        recordingLink: "",
                        agentid: constant.empID,
                        callStatus: "Ended By IVR",
                        callTranfer: false,
                        callTransferIds: [],
                        department: "Sales",
                        isNewLeadCall: false,
                        baseID: constant.baseID,
                        isSmsSent: false,
                        callDateTime: DateTime.now().toString(),
                        advertisedNumber: false,
                        callDirection: "inbound",
                        duration: "",
                        source: constant.source,
                        endStamp: "",
                        ivrId: "11111",
                        ivrName: "testivr",
                        agentDesignation: constant.empDesignation,
                        agentName: constant.empName,
                        agentPhoneNo: constant.empPhoneno,
                        callAnswerStamp: "",
                        callEndStamp: "",
                        currentCallStatus: "Ended",
                        hangUpCause: "Agent Busy Ended By IVR",
                        callId: constant.callId,
                        callerName: "");

                    callrecord.addCallRecord(callDetails);

                    constant.agentNumbers.add("11111");

                    // res = constant.agentNumbers;

                    resMap = [
                      {
                        "recording": {"type": "system", "data": 137452}
                      },
                      {
                        "transfer": {
                          "type": "ivr",
                          "data": constant.agentNumbers,
                        }
                      }
                    ];
                  }

                  mainres = resMap;

                  startFetchingApiPeriodically(
                      constant.callId.toString(),
                      constant.companyID.toString(),
                      "Round_Robin",
                      constant.CIUD.toString(),
                      constant.didNumber.toString(),
                      constant.agentNumbers,
                      constant.source.toString(),
                      constant.agentDetails);
                  print(mainres);

                  /// swapping now as the condtion is roundrobin
                  CallRecord callrecord = CallRecord();
                  callrecord.updateAgentMap(
                      value2.map["agents"] as Map<String, dynamic>,
                      constant.companyID!,
                      value.map["departmentName"].toString() +
                          "," +
                          value.map["projectId"].toString());

                  print(mainres);
                  constant.agentNumbers = [];
                  constant.agentDetails = [];
                  constant.callId = "";
                  constant.companyID = "";
                  constant.CIUD = "";
                  constant.didNumber = "";
                } else {
                  //smt

                  for (int i = 0;
                      i < int.parse(value2.map["agents"].length.toString());
                      i++) {
                    await constant.db
                        .collection("Companies")
                        .document(constant.companyID!)
                        .collection("Employees")
                        .document(value2.map["agents"]["$i"]["id"].toString())
                        .get()
                        .then((value) {
                      if (value.map["status"].toString() == "available") {
                        constant.agentNumbers.add(value.map["phoneNumber"]
                            .toString()
                            .split("+91")[1]);

                        constant.agentDetails.add(value.map);
                      }
                    });
                  }

                  if (constant.agentNumbers.length != 0) {
                    resMap = [
                      {
                        "recording": {"type": "system", "data": 137452}
                      },
                      {
                        "transfer": {
                          "type": "number",
                          "data": constant.agentNumbers,
                          "ring_type": "simantaneous",
                          "moh": "137444"
                        }
                      }
                    ];
                  } else {

                    print("agent is busy on another call");
                    CallRecord callrecord = CallRecord();
                    CreateCallCollection callDetails = CreateCallCollection(
                        companyID: constant.companyID,
                        cuid: constant.CIUD,
                        callerDid: constant.didNumber,
                        callerNumber: constant.callerNumber,
                        agentDid: "",
                        callStartStamp: constant.callStartStamp,
                        recordingLink: "",
                        agentid: constant.empID,
                        callStatus: "Ended By IVR",
                        callTranfer: false,
                        callTransferIds: [],
                        department: "Sales",
                        isNewLeadCall: false,
                        baseID: constant.baseID,
                        isSmsSent: false,
                        callDateTime: DateTime.now().toString(),
                        advertisedNumber: false,
                        callDirection: "inbound",
                        duration: "",
                        source: constant.source,
                        endStamp: "",
                        ivrId: "11111",
                        ivrName: "testivr",
                        agentDesignation: constant.empDesignation,
                        agentName: constant.empName,
                        agentPhoneNo: constant.empPhoneno,
                        callAnswerStamp: "",
                        callEndStamp: "",
                        currentCallStatus: "Ended",
                        hangUpCause: "Agent Busy Ended By IVR",
                        leadAssigned: false);

                    callrecord.addCallRecord(callDetails);

                    constant.agentNumbers.add("11111");

                    // res = constant.agentNumbers;

                    resMap = [
                      {
                        "recording": {"type": "system", "data": 137452}
                      },
                      {
                        "transfer": {
                          "type": "ivr",
                          "data": constant.agentNumbers
                        }
                      }
                    ];
                  }

                  startFetchingApiPeriodically(
                      constant.callId.toString(),
                      constant.companyID.toString(),
                      "simantaneous",
                      constant.CIUD.toString(),
                      constant.didNumber.toString(),
                      constant.agentNumbers,
                      constant.source.toString(),
                      constant.agentDetails);

                  CallRecord callrecord = CallRecord();
                  callrecord.updateAgentMap(
                      value2.map["agents"] as Map<String, dynamic>,
                      constant.companyID!,
                      value.map["departmentName"].toString() +
                          "," +
                          value.map["projectId"].toString());

                  mainres = resMap;
                  print(mainres);
                  constant.agentNumbers = [];
                  constant.agentDetails = [];
                  constant.callId = "";
                  constant.companyID = "";
                  constant.CIUD = "";
                  constant.didNumber = "";
                }
              })
            });
  }

  print("data is here : " + jsonEncode(mainres));
  return Response.json(body: mainres);
}
