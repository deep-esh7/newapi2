import 'dart:convert';

import 'package:firebase_dart/storage.dart';
import 'package:firedart/firedart.dart';
import 'package:first_api/utis/constants.dart';

import '../routes/db/fbse/index.dart';
import 'models.dart';

import 'package:http/http.dart' as http;

class CallRecord {
  Constants c = Constants();

  addCallRecord(CreateCallCollection callDetails) {
    c.db
        .collection("Companies")
        .document(callDetails.companyID!)
        .collection("conversations")
        .document("telephony")
        .collection("call collection")
        .document(callDetails.callId!)
        .set(callDetails.toMap());
  }

// swapping after providing numbers list for round robin from agent
  updateAgentMap(
      Map<String, dynamic> originalMap, var companyid, var category) async {
    Map<String, dynamic> shiftedMap = {};

    // Get the keys of the original map
    List<String> keys = originalMap.keys.toList();

    // Shift each key one place forward
    for (int i = 0; i < keys.length; i++) {
      String currentKey = keys[i];
      String nextKey = keys[(i + 1) % keys.length];
      shiftedMap[nextKey] = originalMap[currentKey];
    }

    await c.db
        .collection("Companies")
        .document(companyid.toString())
        .collection("conversations")
        .document("telephony")
        .collection("telephony")
        .document("conditions")
        .collection("conditions")
        .document(category.toString())
        .update({"agents": shiftedMap});
  }

  // updating call record

  updateCallRecord(CreateCallCollection callDetails) async {
    var callDetails2 = callDetails.toMap();

    // Create a copy of the map
    var callDetailsCopy = Map.from(callDetails2);

    // Iterate over the copy and remove null values
    callDetailsCopy.forEach((key, value) {
      if (value == null) {
        callDetails2.remove(key); // Modify the original map
      }
    });

    print(callDetails2);

    await c.db
        .collection("Companies")
        .document(callDetails.companyID!)
        .collection("conversations")
        .document("telephony")
        .collection("call collection")
        .document(callDetails.callId!)
        .update(callDetails2)
        .then((_) async {
      // Perform further actions after the update
      // Here, I've included the commented out code that you provided
      if ((callDetails.recordingLink != null) &&
          (callDetails.recordingLink!.isNotEmpty &&
              callDetails.recordingLink != "")) {
        // Delayed execution after 20 seconds
        await Future.delayed(Duration(seconds: 20), () {
          updateRecordingLink(
              callDetails.companyID.toString(),
              callDetails.callId.toString(),
              callDetails.recordingLink.toString());
        });
      }
    }).catchError((error) {
      print("Error updating call record: $error");
      // Handle the error accordingly
    });
  }

  updateRecordingLink(
      String companyId, String callId, String recordingLink) async {
    print("recording url : $recordingLink");

    var storagePath = "Companies/$companyId/CallRecordingCollection/$callId";
    try {
      // Fetch the file from the internet
      var response = await http.get(Uri.parse(recordingLink));
      if (response.statusCode == 200) {
        // Create a reference to the Firebase Storage location

        var ref = FirebaseStorage.instance.ref().child(storagePath);
        // Upload the file to Firebase Storage
        await ref.putData(response.bodyBytes);
        // Get the download URL of the uploaded file
        await ref.getDownloadURL().then((value) async {
          c.db
              .collection("Companies")
              .document(companyId)
              .collection("conversations")
              .document("telephony")
              .collection("call collection")
              .document(callId)
              .update({"recordingLink": value.toString()});
          print("recording uploaded");
        });
      } else {
        print(response.statusCode);
        print('Failed to fetch the file from the internet.');
      }
    } catch (error) {
      print('Error uploading file: $error');
    }
  }
}
