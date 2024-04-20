import 'dart:io';

import 'package:dart_frog/dart_frog.dart';





import 'package:first_api/utis/constants.dart';

import '../../../../createCallCollection/controller.dart';
import '../../../../createCallCollection/models.dart';





Constants constant = Constants();
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
}

Future<Response> fetchCompanyID(RequestContext context) async {
  //checking token
  if (context.request.headers['authorization'].toString() !=
      constant.tokenformainapi.toString()) {
    return Response(statusCode: HttpStatus.forbidden);
  }

  //start process

  final body = await context.request.json() as Map<String, dynamic>;
print(body.toString());


  constant.CIUD = body["uuid"] as String;
  constant.callStartStamp = body["start_stamp"] as String;
  constant.ivrName = body["ivr_name"] as String;
    constant.ivrId = body["ivr_id"] as String;
    constant.callerNumber=body["customer_no_with_prefix "] as String;


  await constant.db
      .collection("masterCollection")
      .document("didNumbers")
      .collection("didNumbers")
      .where("didNo", isEqualTo: constant.didNumber)
      .get()
      .then(
    (value) async {
      constant.companyID = value[0]["companyId"] as String;

      await constant.db
          .collection("Companies")
          .document(constant.companyID!)
          .collection("Employees")
          .where("phoneNumber", isEqualTo: constant.answeredAgentNo)
          .get()
          .then((value2) {
        constant.empID = value2[0]["id"].toString();
        constant.empPhoneno = value2[0]["phoneNumber"].toString();
        constant.empDesignation = value2[0]["designation"].toString();
        constant.empName = value2[0]["name"].toString();
      });
    },
  );



CallRecord callRecord = CallRecord();

CreateCallCollection  callDetails = CreateCallCollection(
      companyID: constant.companyID,
      cuid: constant.CIUD,
      callerDid: constant.didNumber,
      callStatus: "Failed",
      ivrId: constant.ivrId,
      ivrName: constant.ivrName,
      advertisedNumber: false,
      agentDid: "",
      agentid: constant.empID,
       agentPhoneNo: constant.empPhoneno,
      agentName: constant.empName,
      agentDesignation: constant.empDesignation,
      baseID: "",
      callDateTime: DateTime.now().toString(),
      callDirection: "inbound",
      callStartStamp: constant.callStartStamp,
      callTranfer: false,
      callTransferIds: [],
      callerNumber: constant.callerNumber,
      source: "Newspaper",
      isSmsSent: false,
      recordingLink: "",
      department: "",
      duration: "",
      endStamp: "",
      isNewLeadCall: false,
      );

  callRecord.addCallRecord(callDetails);


  return Response.json(body: "done");
}
