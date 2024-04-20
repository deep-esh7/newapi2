import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:first_api/utis/constants.dart';
import 'package:first_api/utis/generateID.dart';

import '../../../../createCallCollection/controller.dart';
import '../../../../createCallCollection/models.dart';
import '../../../../createLeads/controller.dart';
import '../../../../createLeads/leadModel.dart';
import '../../../../createLeads/leadOwnerModel.dart';
import '../../../../createLeads/leadPersonalDetailsModel.dart';
import '../index.dart';

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
  print("yaha tak chal raha hai11");
  if (context.request.headers['authorization'].toString() !=
      constant.tokenformainapi.toString()) {
    return Response(statusCode: HttpStatus.forbidden);
  }

  print("yaha tak chal raha hai");
  //start process

  final body = await context.request.json() as Map<String, dynamic>;

  print("yaha tak chal raha hai2");
  print(body.toString());

  constant.isNewLeadCall = false;
  constant.leadAssigned = true;
  constant.didNumber = body["call_to_number"] as String;
  constant.callerNumber = body["customer_no_with_prefix "] as String;

  constant.CIUD = body["uuid"] as String;
  constant.callStartStamp = body["start_stamp"] as String;
  constant.answeredAgentNo = body["answer_agent_number"] as String;
  constant.callId = body["call_id"] as String;

  if (constant.answeredAgentNo.toString().length == 11) {
    constant.answeredAgentNo =
        "+91" + constant.answeredAgentNo.toString().substring(1);
  } else if (constant.answeredAgentNo.toString().length == 13) {
    constant.answeredAgentNo =
        "+91" + constant.answeredAgentNo.toString().substring(3);
  }

  constant.callDirection = body["direction"] as String;
  constant.callStatus = body["call_status"] as String;

  if (constant.callDirection == "clicktocall") {
    constant.didNumber = "91" + body["call_id_number"].toString();
    ;
  }

  print(constant.didNumber.toString() +
      " " +
      constant.callerNumber.toString() +
      " " +
      constant.answeredAgentNo.toString() +
      " " +
      constant.callDirection.toString() +
      " " +
      constant.callStatus.toString());

  await constant.db
      .collection("masterCollection")
      .document("didNumbers")
      .collection("didNumbers")
      .where("didNo", isEqualTo: constant.didNumber)
      .get()
      .then(
    (value) async {
      constant.companyID = value[0]["companyId"] as String;

      constant.source = value[0]["distributedAt"] as String;
      print(constant.answeredAgentNo.toString());
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

  return createLead(context);
}

Future<Response> createLead(RequestContext context) async {
  var leadId = generateUniqueId();
  constant.baseID = leadId;

  LeadPersonalDetails leadPersonalDetails = LeadPersonalDetails(
    name: "",
    mobileNo: constant.callerNumber!,
  );
  LeadOwner leadOwnerData = LeadOwner(
      name: constant.empName!,
      id: constant.empID!,
      designation: constant.empDesignation!);

  Lead leadData = Lead(
      companyId: constant.companyID,
      id: leadId,
      source: "Newspaper",
      status: "Fresh",
      subStatus: "",
      hotLead: false,
      createdOn: DateTime.now(),
      leadStatusType: LeadStatusType.FRESH,
      personalDetails: leadPersonalDetails,
      subsource: "",
      owner: leadOwnerData);
  constant.isNewLeadCall = true;
  LeadsSection leadsSection = LeadsSection();

  await constant.db
      .collection("Companies")
      .document(constant.companyID!)
      .collection("leads")
      .where("personalDetails.mobileNo", isEqualTo: constant.callerNumber)
      .get()
      .then((value) async {
    if (value.toString() == "[]") {
      constant.isNewLeadCall = true;
      leadsSection.addLead(leadData);
    } else if (value.toString() != "[]" &&
        value[0]["owner"]["name"].toString() == "") {
      constant.baseID = value[0]["id"].toString();
      constant.isNewLeadCall = true;
      constant.leadAssigned = false;

      LeadPersonalDetails leadPersonalDetails2 = LeadPersonalDetails(
        name: "",
        mobileNo: constant.callerNumber!,
      );
      LeadOwner leadOwnerData2 = LeadOwner(
          name: constant.empName!,
          id: constant.empID!,
          designation: constant.empDesignation!);

      Lead leadData2 = Lead(
          companyId: constant.companyID,
          id: value[0]["id"].toString(),
          source: "Newspaper",
          status: "Fresh",
          subStatus: "",
          hotLead: false,
          createdOn: DateTime.now(),
          leadStatusType: LeadStatusType.FRESH,
          personalDetails: leadPersonalDetails2,
          subsource: "",
          owner: leadOwnerData2);
      constant.isNewLeadCall = true;
      LeadsSection leadsSection = LeadsSection();
      leadsSection.updateLead(leadData2);
    }
  });

  return createCallDetails(context);
}

Future<Response> createCallDetails(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;

  CallRecord callrecord = CallRecord();

  CreateCallCollection callDetails = CreateCallCollection(
    companyID: constant.companyID,
    duration: "",
    source: constant.source,
    endStamp: "",
    ivrId: "",
    ivrName: "",
    agentPhoneNo: constant.empPhoneno,
    agentName: constant.empName,
    agentDesignation: constant.empDesignation,
    cuid: constant.CIUD,
    callerDid: constant.didNumber,
    callerNumber: constant.callerNumber,
    agentDid: constant.didNumber,
    callStartStamp: constant.callStartStamp,
    recordingLink: "",
    agentid: constant.empID,
    callAnswerStamp: "",
    callEndStamp: "",
    currentCallStatus: "Started",
    hangUpCause: "",
    callStatus: constant.callStatus,
    callTranfer: false,
    callTransferIds: [],
    department: "Sales",
    isNewLeadCall: constant.isNewLeadCall,
    baseID: constant.baseID,
    isSmsSent: false,
    callDateTime: DateTime.now().toString(),
    advertisedNumber: false,
    callDirection: constant.callDirection,
    callId: constant.callId,
    leadAssigned: constant.leadAssigned,
  );

  callrecord.updateCallRecord(callDetails);

  return Response.json(body: "done");
}
