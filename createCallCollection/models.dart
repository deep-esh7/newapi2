// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:collection/collection.dart';

class CreateCallCollection {
  String? companyID;
  String? cuid;
  String? callerDid;
  String? callerNumber;
  String? agentDid;
  String? callStartStamp;
  String? recordingLink;
  String? agentid;
  String? callStatus;
  bool? callTranfer;
  List<String>? callTransferIds;
  String? department;
  bool? isNewLeadCall;
  String? baseID;
  bool? isSmsSent;
  String? callDateTime;
  bool? advertisedNumber;
  String? callDirection;
  String? endStamp;
  String? duration;
  String? source;
  String? ivrName;
  String? ivrId;
  String? agentPhoneNo;
  String? agentName;
  String? agentDesignation;
  String? callEndStamp;
  String? callAnswerStamp;
  String? hangUpCause;
  bool? leadAssigned;
  String? currentCallStatus;
  String? callerName;
  String? callId;
  String? condtitionType;
  CreateCallCollection({
    this.companyID,
    this.cuid,
    this.callerDid,
    this.callerNumber,
    this.agentDid,
    this.callStartStamp,
    this.recordingLink,
    this.agentid,
    this.callStatus,
    this.callTranfer,
    this.callTransferIds,
    this.department,
    this.isNewLeadCall,
    this.baseID,
    this.isSmsSent,
    this.callDateTime,
    this.advertisedNumber,
    this.callDirection,
    this.endStamp,
    this.duration,
    this.source,
    this.ivrName,
    this.ivrId,
    this.agentPhoneNo,
    this.agentName,
    this.agentDesignation,
    this.callEndStamp,
    this.callAnswerStamp,
    this.hangUpCause,
    this.leadAssigned,
    this.currentCallStatus,
    this.callerName,
    this.callId,
    this.condtitionType,
  });

  CreateCallCollection copyWith({
    String? companyID,
    String? cuid,
    String? callerDid,
    String? callerNumber,
    String? agentDid,
    String? callStartStamp,
    String? recordingLink,
    String? agentid,
    String? callStatus,
    bool? callTranfer,
    List<String>? callTransferIds,
    String? department,
    bool? isNewLeadCall,
    String? baseID,
    bool? isSmsSent,
    String? callDateTime,
    bool? advertisedNumber,
    String? callDirection,
    String? endStamp,
    String? duration,
    String? source,
    String? ivrName,
    String? ivrId,
    String? agentPhoneNo,
    String? agentName,
    String? agentDesignation,
    String? callEndStamp,
    String? callAnswerStamp,
    String? hangUpCause,
    bool? leadAssigned,
    String? currentCallStatus,
    String? callerName,
    String? callId,
    String? condtitionType,
  }) {
    return CreateCallCollection(
      companyID: companyID ?? this.companyID,
      cuid: cuid ?? this.cuid,
      callerDid: callerDid ?? this.callerDid,
      callerNumber: callerNumber ?? this.callerNumber,
      agentDid: agentDid ?? this.agentDid,
      callStartStamp: callStartStamp ?? this.callStartStamp,
      recordingLink: recordingLink ?? this.recordingLink,
      agentid: agentid ?? this.agentid,
      callStatus: callStatus ?? this.callStatus,
      callTranfer: callTranfer ?? this.callTranfer,
      callTransferIds: callTransferIds ?? this.callTransferIds,
      department: department ?? this.department,
      isNewLeadCall: isNewLeadCall ?? this.isNewLeadCall,
      baseID: baseID ?? this.baseID,
      isSmsSent: isSmsSent ?? this.isSmsSent,
      callDateTime: callDateTime ?? this.callDateTime,
      advertisedNumber: advertisedNumber ?? this.advertisedNumber,
      callDirection: callDirection ?? this.callDirection,
      endStamp: endStamp ?? this.endStamp,
      duration: duration ?? this.duration,
      source: source ?? this.source,
      ivrName: ivrName ?? this.ivrName,
      ivrId: ivrId ?? this.ivrId,
      agentPhoneNo: agentPhoneNo ?? this.agentPhoneNo,
      agentName: agentName ?? this.agentName,
      agentDesignation: agentDesignation ?? this.agentDesignation,
      callEndStamp: callEndStamp ?? this.callEndStamp,
      callAnswerStamp: callAnswerStamp ?? this.callAnswerStamp,
      hangUpCause: hangUpCause ?? this.hangUpCause,
      leadAssigned: leadAssigned ?? this.leadAssigned,
      currentCallStatus: currentCallStatus ?? this.currentCallStatus,
      callerName: callerName ?? this.callerName,
      callId: callId ?? this.callId,
      condtitionType: condtitionType ?? this.condtitionType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'companyID': companyID,
      'cuid': cuid,
      'callerDid': callerDid,
      'callerNumber': callerNumber,
      'agentDid': agentDid,
      'callStartStamp': callStartStamp,
      'recordingLink': recordingLink,
      'agentid': agentid,
      'callStatus': callStatus,
      'callTranfer': callTranfer,
      'callTransferIds': callTransferIds,
      'department': department,
      'isNewLeadCall': isNewLeadCall,
      'baseID': baseID,
      'isSmsSent': isSmsSent,
      'callDateTime': callDateTime,
      'advertisedNumber': advertisedNumber,
      'callDirection': callDirection,
      'endStamp': endStamp,
      'duration': duration,
      'source': source,
      'ivrName': ivrName,
      'ivrId': ivrId,
      'agentPhoneNo': agentPhoneNo,
      'agentName': agentName,
      'agentDesignation': agentDesignation,
      'callEndStamp': callEndStamp,
      'callAnswerStamp': callAnswerStamp,
      'hangUpCause': hangUpCause,
      'leadAssigned': leadAssigned,
      'currentCallStatus': currentCallStatus,
      'callerName': callerName,
      'callId': callId,
      'condtitionType': condtitionType,
    };
  }

  factory CreateCallCollection.fromMap(Map<String, dynamic> map) {
    return CreateCallCollection(
      companyID: map['companyID'] != null ? map['companyID'] as String : null,
      cuid: map['cuid'] != null ? map['cuid'] as String : null,
      callerDid: map['callerDid'] != null ? map['callerDid'] as String : null,
      callerNumber:
          map['callerNumber'] != null ? map['callerNumber'] as String : null,
      agentDid: map['agentDid'] != null ? map['agentDid'] as String : null,
      callStartStamp: map['callStartStamp'] != null
          ? map['callStartStamp'] as String
          : null,
      recordingLink:
          map['recordingLink'] != null ? map['recordingLink'] as String : null,
      agentid: map['agentid'] != null ? map['agentid'] as String : null,
      callStatus:
          map['callStatus'] != null ? map['callStatus'] as String : null,
      callTranfer:
          map['callTranfer'] != null ? map['callTranfer'] as bool : null,
      callTransferIds: map['callTransferIds'] != null
          ? List<String>.from((map['callTransferIds'] as List<String>))
          : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      isNewLeadCall:
          map['isNewLeadCall'] != null ? map['isNewLeadCall'] as bool : null,
      baseID: map['baseID'] != null ? map['baseID'] as String : null,
      isSmsSent: map['isSmsSent'] != null ? map['isSmsSent'] as bool : null,
      callDateTime:
          map['callDateTime'] != null ? map['callDateTime'] as String : null,
      advertisedNumber: map['advertisedNumber'] != null
          ? map['advertisedNumber'] as bool
          : null,
      callDirection:
          map['callDirection'] != null ? map['callDirection'] as String : null,
      endStamp: map['endStamp'] != null ? map['endStamp'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      source: map['source'] != null ? map['source'] as String : null,
      ivrName: map['ivrName'] != null ? map['ivrName'] as String : null,
      ivrId: map['ivrId'] != null ? map['ivrId'] as String : null,
      agentPhoneNo:
          map['agentPhoneNo'] != null ? map['agentPhoneNo'] as String : null,
      agentName: map['agentName'] != null ? map['agentName'] as String : null,
      agentDesignation: map['agentDesignation'] != null
          ? map['agentDesignation'] as String
          : null,
      callEndStamp:
          map['callEndStamp'] != null ? map['callEndStamp'] as String : null,
      callAnswerStamp: map['callAnswerStamp'] != null
          ? map['callAnswerStamp'] as String
          : null,
      hangUpCause:
          map['hangUpCause'] != null ? map['hangUpCause'] as String : null,
      leadAssigned:
          map['leadAssigned'] != null ? map['leadAssigned'] as bool : null,
      currentCallStatus: map['currentCallStatus'] != null
          ? map['currentCallStatus'] as String
          : null,
      callerName:
          map['callerName'] != null ? map['callerName'] as String : null,
      callId: map['callId'] != null ? map['callId'] as String : null,
      condtitionType: map['condtitionType'] != null
          ? map['condtitionType'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateCallCollection.fromJson(String source) =>
      CreateCallCollection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreateCallCollection(companyID: $companyID, cuid: $cuid, callerDid: $callerDid, callerNumber: $callerNumber, agentDid: $agentDid, callStartStamp: $callStartStamp, recordingLink: $recordingLink, agentid: $agentid, callStatus: $callStatus, callTranfer: $callTranfer, callTransferIds: $callTransferIds, department: $department, isNewLeadCall: $isNewLeadCall, baseID: $baseID, isSmsSent: $isSmsSent, callDateTime: $callDateTime, advertisedNumber: $advertisedNumber, callDirection: $callDirection, endStamp: $endStamp, duration: $duration, source: $source, ivrName: $ivrName, ivrId: $ivrId, agentPhoneNo: $agentPhoneNo, agentName: $agentName, agentDesignation: $agentDesignation, callEndStamp: $callEndStamp, callAnswerStamp: $callAnswerStamp, hangUpCause: $hangUpCause, leadAssigned: $leadAssigned, currentCallStatus: $currentCallStatus, callerName: $callerName, callId: $callId, condtitionType: $condtitionType)';
  }

  @override
  bool operator ==(covariant CreateCallCollection other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.companyID == companyID &&
        other.cuid == cuid &&
        other.callerDid == callerDid &&
        other.callerNumber == callerNumber &&
        other.agentDid == agentDid &&
        other.callStartStamp == callStartStamp &&
        other.recordingLink == recordingLink &&
        other.agentid == agentid &&
        other.callStatus == callStatus &&
        other.callTranfer == callTranfer &&
        listEquals(other.callTransferIds, callTransferIds) &&
        other.department == department &&
        other.isNewLeadCall == isNewLeadCall &&
        other.baseID == baseID &&
        other.isSmsSent == isSmsSent &&
        other.callDateTime == callDateTime &&
        other.advertisedNumber == advertisedNumber &&
        other.callDirection == callDirection &&
        other.endStamp == endStamp &&
        other.duration == duration &&
        other.source == source &&
        other.ivrName == ivrName &&
        other.ivrId == ivrId &&
        other.agentPhoneNo == agentPhoneNo &&
        other.agentName == agentName &&
        other.agentDesignation == agentDesignation &&
        other.callEndStamp == callEndStamp &&
        other.callAnswerStamp == callAnswerStamp &&
        other.hangUpCause == hangUpCause &&
        other.leadAssigned == leadAssigned &&
        other.currentCallStatus == currentCallStatus &&
        other.callerName == callerName &&
        other.callId == callId &&
        other.condtitionType == condtitionType;
  }

  @override
  int get hashCode {
    return companyID.hashCode ^
        cuid.hashCode ^
        callerDid.hashCode ^
        callerNumber.hashCode ^
        agentDid.hashCode ^
        callStartStamp.hashCode ^
        recordingLink.hashCode ^
        agentid.hashCode ^
        callStatus.hashCode ^
        callTranfer.hashCode ^
        callTransferIds.hashCode ^
        department.hashCode ^
        isNewLeadCall.hashCode ^
        baseID.hashCode ^
        isSmsSent.hashCode ^
        callDateTime.hashCode ^
        advertisedNumber.hashCode ^
        callDirection.hashCode ^
        endStamp.hashCode ^
        duration.hashCode ^
        source.hashCode ^
        ivrName.hashCode ^
        ivrId.hashCode ^
        agentPhoneNo.hashCode ^
        agentName.hashCode ^
        agentDesignation.hashCode ^
        callEndStamp.hashCode ^
        callAnswerStamp.hashCode ^
        hangUpCause.hashCode ^
        leadAssigned.hashCode ^
        currentCallStatus.hashCode ^
        callerName.hashCode ^
        callId.hashCode ^
        condtitionType.hashCode;
  }
}
