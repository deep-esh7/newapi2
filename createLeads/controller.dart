import 'package:first_api/utis/constants.dart';

import 'leadModel.dart';
import 'package:firedart/firedart.dart';

class LeadsSection{


Constants c= Constants();

addLead(Lead LeadData) async {
  print(LeadData.toJson().toString());
  await c.db.collection("Companies").document(LeadData.companyId!).collection("leads").document(LeadData.id).set(LeadData.toMap());
}

updateLead(Lead LeadData) async {
  print(LeadData.toJson().toString());
  await c.db.collection("Companies").document(LeadData.companyId!).collection("leads").document(LeadData.id).update(LeadData.toMap());
}



}