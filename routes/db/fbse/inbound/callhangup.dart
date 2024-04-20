import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:first_api/utis/constants.dart';
import 'package:first_api/utis/generateID.dart';

import '../../../../chatroom_controller/chatroom_controller.dart';
import '../../../../chatroom_model/chatroom_model.dart';
import '../../../../createCallCollection/controller.dart';
import '../../../../createCallCollection/models.dart';
import '../../../../createLeads/controller.dart';
import '../../../../createLeads/leadModel.dart';
import '../../../../createLeads/leadOwnerModel.dart';
import '../../../../createLeads/leadPersonalDetailsModel.dart';

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
  constant.leadAssigned = true;
  constant.isNewLeadCall = false;
  constant.CIUD = body["uuid"] as String;
  constant.didNumber = body["call_to_number"] as String;

  constant.callerNumber = body["customer_no_with_prefix "] as String;
  constant.callStartStamp = body["start_stamp"] as String;
  constant.callAnsweredStamp = body["answer_stamp"] as String;
  constant.callEndStamp = body["end_stamp"] as String;
  constant.hangUpCause = body["hangup_cause"] as String;
  constant.callDirection = body["direction"] as String;
  constant.callduration = body["duration"] as String;

  constant.answeredAgentNo = body["answered_agent_number"] as String;
  constant.callId = body["call_id"] as String;

  constant.recordingLink = body["recording_url"] as String;
  constant.callStatus = body["call_status"] as String;

  if (constant.callStatus == "missed" &&
      constant.callDirection != "clicktocall") {
    if (body["missed_agent"][0]["number"].toString().length == 11)
      constant.answeredAgentNo =
          "+91" + body["missed_agent"][0]["number"].toString().substring(1);

    if (body["missed_agent"][0]["number"].toString().length == 13) {
      constant.answeredAgentNo =
          "+91" + body["missed_agent"][0]["number"].toString().substring(3);
    }
  } else {
    if (constant.answeredAgentNo.toString().length == 11) {
      constant.answeredAgentNo =
          "+91" + constant.answeredAgentNo.toString().substring(1);
    }

    if (constant.answeredAgentNo.toString().length == 13) {
      constant.answeredAgentNo =
          "+91" + constant.answeredAgentNo.toString().substring(3);
    }
  }

  if (constant.callDirection == "clicktocall") {
    constant.didNumber = "91" + body["caller_id_number"].toString();
  }

  print(constant.didNumber);
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
      print(constant.answeredAgentNo);
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

  LeadStatusType statusType = LeadStatusType();
  LeadPersonalDetails leadPersonalDetails = LeadPersonalDetails(
    name: "",
    mobileNo: constant.callerNumber!,
  );
  LeadOwner leadOwnerData = LeadOwner(name: "", id: "", designation: "");

  Lead leadData = Lead(
      companyId: constant.companyID,
      id: leadId,
      source: constant.source.toString(),
      status: "Unallocated",
      subStatus: "",
      hotLead: false,
      createdOn: DateTime.now(),
      leadStatusType: LeadStatusType.FRESH,
      personalDetails: leadPersonalDetails,
      note: "",
      subsource: "",
      owner: leadOwnerData);

  LeadsSection leadsSection = LeadsSection();

  await constant.db
      .collection("Companies")
      .document(constant.companyID!)
      .collection("leads")
      .where("personalDetails.mobileNo", isEqualTo: constant.callerNumber)
      .get()
      .then((value) async {
    if (value.toString() == "[]") {
      constant.baseID = leadId;
      constant.isNewLeadCall = true;
      constant.leadAssigned = false;
      leadsSection.addLead(leadData);

//updating message as LEAD GENERATED when lead is not assigned to any agent

      Chatroom_Controller chatroom_controller = Chatroom_Controller();
      ChatModel chatModel = ChatModel(
          messageId: generateUniqueId(),
          senderId: "",
          dateTime: DateTime.now(),
          contentType: "systemGenerated",
          contentUrl: "",
          name: "",
          phoneNumber: "",
          callerNumber: constant.callerNumber,
          text: "Lead Generated",
          photoUrl: "",
          callID: constant.callId);

      chatroom_controller.updateLeadStatusInChatRoom(
          chatModel, constant.companyID.toString(), leadId);
    } else if (value.toString() != "[]" &&
        value[0]["owner"]["name"].toString() == "") {
      constant.baseID = value[0]["id"].toString();
      constant.isNewLeadCall = true;
      constant.leadAssigned = false;

//updating message in chatroom when call is missed and agent not assigned yet

      Chatroom_Controller chatroom_controller = Chatroom_Controller();
      ChatModel chatModel = ChatModel(
          messageId: generateUniqueId(),
          senderId: "",
          dateTime: DateTime.now(),
          contentType: "systemGenerated",
          contentUrl: "",
          name: "",
          phoneNumber: "",
          callerNumber: constant.callerNumber,
          text: "Call Missed & No Agent Assigned Yet!",
          photoUrl: "",
          callID: constant.callId);

      chatroom_controller.updateLeadStatusInChatRoom(
          chatModel, constant.companyID.toString(), constant.baseID.toString());
    }
  });

  return createCallDetails(context);
}

Future<Response> createCallDetails(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;

  CallRecord callrecord = CallRecord();

  CreateCallCollection callDetails = CreateCallCollection(
      companyID: constant.companyID,
      baseID: constant.baseID,
      duration: constant.callduration,
      source: constant.source,
      endStamp: constant.callEndStamp,
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
      callAnswerStamp: constant.callAnsweredStamp,
      callEndStamp: constant.callEndStamp,
      hangUpCause: constant.hangUpCause,
      recordingLink: constant.recordingLink,
      agentid: constant.empID,
      callStatus: constant.callStatus,
      callTranfer: false,
      callTransferIds: [],
      department: "Sales",
      isNewLeadCall: constant.isNewLeadCall,
      isSmsSent: false,
      callDateTime: DateTime.now().toString(),
      advertisedNumber: false,
      callDirection: constant.callDirection,
      currentCallStatus: "Ended",
      callId: constant.callId,
      leadAssigned: constant.leadAssigned);

  // if (constant.callStatus == "answered") {
  //   callrecord.updateCallRecord(callDetails);
  // }

  // else {
  //   callrecord.addCallRecord(callDetails);
  // }

// updating message as Call Received & Completed when call is pickedup and lead is assigned to the agent

  if (constant.leadAssigned == true && constant.isNewLeadCall == true) {
    Chatroom_Controller chatroom_controller = Chatroom_Controller();
    ChatModel chatModel = ChatModel(
        messageId: generateUniqueId(),
        senderId: constant.answeredAgentNo.toString(),
        dateTime: DateTime.now(),
        contentType: "systemGenerated",
        contentUrl: "",
        name: constant.empName.toString(),
        phoneNumber: constant.empPhoneno.toString(),
        text: "Lead Generated",
        photoUrl: "",
        callID: constant.callId);

    chatroom_controller.updateLeadStatusInChatRoom(
        chatModel, constant.companyID.toString(), constant.baseID.toString());
    ChatModel chatModel2 = ChatModel(
        messageId: generateUniqueId(),
        senderId: constant.answeredAgentNo.toString(),
        dateTime: DateTime.now(),
        contentType: "systemGenerated",
        contentUrl: "",
        name: constant.empName.toString(),
        phoneNumber: constant.empPhoneno.toString(),
        text: "Call Received & Completed",
        photoUrl: "",
        callID: constant.callId);
    chatroom_controller.updateLeadStatusInChatRoom(
        chatModel2, constant.companyID.toString(), constant.baseID.toString());
  } else if (constant.leadAssigned == true && constant.isNewLeadCall == false) {
    Chatroom_Controller chatroom_controller = Chatroom_Controller();
    ChatModel chatModel = ChatModel(
        messageId: generateUniqueId(),
        senderId: constant.answeredAgentNo.toString(),
        dateTime: DateTime.now(),
        contentType: "systemGenerated",
        contentUrl: "",
        name: constant.empName.toString(),
        phoneNumber: constant.empPhoneno.toString(),
        text: "Call Received & Completed",
        photoUrl: "",
        callID: constant.callId);
    chatroom_controller.updateLeadStatusInChatRoom(
        chatModel, constant.companyID.toString(), constant.baseID.toString());
  }

  callrecord.updateCallRecord(callDetails);

  return Response.json(body: "done");
}
