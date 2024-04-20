// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// enum ChatContentType {
//   none,
//   audio,
//   video,
//   photo,
//   document,
//   text,
//   sytemGenerated,
// }

class ChatModel {
  String messageId;
  String senderId;
  DateTime dateTime;
  String contentType;
  String contentUrl;
  String? text;
  String? callID;

  String name;
  String phoneNumber;
  String? photoUrl;
  String? callerNumber;
  ChatModel({
    required this.messageId,
    required this.senderId,
    required this.dateTime,
    required this.contentType,
    required this.contentUrl,
    this.text,
    this.callID,
    required this.name,
    required this.phoneNumber,
    this.photoUrl,
    this.callerNumber,
  });

  ChatModel copyWith({
    String? messageId,
    String? senderId,
    DateTime? dateTime,
    String? contentType,
    String? contentUrl,
    String? text,
    String? callID,
    String? name,
    String? phoneNumber,
    String? photoUrl,
    String? callerNumber,
  }) {
    return ChatModel(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      dateTime: dateTime ?? this.dateTime,
      contentType: contentType ?? this.contentType,
      contentUrl: contentUrl ?? this.contentUrl,
      text: text ?? this.text,
      callID: callID ?? this.callID,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      callerNumber: callerNumber ?? this.callerNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'senderId': senderId,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'contentType': contentType,
      'contentUrl': contentUrl,
      'text': text,
      'callID': callID,
      'name': name,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'callerNumber': callerNumber,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      messageId: map['messageId'] as String,
      senderId: map['senderId'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      contentType: map['contentType'] as String,
      contentUrl: map['contentUrl'] as String,
      text: map['text'] != null ? map['text'] as String : null,
      callID: map['callID'] != null ? map['callID'] as String : null,
      name: map['name'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      callerNumber: map['callerNumber'] != null ? map['callerNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(messageId: $messageId, senderId: $senderId, dateTime: $dateTime, contentType: $contentType, contentUrl: $contentUrl, text: $text, callID: $callID, name: $name, phoneNumber: $phoneNumber, photoUrl: $photoUrl, callerNumber: $callerNumber)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.messageId == messageId &&
      other.senderId == senderId &&
      other.dateTime == dateTime &&
      other.contentType == contentType &&
      other.contentUrl == contentUrl &&
      other.text == text &&
      other.callID == callID &&
      other.name == name &&
      other.phoneNumber == phoneNumber &&
      other.photoUrl == photoUrl &&
      other.callerNumber == callerNumber;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
      senderId.hashCode ^
      dateTime.hashCode ^
      contentType.hashCode ^
      contentUrl.hashCode ^
      text.hashCode ^
      callID.hashCode ^
      name.hashCode ^
      phoneNumber.hashCode ^
      photoUrl.hashCode ^
      callerNumber.hashCode;
  }
}
