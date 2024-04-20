import 'package:first_api/utis/constants.dart';
import 'package:first_api/utis/generateID.dart';

import '../chatroom_model/chatroom_model.dart';

class Chatroom_Controller{

Constants c = Constants();


createLeadStatusInChatRoom(ChatModel chatModel,String companyID,String leadID){




c.db.collection("Companies").document(companyID).collection("leads").document(leadID).collection("Chatroom").document(leadID).collection("Messages").document(chatModel.messageId.toString()).set(

chatModel.toMap()

);




}



updateLeadStatusInChatRoom(ChatModel chatModel,String companyID,String leadID){


   




c.db.collection("Companies").document(companyID).collection("leads").document(leadID).collection("Chatroom").document(leadID).collection("Messages").document(chatModel.messageId.toString()).set(

chatModel.toMap()

);




}


}